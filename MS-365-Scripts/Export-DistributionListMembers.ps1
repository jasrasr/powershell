# ============================================================
# Filename : Export-DistributionListMembers.ps1
# Revision : 1.0
# Description : Exports members from one or more distribution
#               lists to a CSV file in $psexports.
# Author : Jason Lamb (with help from AI)
# Created Date : 2026-03-25
# Modified Date : 2026-03-25
# Changelog :
# 1.0 Initial release
# ============================================================

<#
.SYNOPSIS
    Exports members of specified distribution lists to a CSV.
.EXAMPLE
    & ".\Export-DistributionListMembers.ps1"
.NOTES
    Update $DistributionLists with your distribution list email addresses.
    Requires Exchange Admin or Recipient Management role.
    Results are exported to $psexports and opened on completion.
#>

# ------------------------------------------------------------
# Distribution lists to export
# ------------------------------------------------------------
$DistributionLists = @(
    "dl-groupa@yourdomain.com"
    "dl-groupb@yourdomain.com"
    "dl-groupc@yourdomain.com"
    "dl-groupd@yourdomain.com"
)

# ------------------------------------------------------------
# Ensure ExchangeOnlineManagement module is available
# ------------------------------------------------------------
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Installing ExchangeOnlineManagement module..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

Import-Module ExchangeOnlineManagement

# ------------------------------------------------------------
# Connect to Exchange Online (skip if already connected)
# ------------------------------------------------------------
if (-not (Get-ConnectionInformation -ErrorAction SilentlyContinue)) {
    Connect-ExchangeOnline
} else {
    Write-Host "Already connected to Exchange Online - skipping login" -ForegroundColor Gray
}

# ------------------------------------------------------------
# Export members from each DL
# ------------------------------------------------------------
$results = [System.Collections.Generic.List[PSCustomObject]]::new()
$total   = $DistributionLists.Count
$index   = 0

foreach ($dl in $DistributionLists) {
    $index++
    $remaining = $total - $index
    Write-Host "`n[$index of $total | $remaining remaining] Exporting members of '$dl'" -ForegroundColor White

    try {
        $dlInfo  = Get-DistributionGroup -Identity $dl -ErrorAction Stop
        $members = Get-DistributionGroupMember -Identity $dl -ResultSize Unlimited -ErrorAction Stop

        foreach ($member in $members) {
            $results.Add([PSCustomObject]@{
                DistributionList      = $dlInfo.DisplayName
                DistributionListEmail = $dl
                DisplayName           = $member.DisplayName
                Email                 = $member.PrimarySmtpAddress
                RecipientType         = $member.RecipientType
            })
            Write-Host "  $($member.DisplayName) ($($member.PrimarySmtpAddress))" -ForegroundColor Cyan
        }

        Write-Host "  Total members: $($members.Count)" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to get members for '$dl': $_"
    }
}

# ------------------------------------------------------------
# Export to $psexports
# ------------------------------------------------------------
$timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$exportPath = Join-Path $psexports "DLMembersExport_$timestamp.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "`nDone. Total members exported: $($results.Count)" -ForegroundColor White
Write-Host "Report exported to: $exportPath" -ForegroundColor White

Invoke-Item $exportPath
