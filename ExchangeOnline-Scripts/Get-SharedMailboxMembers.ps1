# Filename: Get-SharedMailboxMembers.ps1
# Revision : 1.5.0
# Description : Retrieves member lists and external sending status for specified shared mailboxes (or all shared mailboxes if none specified) from Exchange Online
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-08-03
# Modified Date : 2026-10-23
# Changelog :
# 1.5.0 removed hardcoded mailbox list; discovers all shared mailboxes when -Mailboxes is not supplied
# 1.4.0 added ExternalSendingEnabled reporting (RequireSenderAuthenticationEnabled), removed IsInherited
# 1.3.0 added -AdminUPN parameter to connect/reconnect as a specific admin account
# 1.2.0 auto-install ExchangeOnlineManagement if missing; fixed module-detection and connection bugs
# 1.1.0 updated authentication to avoid WAM issues, removed module auto-install
# 1.0.0 initial release

param(
    [string[]]$Mailboxes,
    [string]$AdminUPN
)

# Load ExchangeOnlineManagement, installing it first if needed
if (-not (Get-Module -Name "ExchangeOnlineManagement")) {
    if (-not (Get-Module -Name "ExchangeOnlineManagement" -ListAvailable)) {
        Write-Host "Installing ExchangeOnlineManagement..." -ForegroundColor Cyan
        Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -ErrorAction Stop
    }
    Write-Host "Loading ExchangeOnlineManagement..." -ForegroundColor Cyan
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
}

# Connect to Exchange Online if not already connected
try {
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue

    if ($exoConnection -and $AdminUPN -and $exoConnection.UserPrincipalName -ne $AdminUPN) {
        Write-Host "Connected as $($exoConnection.UserPrincipalName), disconnecting to reconnect as $AdminUPN..." -ForegroundColor Cyan
        Disconnect-ExchangeOnline -Confirm:$false
        $exoConnection = $null
    }

    if (-not $exoConnection) {
        Write-Host "Connecting to Exchange Online$(if ($AdminUPN) { " as $AdminUPN" })..." -ForegroundColor Cyan
        if ($AdminUPN) {
            Connect-ExchangeOnline -UserPrincipalName $AdminUPN -ShowBanner:$false -ErrorAction Stop
        } else {
            Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop
        }
    } else {
        Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
    }
} catch {
    Write-Host "Error connecting to Exchange Online: $_" -ForegroundColor Red
    exit 1
}

# If no mailboxes were specified, discover all shared mailboxes in the tenant
if (-not $Mailboxes) {
    Write-Host "No -Mailboxes specified, discovering all shared mailboxes..." -ForegroundColor Cyan
    try {
        $Mailboxes = Get-EXOMailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited -ErrorAction Stop |
            Select-Object -ExpandProperty PrimarySmtpAddress |
            Sort-Object
    } catch {
        Write-Host "Error discovering shared mailboxes: $_" -ForegroundColor Red
        exit 1
    }
    if (-not $Mailboxes) {
        Write-Host "No shared mailboxes found." -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Found $(@($Mailboxes).Count) shared mailboxes" -ForegroundColor Green
}

# Retrieve members for each shared mailbox
$results = @()

foreach ($mailbox in $Mailboxes) {
    Write-Host "Processing $mailbox..." -ForegroundColor Cyan

    try {
        # Get the mailbox, including the property that controls external sender delivery
        $mbx = Get-EXOMailbox -Identity $mailbox -Properties RequireSenderAuthenticationEnabled -ErrorAction Stop
        $externalSendingEnabled = -not $mbx.RequireSenderAuthenticationEnabled

        # Get full mailbox permissions
        $members = Get-EXOMailboxPermission -Identity $mailbox -ErrorAction Stop |
            Where-Object { $_.User -notlike "NT AUTHORITY*" -and $_.User -notlike "*@*EXCHANGELABS*" } |
            Select-Object User, AccessRights

        if ($members) {
            foreach ($member in $members) {
                $results += [PSCustomObject]@{
                    Mailbox = $mailbox
                    Member = $member.User
                    AccessRights = $member.AccessRights -join ", "
                    ExternalSendingEnabled = $externalSendingEnabled
                }
            }
        } else {
            $results += [PSCustomObject]@{
                Mailbox = $mailbox
                Member = "(No members found)"
                AccessRights = "-"
                ExternalSendingEnabled = $externalSendingEnabled
            }
        }
    } catch {
        Write-Host "Error retrieving members for $mailbox : $_" -ForegroundColor Red
        $results += [PSCustomObject]@{
            Mailbox = $mailbox
            Member = "(Error retrieving)"
            AccessRights = "-"
            ExternalSendingEnabled = "-"
        }
    }
}

# Display results
$results | Format-Table -AutoSize

# Export to CSV
$exportDir = Join-Path $env:USERPROFILE "OneDrive - Cooper Machinery Services\powershell-exports"
if (-not (Test-Path $exportDir)) {
    New-Item -Path $exportDir -ItemType Directory -Force | Out-Null
}
$exportPath = Join-Path $exportDir "SharedMailboxMembers_$(Get-Date -Format 'yyyy-MM-dd_HHmmss').csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Results exported to: $exportPath" -ForegroundColor Green

# Example Usage:
#   .\Get-SharedMailboxMembers.ps1                  (all shared mailboxes in the tenant)
#   .\Get-SharedMailboxMembers.ps1 -Mailboxes @("panelsales@altronic-llc.com", "exports@altronic-llc.com")
#   .\Get-SharedMailboxMembers.ps1 -AdminUPN admin@cooperservices.com
