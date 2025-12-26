<#
=============================================================================================
Name:           Automate Microsoft 365 User Offboarding (Hardened)
Version:        2.3
Default Mode:   SAFE (WhatIf)

Changes in 2.3:
- Removed: remove-all-groups, remove mobile phone, remove app role assignments (as requested)
- Added: targeted group removal (allowlist) for Azure group-based licensing
- Menu preserved: individual actions + Run All
- Run All order: group removal BEFORE license removal to reduce group-license removal errors
=============================================================================================
#>

param(
    [string]$TenantId,
    [string]$ClientId,
    [string]$CertificateThumbprint,
    [string]$CSVFilePath,
    [string]$UPNs,
    [switch]$Force
)

# SAFE BY DEFAULT
$WhatIf = -not $Force

# ================= LICENSE GROUP ALLOWLIST =================
# Only these groups will be removed when choosing the targeted group-removal step.
$LicenseRemovalGroups = @(
    "O365 Microsoft Teams Phone Standard",
    "O365 partial M365 E3 and Audio Conf"
)

# ================= LOGGING =================
$Location  = Get-Location
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$ExportCSV     = "$Location\M365_Offboard_Status_$Timestamp.csv"
$ErrorsLogFile = "$Location\M365_Offboard_Errors_$Timestamp.log"
$PasswordLog   = "$Location\M365_Offboard_Passwords_$Timestamp.log"
$InvalidUserLog= "$Location\M365_Offboard_InvalidUsers_$Timestamp.log"

function Write-AuditLog {
    param([string]$Message)
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) | $Message" |
        Out-File $ErrorsLogFile -Append
}

function Invoke-SafeAction {
    param(
        [string]$Action,
        [scriptblock]$Code
    )

    if ($WhatIf) {
        Write-Host "[WHATIF] $Action" -ForegroundColor Yellow
        Write-AuditLog "[WHATIF] $Action"
        return "WhatIf"
    }

    try {
        & $Code
        Write-AuditLog "[SUCCESS] $Action"
        return "Success"
    }
    catch {
        Write-AuditLog "[FAILED] $Action | $($_.Exception.Message)"
        return "Failed"
    }
}

function ConnectModules {
    Import-Module Microsoft.Graph -ErrorAction Stop
    Import-Module ExchangeOnlineManagement -ErrorAction Stop

    if ($TenantId -and $ClientId -and $CertificateThumbprint) {
        Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -CertificateThumbprint $CertificateThumbprint
        Connect-ExchangeOnline -AppId $ClientId -CertificateThumbprint $CertificateThumbprint `
            -Organization (Get-MgDomain | Where-Object IsInitial).Id -ShowBanner:$false
    }
    else {
        Connect-MgGraph -Scopes Directory.ReadWrite.All,User.EnableDisableAccount.All,RoleManagement.ReadWrite.Directory
        Connect-ExchangeOnline -ShowBanner:$false
    }
}

function DisconnectModules {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
    Disconnect-ExchangeOnline -Confirm:$false
    Exit
}

# ================= ACTIONS =================

function DisableUser {
    Invoke-SafeAction "Disable account $UPN" {
        Update-MgUser -UserId $UPN -AccountEnabled:$false
    }
}

function ResetPassword {
    $pw = -join ((48..57)+(65..90)+(97..122) | Get-Random -Count 14 | ForEach-Object {[char]$_})
    $secure = ConvertTo-SecureString $pw -AsPlainText -Force

    Invoke-SafeAction "Reset password for $UPN" {
        Update-MgUser -UserId $UPN -PasswordProfile @{
            password = $secure
            forceChangePasswordNextSignIn = $true
        }
        "$UPN : $pw" | Out-File $PasswordLog -Append
    }
}

function RemoveAdminRoles {
    Invoke-SafeAction "Remove admin roles for $UPN" {
        $id = (Get-MgUser -UserId $UPN).Id
        Get-MgUserMemberOf -UserId $UPN |
            Where-Object {$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.directoryRole'} |
            ForEach-Object {
                Remove-MgDirectoryRoleMemberByRef -DirectoryRoleId $_.Id -DirectoryObjectId $id
            }
    }
}

function HideFromGAL {
    Invoke-SafeAction "Hide $UPN from GAL" {
        Set-Mailbox -Identity $UPN -HiddenFromAddressListsEnabled $true
    }
}

function DeleteInboxRules {
    Invoke-SafeAction "Delete inbox rules for $UPN" {
        $rules = Get-InboxRule -Mailbox $UPN -ErrorAction SilentlyContinue
        if (-not $rules) { return }
        $rules | Remove-InboxRule -Confirm:$false
    }
}

function ConvertToShared {
    Invoke-SafeAction "Convert mailbox to shared for $UPN" {
        Set-Mailbox -Identity $UPN -Type Shared
    }
}

function RemoveTargetedLicenseGroups {
    Invoke-SafeAction "Remove targeted license groups for $UPN" {

        $user = Get-MgUser -UserId $UPN
        $memberships = Get-MgUserMemberOf -UserId $UPN |
            Where-Object { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group' }

        $found = 0
        foreach ($g in $memberships) {
            $name = $g.AdditionalProperties.displayName
            if ($LicenseRemovalGroups -contains $name) {
                $found++
                Write-AuditLog "[$UPN] Removing from license group: $name"
                Remove-MgGroupMemberByRef -GroupId $g.Id -DirectoryObjectId $user.Id -ErrorAction Stop
            }
        }

        if ($found -eq 0) {
            Write-AuditLog "[$UPN] No targeted license groups found to remove."
        }
    }
}

function RemoveLicenses {
    Invoke-SafeAction "Remove licenses for $UPN" {
        $lic = Get-MgUserLicenseDetail -UserId $UPN
        if (-not $lic) { return }

        # If licenses are assigned via group-based licensing, this may fail.
        Set-MgUserLicense -UserId $UPN -RemoveLicenses @($lic.SkuId) -AddLicenses @()
    }
}

function SignOutSessions {
    Invoke-SafeAction "Sign out all sessions for $UPN" {
        Revoke-MgUserSignInSession -UserId $UPN | Out-Null
    }
}

function AddManagerDelegate {
    Invoke-SafeAction "Add manager as delegate for $UPN" {

        $mgrObj = Get-MgUserManager -UserId $UPN -ErrorAction SilentlyContinue
        if (-not $mgrObj) {
            Write-AuditLog "[$UPN] No manager found in Azure AD. Delegate step skipped."
            return
        }

        # Try UPN first; fallback to Id
        $mgrUpn = $mgrObj.AdditionalProperties.userPrincipalName
        if (-not $mgrUpn) {
            Write-AuditLog "[$UPN] Manager UPN not available; using Manager Id for mailbox permission."
            $mgrUpn = $mgrObj.Id
        }

        Add-MailboxPermission -Identity $UPN -User $mgrUpn `
            -AccessRights FullAccess -InheritanceType All -AutoMapping:$false
    }
}

# ================= MAIN =================

function Main {
    ConnectModules

    if ($CSVFilePath) {
        $UPNs = (Import-Csv $CSVFilePath).UserPrincipalName
    }
    elseif ($UPNs) {
        $UPNs = $UPNs -split ','
    }
    else {
        Write-Host "No users provided." -ForegroundColor Red
        DisconnectModules
    }

    Write-Host "`nSelect Offboarding Action:" -ForegroundColor Cyan
    Write-Host "1  Disable account"
    Write-Host "2  Reset password"
    Write-Host "3  Strip admin roles"
    Write-Host "4  Hide from GAL"
    Write-Host "5  Delete inbox rules"
    Write-Host "6  Convert to shared mailbox"
    Write-Host "7  Remove targeted license-assignment groups"
    Write-Host "8  Remove licenses"
    Write-Host "9  Force sign-out everywhere"
    Write-Host "10 Add manager as delegate of shared mailbox"
    Write-Host "11 Run ALL above (recommended order)"
    $choice = Read-Host "Enter selection (comma-separated allowed)"

    if (-not $choice) {
        Write-Host "No selection provided." -ForegroundColor Red
        DisconnectModules
    }

    $actions = $choice -split ','

    Write-Host "`nUsers to process:" -ForegroundColor Cyan
    $UPNs | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }

    if ($Force) {
        Write-Host "`nMODE: LIVE (DESTRUCTIVE)" -ForegroundColor Red
        $confirm = Read-Host "TYPE OFFBOARD TO EXECUTE"
        if ($confirm -ne "OFFBOARD") {
            Write-Host "Execution cancelled." -ForegroundColor Red
            DisconnectModules
        }
    }
    else {
        Write-Host "`nMODE: SAFE / WHATIF (no changes will be made)" -ForegroundColor Green
    }

    foreach ($UPN in $UPNs) {
        $UPN = $UPN.Trim()
        if (-not $UPN) { continue }

        $user = Get-MgUser -UserId $UPN -ErrorAction SilentlyContinue
        if (-not $user) {
            "$UPN" | Out-File $InvalidUserLog -Append
            Write-AuditLog "[INVALID] User not found: $UPN"
            continue
        }

        $status = [ordered]@{
            UPN = $UPN
            DisableAccount = ""
            ResetPassword  = ""
            StripAdminRoles= ""
            HideFromGAL    = ""
            DeleteInboxRules = ""
            ConvertToShared  = ""
            RemoveTargetedLicenseGroups = ""
            RemoveLicenses = ""
            SignOutSessions = ""
            AddManagerDelegate = ""
        }

        foreach ($a in $actions) {
            switch ($a.Trim()) {
                1  { $status.DisableAccount = DisableUser }
                2  { $status.ResetPassword  = ResetPassword }
                3  { $status.StripAdminRoles= RemoveAdminRoles }
                4  { $status.HideFromGAL    = HideFromGAL }
                5  { $status.DeleteInboxRules = DeleteInboxRules }
                6  { $status.ConvertToShared  = ConvertToShared }
                7  { $status.RemoveTargetedLicenseGroups = RemoveTargetedLicenseGroups }
                8  { $status.RemoveLicenses = RemoveLicenses }
                9  { $status.SignOutSessions = SignOutSessions }
                10 { $status.AddManagerDelegate = AddManagerDelegate }
                11 {
                    # Recommended order:
                    $status.DisableAccount = DisableUser
                    $status.ResetPassword  = ResetPassword
                    $status.StripAdminRoles= RemoveAdminRoles
                    $status.HideFromGAL    = HideFromGAL
                    $status.DeleteInboxRules = DeleteInboxRules
                    $status.ConvertToShared  = ConvertToShared
                    $status.RemoveTargetedLicenseGroups = RemoveTargetedLicenseGroups
                    $status.RemoveLicenses = RemoveLicenses
                    $status.SignOutSessions = SignOutSessions
                    $status.AddManagerDelegate = AddManagerDelegate
                }
                default {
                    Write-Host "Invalid action: $a" -ForegroundColor Red
                }
            }
        }

        [pscustomobject]$status | Export-Csv -Path $ExportCSV -Append -NoTypeInformation
    }

    Write-Host "`nCompleted." -ForegroundColor Green
    Write-Host "Status CSV : $ExportCSV" -ForegroundColor Yellow
    Write-Host "Errors Log : $ErrorsLogFile" -ForegroundColor Yellow
    if (Test-Path $PasswordLog) { Write-Host "Passwords  : $PasswordLog" -ForegroundColor Yellow }
    if (Test-Path $InvalidUserLog) { Write-Host "Invalids   : $InvalidUserLog" -ForegroundColor Yellow }

    # DisconnectModules
}

Main

<#
USAGE EXAMPLES (dot-source then run)
. .\M365UserOffBoarding-Hardened.ps1

# SAFE / WhatIf mode (default)
.\M365UserOffBoarding-Hardened.ps1 -UPNs "user1@domain.com,user2@domain.com"

# LIVE execution (requires confirmation prompt)
.\M365UserOffBoarding-Hardened.ps1 -UPNs "user1@domain.com" -Force

# CSV mode
.\M365UserOffBoarding-Hardened.ps1 -CSVFilePath "C:\temp\upns.csv" -Force
#>
