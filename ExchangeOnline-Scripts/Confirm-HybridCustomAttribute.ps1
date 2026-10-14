# Filename: Confirm-HybridCustomAttribute.ps1
# Revision : 1.0.0
# Description : Compare an on-prem AD extensionAttributeN with the Exchange Online CustomAttributeN for one or more users, and optionally check both against an expected value. Useful for confirming a synced attribute (e.g. one used by a dynamic distribution list filter) has landed.
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-13
# Modified Date : 2026-10-13
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param(
    # Email addresses (or UPNs) of the users to check. Prompts if omitted.
    [string[]]$Users,

    # Attribute number to compare: AD extensionAttributeN vs Exchange Online CustomAttributeN.
    [ValidateRange(1, 15)]
    [int]$AttributeNumber = 3,

    # Optional value both sides should equal. Leave blank to only compare AD against Exchange Online.
    [string]$ExpectedValue,

    # Optional domain controller. If omitted, uses the AD cmdlet session defaults (e.g. Connect-AltronicAD) or the default DC.
    [string]$Server,

    # Optional credential for AD. If omitted, uses the AD cmdlet session defaults or the current identity.
    [System.Management.Automation.PSCredential]$Credential
)

$ErrorActionPreference = 'Stop'

# Logging
$logDir = if ($env:psexports) { $env:psexports } else { 'c:\temp\psexports' }
if (-not (Test-Path -LiteralPath $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
$logPath = Join-Path $logDir ("Confirm-HybridCustomAttribute_{0}.log" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
Start-Transcript -Path $logPath | Out-Null

try {
    # Prompt if no users were provided
    while (-not $Users -or $Users.Count -eq 0) {
        $entered = Read-Host "Enter one or more email addresses (comma-separated)"
        $Users = @($entered -split '[,;\s]+' | Where-Object { $_ })
    }
    $Users = @($Users | ForEach-Object { $_.Trim() } | Where-Object { $_ })

    $adAttribute = "extensionAttribute$AttributeNumber"
    $exoAttribute = "CustomAttribute$AttributeNumber"

    # Module checks
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Write-Host "Installing ExchangeOnlineManagement..." -ForegroundColor Cyan
        Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name ExchangeOnlineManagement)) { Import-Module ExchangeOnlineManagement }

    $adAvailable = [bool](Get-Module -ListAvailable -Name ActiveDirectory)
    if ($adAvailable) {
        if (-not (Get-Module -Name ActiveDirectory)) { Import-Module ActiveDirectory -WarningAction SilentlyContinue }
    } else {
        Write-Host "WARNING: ActiveDirectory module not found (install RSAT). Only Exchange Online values will be checked." -ForegroundColor Yellow
    }

    # Connect to Exchange Online only if not already connected
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Host "NOTE: Authenticate with your Exchange Online admin account." -ForegroundColor Yellow
        Connect-ExchangeOnline -ShowBanner:$false
        $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $exoConnection) {
            Write-Host "ERROR: Failed to connect to Exchange Online." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
    }

    # Optional AD parameters (explicit values override session defaults)
    $adParams = @{}
    if ($Server) { $adParams['Server'] = $Server }
    if ($Credential) { $adParams['Credential'] = $Credential }

    $results = foreach ($user in $Users) {
        $exoValue = $null; $adValue = $null
        $isDirSynced = $null; $type = $null
        $notes = @()

        # Exchange Online
        try {
            $mbx = Get-Mailbox -Identity $user
            $exoValue = [string]$mbx.$exoAttribute
            $isDirSynced = $mbx.IsDirSynced
            $type = $mbx.RecipientTypeDetails
        } catch {
            $notes += "EXO: $($_.Exception.Message)"
        }

        # On-prem AD
        if ($adAvailable) {
            try {
                $safe = $user.Replace("'", "''")
                $adUser = Get-ADUser -Filter "mail -eq '$safe' -or userPrincipalName -eq '$safe'" -Properties $adAttribute @adParams
                if ($adUser) {
                    $adValue = [string]$adUser.$adAttribute
                } else {
                    $notes += "AD: user not found"
                }
            } catch {
                $notes += "AD: $($_.Exception.Message)"
            }
        }

        # Status
        $status = if ($notes.Count -gt 0 -and $null -eq $exoValue -and $null -eq $adValue) {
            'Error'
        } elseif ($adAvailable -and $null -ne $adValue -and $null -ne $exoValue -and $adValue -ne $exoValue) {
            'Mismatch (AD vs EXO)'
        } elseif ($ExpectedValue -and (($null -ne $exoValue -and $exoValue -ne $ExpectedValue) -or ($null -ne $adValue -and $adValue -ne $ExpectedValue))) {
            'Not expected value'
        } elseif ($null -eq $adValue -or $null -eq $exoValue) {
            'Incomplete'
        } else {
            'OK'
        }

        [pscustomobject][ordered]@{
            User          = $user
            Type          = $type
            IsDirSynced   = $isDirSynced
            "AD_$adAttribute" = $adValue
            "EXO_$exoAttribute" = $exoValue
            Status        = $status
            Notes         = ($notes -join '; ')
        }
    }

    $results | Format-Table -AutoSize | Out-Host

    $ok = @($results | Where-Object Status -eq 'OK').Count
    Write-Host "$ok of $($results.Count) user(s) OK" -ForegroundColor $(if ($ok -eq $results.Count) { 'Green' } else { 'Yellow' })
    Write-Host "Log: $logPath" -ForegroundColor Cyan

    $results
} finally {
    Stop-Transcript | Out-Null
}

# Example Usage:
#   .\Confirm-HybridCustomAttribute.ps1
#   .\Confirm-HybridCustomAttribute.ps1 -Users "first.last@contoso.com","other.user@contoso.com" -AttributeNumber 3 -ExpectedValue "Value"
#   .\Confirm-HybridCustomAttribute.ps1 -Users "first.last@contoso.com" -Server dc01 -Credential (Get-Credential)
#   .\Confirm-HybridCustomAttribute.ps1 -Users "first.last@contoso.com" | Export-Csv check.csv -NoTypeInformation
