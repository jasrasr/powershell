# Filename: Compare-DynamicDistributionListToDomain.ps1
# Revision : 1.0.0
# Description : Compare a dynamic distribution list to an email domain: report domain recipients missing from the list, with options to exclude inactive accounts, shared mailboxes, and groups/distribution lists
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-16
# Modified Date : 2026-10-16
# Changelog :
# 1.0.0 initial release (split out of Get-DynamicDistributionListMembers.ps1, which now only lists members)

[CmdletBinding()]
param(
    # Name, alias, or email address of the dynamic distribution list. Prompts if omitted.
    [string]$GroupIdentity,

    # Email domain to compare against the list (e.g. contoso.com). Prompts if omitted.
    [string]$Domain,

    # Skip accounts that are disabled (sign-in blocked). Prompts if omitted.
    [switch]$ExcludeInactive,

    # Skip shared, room, and equipment mailboxes. Prompts if omitted.
    [switch]$ExcludeShared,

    # Skip mail-enabled groups, distribution lists, and dynamic distribution lists in the domain. Prompts if omitted.
    [switch]$ExcludeGroups
)

$ErrorActionPreference = 'Stop'

function Read-YesNo([string]$Question) {
    do { $answer = (Read-Host "$Question (Y/N)").Trim().ToUpper() } while ($answer -notin @('Y', 'N'))
    return ($answer -eq 'Y')
}

while ([string]::IsNullOrWhiteSpace($GroupIdentity)) {
    $GroupIdentity = (Read-Host "Enter the dynamic distribution list name or email address").Trim()
}
while ([string]::IsNullOrWhiteSpace($Domain)) {
    $Domain = (Read-Host "Enter the email domain to compare against (e.g. contoso.com)").Trim()
}
$Domain = $Domain.TrimStart('@')

if (-not $PSBoundParameters.ContainsKey('ExcludeInactive')) { $ExcludeInactive = Read-YesNo "Exclude inactive (disabled) accounts?" }
if (-not $PSBoundParameters.ContainsKey('ExcludeShared'))   { $ExcludeShared   = Read-YesNo "Exclude shared mailboxes?" }
if (-not $PSBoundParameters.ContainsKey('ExcludeGroups'))   { $ExcludeGroups   = Read-YesNo "Exclude groups and distribution lists?" }

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

# A missing cmdlet means the signed-in account lacks the admin role for it
$requiredCmdlets = @('Get-DynamicDistributionGroup', 'Get-Recipient')
if ($ExcludeInactive) { $requiredCmdlets += 'Get-User' }
$missingCmdlets = @($requiredCmdlets | Where-Object { -not (Get-Command $_ -ErrorAction SilentlyContinue) })

if ($missingCmdlets.Count -gt 0) {
    Write-Host "ERROR: $($exoConnection.UserPrincipalName) does not have permission to run: $($missingCmdlets -join ', ')" -ForegroundColor Red
    Write-Host "This usually means you signed in with a non-admin account. Required role: Exchange Administrator, Global Reader, or an RBAC role such as View-Only Recipients." -ForegroundColor Yellow

    if (-not (Read-YesNo "Sign out and re-authenticate with your admin account?")) { exit 1 }

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

# Expand members from the group's recipient filter
try {
    $members = @(Get-Recipient -RecipientPreviewFilter $group.RecipientFilter -OrganizationalUnit $group.RecipientContainer -ResultSize Unlimited)
} catch {
    Write-Host "ERROR: Could not expand the members of '$GroupIdentity'. $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
$memberEmails = @($members | ForEach-Object { ([string]$_.PrimarySmtpAddress).ToLower() })

# Build the set of domain recipients to check, based on the exclusion options
$types = @('UserMailbox', 'MailUser')
if (-not $ExcludeShared) { $types += @('SharedMailbox', 'RoomMailbox', 'EquipmentMailbox') }
if (-not $ExcludeGroups) { $types += @('MailUniversalDistributionGroup', 'MailUniversalSecurityGroup', 'MailNonUniversalGroup', 'DynamicDistributionGroup', 'GroupMailbox') }

Write-Host "Comparing '$($group.DisplayName)' against recipients with a primary address in @$Domain..." -ForegroundColor Cyan
# Match the domain client-side; server-side wildcard filtering on PrimarySmtpAddress is unreliable
$domainRecipients = @(Get-Recipient -RecipientTypeDetails $types -ResultSize Unlimited |
    Where-Object { ([string]$_.PrimarySmtpAddress) -like "*@$Domain" -and $_.Guid -ne $group.Guid })

$inactiveSkipped = 0
if ($ExcludeInactive) {
    $disabledIds = @{}
    foreach ($u in (Get-User -ResultSize Unlimited | Where-Object { $_.AccountDisabled })) { $disabledIds[[string]$u.Guid] = $true }
    $before = $domainRecipients.Count
    $domainRecipients = @($domainRecipients | Where-Object { -not $disabledIds.ContainsKey([string]$_.Guid) })
    $inactiveSkipped = $before - $domainRecipients.Count
}

if ($domainRecipients.Count -eq 0) {
    Write-Host "ERROR: No recipients found for @$Domain after exclusions. Check the domain spelling." -ForegroundColor Red
    exit 1
}

$missing = @($domainRecipients | Where-Object { ([string]$_.PrimarySmtpAddress).ToLower() -notin $memberEmails } | Sort-Object DisplayName)

# Return objects to the pipeline so they can be piped (e.g. | Export-Csv)
$missing | Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails

Write-Host "`n@$Domain recipients checked: $($domainRecipients.Count) | List members: $($members.Count) | Missing from list: $($missing.Count)" -ForegroundColor Green
$skipped = @()
if ($ExcludeInactive) { $skipped += "inactive accounts ($inactiveSkipped skipped)" }
if ($ExcludeShared)   { $skipped += 'shared/room/equipment mailboxes' }
if ($ExcludeGroups)   { $skipped += 'groups and distribution lists' }
if ($skipped) { Write-Host "Excluded: $($skipped -join ', ')" -ForegroundColor Green }

if ($members.Count -eq 0) {
    Write-Host "WARNING: The list has 0 members, so every domain recipient shows as missing. Check the list's filter first:" -ForegroundColor Yellow
    Write-Host "RecipientFilter   : $($group.RecipientFilter)" -ForegroundColor Yellow
    Write-Host "RecipientContainer: $($group.RecipientContainer)" -ForegroundColor Yellow
}

# Example Usage:
#   .\Compare-DynamicDistributionListToDomain.ps1
#   .\Compare-DynamicDistributionListToDomain.ps1 -GroupIdentity "all-staff@company.com" -Domain company.com -ExcludeInactive -ExcludeShared -ExcludeGroups
#   .\Compare-DynamicDistributionListToDomain.ps1 -GroupIdentity "all-staff@company.com" -Domain company.com -ExcludeInactive:$false -ExcludeShared:$false -ExcludeGroups:$false | Export-Csv missing.csv -NoTypeInformation
