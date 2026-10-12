# Filename: Set-SharedMailboxMember.ps1
# Revision : 1.1.0
# Description : Add or remove a user from a shared mailbox (FullAccess and/or SendAs). Prompts for anything not passed as a parameter.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-10-12
# Modified Date : 2026-10-12
# Changelog :
# 1.0.0 initial release
# 1.1.0 default to browser/SSO sign-in (device code now opt-in via -UseDeviceCode), add -AdminUpn, log confirmation answer

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    # Shared mailbox email address
    [string]$Mailbox,

    # User email, UPN, or display name
    [string]$User,

    # Add or Remove
    [ValidateSet('Add', 'Remove')]
    [string]$Action,

    # Which permissions to change (default: both)
    [ValidateSet('FullAccess', 'SendAs')]
    [string[]]$Permission = @('FullAccess', 'SendAs'),

    # Admin UPN to sign in with (enables silent/SSO sign-in when a session exists)
    [string]$AdminUpn,

    # Use device-code sign-in instead of the browser/SSO prompt
    [switch]$UseDeviceCode
)

$ErrorActionPreference = 'Stop'

# Module check and import
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement..." -ForegroundColor Cyan
    Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
}
if (-not (Get-Module -Name ExchangeOnlineManagement)) {
    Import-Module ExchangeOnlineManagement
}

# Log file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logDir = $psexports
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path 'c:\temp\psexports' -Force | Out-Null
	$logdir = 'c:\temp\psexports'
}
$logExport = Join-Path $logDir "SetSharedMailboxMember_$timestamp.log"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $logExport -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
}

function Resolve-UserRecipient {
    param([string]$Identifier)

    $recipient = Get-Recipient -Identity $Identifier -ErrorAction SilentlyContinue
    if ($recipient) { return $recipient }

    $safe = $Identifier -replace "'", "''"
    $matches = @(Get-Recipient -Filter "DisplayName -like '*$safe*' -or PrimarySmtpAddress -like '*$safe*'" -ErrorAction SilentlyContinue)
    if ($matches.Count -eq 1) { return $matches[0] }
    if ($matches.Count -gt 1) {
        Write-Log "Multiple matches for '$Identifier':" "Yellow"
        for ($i = 0; $i -lt $matches.Count; $i++) {
            Write-Log "  $($i + 1). $($matches[$i].DisplayName) ($($matches[$i].PrimarySmtpAddress))" "Yellow"
        }
        $sel = Read-Host "Select which user (enter number)"
        if ($sel -match '^\d+$' -and [int]$sel -ge 1 -and [int]$sel -le $matches.Count) {
            return $matches[[int]$sel - 1]
        }
    }
    return $null
}

# Connect only if not already connected
Write-Log "=== Set-SharedMailboxMember started $(Get-Date) ===" "Cyan"
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Write-Log "NOTE: Authenticate with your Exchange Online admin account." "Yellow"
    if ($UseDeviceCode) {
        Connect-ExchangeOnline -Device -ShowBanner:$false
    } elseif ($AdminUpn) {
        Connect-ExchangeOnline -UserPrincipalName $AdminUpn -ShowBanner:$false
    } else {
        Connect-ExchangeOnline -ShowBanner:$false
    }
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Log "ERROR: Failed to connect to Exchange Online." "Red"
        exit 1
    }
}
Write-Log "Connected as: $($exoConnection.UserPrincipalName)" "Green"

# Prompt for anything missing
if (-not $Action) {
    do {
        $choice = Read-Host "Action - (A)dd or (R)emove"
    } until ($choice -match '^[AaRr]')
    $Action = if ($choice -match '^[Aa]') { 'Add' } else { 'Remove' }
}

while ($true) {
    if (-not $Mailbox) { $Mailbox = Read-Host "Enter shared mailbox email address" }
    $mbx = Get-Mailbox -Identity $Mailbox -ErrorAction SilentlyContinue
    if ($mbx -and $mbx.RecipientTypeDetails -eq 'SharedMailbox') { break }
    if (-not $mbx) {
        Write-Log "ERROR: Mailbox '$Mailbox' not found." "Red"
    } else {
        Write-Log "ERROR: '$Mailbox' is not a shared mailbox (type: $($mbx.RecipientTypeDetails))." "Red"
    }
    $Mailbox = $null
}
Write-Log "Shared mailbox: $($mbx.PrimarySmtpAddress)" "Green"

while ($true) {
    if (-not $User) { $User = Read-Host "Enter user email, username, or display name" }
    $target = Resolve-UserRecipient -Identifier $User
    if ($target) { break }
    Write-Log "ERROR: Could not resolve '$User'." "Red"
    $User = $null
}
$targetSmtp = $target.PrimarySmtpAddress.ToString()
Write-Log "User: $($target.DisplayName) ($targetSmtp)" "Green"

# Confirm
Write-Log "`nAbout to $($Action.ToUpper()) $($Permission -join ' + ') for $targetSmtp on $($mbx.PrimarySmtpAddress)" "Cyan"
if (-not $WhatIfPreference) {
    $confirm = Read-Host "Proceed? (Y/N)"
    Add-Content -Path $logExport -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  Confirmation answer: $confirm"
    if ($confirm -notmatch '^[Yy]') {
        Write-Log "Cancelled." "Yellow"
        exit 0
    }
}

# Apply changes
$failed = 0
foreach ($perm in $Permission) {
    try {
        if ($perm -eq 'FullAccess') {
            $existing = Get-MailboxPermission -Identity $mbx.Identity -User $targetSmtp -ErrorAction SilentlyContinue |
                Where-Object { $_.AccessRights -contains 'FullAccess' -and -not $_.Deny }
            $has = [bool]$existing
        } else {
            $existing = Get-RecipientPermission -Identity $mbx.Identity -Trustee $targetSmtp -ErrorAction SilentlyContinue |
                Where-Object { $_.AccessRights -contains 'SendAs' }
            $has = [bool]$existing
        }

        if ($Action -eq 'Add' -and $has) {
            Write-Log "  • $perm : already present, skipped" "Yellow"
            continue
        }
        if ($Action -eq 'Remove' -and -not $has) {
            Write-Log "  • $perm : not present, skipped" "Yellow"
            continue
        }
        if (-not $PSCmdlet.ShouldProcess("$($mbx.PrimarySmtpAddress)", "$Action $perm for $targetSmtp")) { continue }

        switch ("$Action|$perm") {
            'Add|FullAccess' {
                Add-MailboxPermission -Identity $mbx.Identity -User $targetSmtp -AccessRights FullAccess -InheritanceType All -AutoMapping $true -Confirm:$false | Out-Null
            }
            'Add|SendAs' {
                Add-RecipientPermission -Identity $mbx.Identity -Trustee $targetSmtp -AccessRights SendAs -Confirm:$false | Out-Null
            }
            'Remove|FullAccess' {
                Remove-MailboxPermission -Identity $mbx.Identity -User $targetSmtp -AccessRights FullAccess -InheritanceType All -Confirm:$false | Out-Null
            }
            'Remove|SendAs' {
                Remove-RecipientPermission -Identity $mbx.Identity -Trustee $targetSmtp -AccessRights SendAs -Confirm:$false | Out-Null
            }
        }
        Write-Log "  • $perm : $Action succeeded" "Green"
    } catch {
        $failed++
        Write-Log "  • $perm : $Action FAILED - $($_.Exception.Message)" "Red"
    }
}

Write-Log "`nLog file: $logExport" "Cyan"
if ($failed -gt 0) {
    Write-Log "=== Completed with $failed error(s) ===" "Red"
    exit 1
}
Write-Log "=== Script completed ===" "Green"

# Example Usage:
#   .\Set-SharedMailboxMember.ps1
#   .\Set-SharedMailboxMember.ps1 -Action Add -Mailbox shared@cooperservices.com -User jdoe
#   .\Set-SharedMailboxMember.ps1 -Action Remove -Mailbox shared@cooperservices.com -User jdoe -Permission FullAccess
#   .\Set-SharedMailboxMember.ps1 -Action Remove -Mailbox shared@cooperservices.com -User jdoe -WhatIf

<#
EXAMPLE OUTPUT

PS> .\Set-SharedMailboxMember.ps1 -Action Remove -Mailbox support@altronic-llc.com -User jason.lamb@cooperservices.com
=== Set-SharedMailboxMember started 10/12/2026 15:41:02 ===
Connected as: admin.jason.lamb@CooperServices.com
Shared mailbox: support@altronic-llc.com
User: Jason Lamb (Jason.Lamb@cooperservices.com)

About to REMOVE FullAccess + SendAs for Jason.Lamb@cooperservices.com on support@altronic-llc.com
Proceed? (Y/N): y
  • FullAccess : Remove succeeded
  • SendAs : Remove succeeded

Log file: $psexports[folder]\SetSharedMailboxMember_date_time.log
=== Script completed ===

#>