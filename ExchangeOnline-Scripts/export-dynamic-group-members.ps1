# Filename: export-dynamic-group-members.ps1
# Revision : 1.0.1
# Description : Export all members of a dynamic distribution group to CSV (Name + Email), then open the file
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-04-06
# Modified Date : 2026-05-20
# Changelog :
# 1.0.0 initial release
# 1.0.1 verify EXO connection is live after Connect-ExchangeOnline; add -ResultSize Unlimited

param (
    [Parameter(Mandatory)]
    [string]$GroupIdentity,

    [string]$ExportPath = "$env:TEMP"
)

# Module check
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

# Connect only if not already connected
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Connect-ExchangeOnline -Device -ShowBanner:$false
    # Verify session was established — Device auth can return before cmdlets are ready
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Host "ERROR: Exchange Online connection could not be established." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
}

# Get dynamic group and expand members
$group = Get-DynamicDistributionGroup -Identity $GroupIdentity -ErrorAction Stop
$members = Get-Recipient -RecipientPreviewFilter $group.RecipientFilter -ResultSize Unlimited |
    Select-Object Name, PrimarySmtpAddress

$csvFile = Join-Path $ExportPath "$($group.Alias)_Members_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$members | Export-Csv -Path $csvFile -NoTypeInformation

Write-Host "Exported $($members.Count) members to: $csvFile" -ForegroundColor Green
Invoke-Item $csvFile

# Example Usage:
#   .\export-dynamic-group-members.ps1 -GroupIdentity "all-staff@company.com"
#   .\export-dynamic-group-members.ps1 -GroupIdentity "all-staff@company.com" -ExportPath "C:\exports"
