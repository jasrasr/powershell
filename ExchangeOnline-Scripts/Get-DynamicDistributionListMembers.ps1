# Filename: Get-DynamicDistributionListMembers.ps1
# Revision : 1.0.0
# Description : Get the members of a dynamic distribution list; prompts for the group if -GroupIdentity is not provided
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-08
# Modified Date : 2026-10-08
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param(
    # Name, alias, or email address of the dynamic distribution list. Prompts if omitted.
    [string]$GroupIdentity
)

$ErrorActionPreference = 'Stop'

# Prompt if no group was provided
while ([string]::IsNullOrWhiteSpace($GroupIdentity)) {
    $GroupIdentity = (Read-Host "Enter the dynamic distribution list name or email address").Trim()
}

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
    Write-Host "NOTE: Authenticate with your Exchange Online admin account." -ForegroundColor Yellow
    Connect-ExchangeOnline -Device -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Host "ERROR: Failed to connect. Ensure you authenticated with an Exchange Online admin account." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
}

# Find the dynamic group
try {
    $group = Get-DynamicDistributionGroup -Identity $GroupIdentity
} catch {
    Write-Host "ERROR: Could not find a dynamic distribution list matching '$GroupIdentity'. $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Expand members from the group's recipient filter
$members = @(Get-Recipient -RecipientPreviewFilter $group.RecipientFilter -OrganizationalUnit $group.RecipientContainer -ResultSize Unlimited |
    Sort-Object DisplayName |
    Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails, Department, Title)

Write-Host "`n$($group.DisplayName) <$($group.PrimarySmtpAddress)> has $($members.Count) member(s)" -ForegroundColor Green

# Return objects to the pipeline; they display as a table at the console and can be piped (e.g. | Export-Csv)
$members

# Example Usage:
#   .\Get-DynamicDistributionListMembers.ps1
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com"
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com" | Export-Csv members.csv -NoTypeInformation
