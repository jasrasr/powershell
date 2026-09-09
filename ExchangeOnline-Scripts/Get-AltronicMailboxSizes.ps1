<#
Filename:    Get-MailboxSizes.ps1
Revision:    1.1.0
Description: Reports primary mailbox size/quota, online archive status, and
             archive size for every mailbox with an @domain.com proxy
             address. Exports to CSV in $PSExports.
Author:      Jason Lamb with help from Claude Code
Created:     2026-09-09
Modified:    2026-09-09
Changelog:
  1.0.0 - Initial version
  1.1.0 - Auto install/import ExchangeOnlineManagement and connect if needed
          (does not disconnect on completion)
#>

[CmdletBinding()]
param(
    [string]$DomainFilter = "domain.com"
)

$exportPath = Join-Path $PSExports "$DomainFilterMailboxSizes_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

# Module check and import
foreach ($module in @("ExchangeOnlineManagement")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Host "Importing $module..." -ForegroundColor Cyan
        Import-Module $module
    }
}

# Connect to Exchange Online only if not already connected
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Write-Host "NOTE: Authenticate with your Exchange Online admin account." -ForegroundColor Yellow
    Connect-ExchangeOnline -Device -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Host "ERROR: Failed to connect to Exchange Online." -ForegroundColor Red
        return
    }
}
Write-Host "Connected as: $($exoConnection.UserPrincipalName)" -ForegroundColor Green

Write-Host "Pulling mailboxes for *@$DomainFilter ..."

$mailboxes = Get-Mailbox -ResultSize Unlimited -Filter "EmailAddresses -like '*@$DomainFilter'" |
    Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }

if (-not $mailboxes) {
    Write-Host "No mailboxes found matching @$DomainFilter."
    return
}

Write-Host "Found $($mailboxes.Count) mailbox(es). Gathering size and archive stats..."

$results = foreach ($mbx in $mailboxes) {
    $upn = $mbx.PrimarySmtpAddress
    Write-Host "  Processing ${upn}..."

    $stats = Get-MailboxStatistics -Identity $mbx.Identity -ErrorAction SilentlyContinue

    $primarySizeGB = if ($stats) {
        [math]::Round(($stats.TotalItemSize.Value.ToBytes() / 1GB), 2)
    } else { $null }

    $primaryItemCount = if ($stats) { $stats.ItemCount } else { $null }

    $archiveEnabled  = $mbx.ArchiveStatus -ne "None"
    $archiveSizeGB   = $null
    $archiveItemCount = $null
    $autoExpanding   = $mbx.AutoExpandingArchiveEnabled

    if ($archiveEnabled) {
        $archiveStats = Get-MailboxStatistics -Identity $mbx.Identity -Archive -ErrorAction SilentlyContinue
        if ($archiveStats) {
            $archiveSizeGB    = [math]::Round(($archiveStats.TotalItemSize.Value.ToBytes() / 1GB), 2)
            $archiveItemCount = $archiveStats.ItemCount
        }
    }

    [PSCustomObject]@{
        DisplayName          = $mbx.DisplayName
        PrimarySmtpAddress   = $upn
        PrimarySizeGB        = $primarySizeGB
        PrimaryItemCount     = $primaryItemCount
        ProhibitSendQuotaGB  = [math]::Round((($mbx.ProhibitSendQuota -replace '[^\d.]', '') -as [double]) / 1024, 2) -as [string]
        ArchiveEnabled       = $archiveEnabled
        ArchiveStatus        = $mbx.ArchiveStatus
        AutoExpandingArchive = $autoExpanding
        ArchiveSizeGB        = $archiveSizeGB
        ArchiveItemCount     = $archiveItemCount
    }
}

$results | Sort-Object PrimarySizeGB -Descending | Format-Table -AutoSize

$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "`nExported to $exportPath"

<#
Example usage:

  # Default: all @domain.com mailboxes
  .\Get-MailboxSizes.ps1

  # Different domain
  .\Get-MailboxSizes.ps1 -DomainFilter domain.com
#>
