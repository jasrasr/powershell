# Filename: Get-DynamicDistributionListMembers.ps1
# Revision : 1.4.0
# Description : Get the members of a dynamic distribution list; prompts for the group if -GroupIdentity is not provided
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-08
# Modified Date : 2026-10-16
# Changelog :
# 1.0.0 initial release
# 1.1.0 switch to interactive browser sign-in (no device code / appverify page); add -OutputType (Email or Full, prompts if omitted); return member count
# 1.2.0 add -CompareDomain: report domain user mailboxes missing from the list, and list members outside the domain; prompts if omitted (press Enter to skip)
# 1.3.0 verify the signed-in account can run the required cmdlets (admin permission check); offer to re-authenticate if not
# 1.4.0 remove -CompareDomain (the script only lists members); show members first, then any errors; warn and show the filter when the list has 0 members

[CmdletBinding()]
param(
    # Name, alias, or email address of the dynamic distribution list. Prompts if omitted.
    [string]$GroupIdentity,

    # What to return: Email (primary SMTP addresses only) or Full (name, email, type, department, title). Prompts if omitted.
    [ValidateSet('Email', 'Full')]
    [string]$OutputType
)

$ErrorActionPreference = 'Stop'

# Prompt if no group was provided
while ([string]::IsNullOrWhiteSpace($GroupIdentity)) {
    $GroupIdentity = (Read-Host "Enter the dynamic distribution list name or email address").Trim()
}

# Prompt for output type if not provided
if (-not $OutputType) {
    do {
        $choice = (Read-Host "Return [E]mail addresses only or [F]ull details? (E/F)").Trim().ToUpper()
    } while ($choice -notin @('E', 'F'))
    $OutputType = if ($choice -eq 'E') { 'Email' } else { 'Full' }
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
    Connect-ExchangeOnline -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Host "ERROR: Failed to connect. Ensure you authenticated with an Exchange Online admin account." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
}

# Exchange Online only exposes the cmdlets a signed-in account's admin roles allow, so a missing cmdlet means
# the account lacks permissions (or is not an admin account at all)
$requiredCmdlets = @('Get-DynamicDistributionGroup', 'Get-Recipient')
$missingCmdlets = @($requiredCmdlets | Where-Object { -not (Get-Command $_ -ErrorAction SilentlyContinue) })

if ($missingCmdlets.Count -gt 0) {
    Write-Host "ERROR: $($exoConnection.UserPrincipalName) does not have permission to run: $($missingCmdlets -join ', ')" -ForegroundColor Red
    Write-Host "This usually means you signed in with a non-admin account. Required role: Exchange Administrator, Global Reader, or an RBAC role such as View-Only Recipients." -ForegroundColor Yellow

    $retry = (Read-Host "Sign out and re-authenticate with your admin account? (Y/N)").Trim().ToUpper()
    if ($retry -ne 'Y') { exit 1 }

    Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
    Connect-ExchangeOnline -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    $missingCmdlets = @($requiredCmdlets | Where-Object { -not (Get-Command $_ -ErrorAction SilentlyContinue) })

    if (-not $exoConnection -or $missingCmdlets.Count -gt 0) {
        $who = if ($exoConnection) { $exoConnection.UserPrincipalName } else { 'the signed-in account' }
        Write-Host "ERROR: $who still lacks permission to run: $($missingCmdlets -join ', '). Ask IT to assign an Exchange admin role." -ForegroundColor Red
        exit 1
    }
}

# Find the dynamic group
try {
    $group = Get-DynamicDistributionGroup -Identity $GroupIdentity
} catch {
    Write-Host "ERROR: Could not find a dynamic distribution list matching '$GroupIdentity'. $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Expand members from the group's recipient filter; hold any error until the members are shown
$recipients = @()
$expandError = $null
try {
    $recipients = @(Get-Recipient -RecipientPreviewFilter $group.RecipientFilter -OrganizationalUnit $group.RecipientContainer -ResultSize Unlimited |
        Sort-Object DisplayName)
} catch {
    $expandError = $_.Exception.Message
}
$count = $recipients.Count

# Return objects to the pipeline; they display at the console and can be piped (e.g. | Export-Csv)
if ($OutputType -eq 'Email') {
    $recipients | ForEach-Object { [string]$_.PrimarySmtpAddress }
} else {
    $recipients | Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails, Department, Title
}

Write-Host "`n$($group.DisplayName) <$($group.PrimarySmtpAddress)> has $count member(s)" -ForegroundColor Green

# Errors and warnings come last
if ($expandError) {
    Write-Host "ERROR: Could not expand the members of '$GroupIdentity'. $expandError" -ForegroundColor Red
} elseif ($count -eq 0) {
    Write-Host "WARNING: The list's recipient filter matched no recipients. The list may be empty by design, or its filter may be outdated." -ForegroundColor Yellow
    Write-Host "RecipientFilter   : $($group.RecipientFilter)" -ForegroundColor Yellow
    Write-Host "RecipientContainer: $($group.RecipientContainer)" -ForegroundColor Yellow
}

# Example Usage:
#   .\Get-DynamicDistributionListMembers.ps1
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com" -OutputType Email
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com" -OutputType Full | Export-Csv members.csv -NoTypeInformation
