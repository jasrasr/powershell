# Filename: Get-DynamicDistributionListMembers.ps1
# Revision : 1.2.0
# Description : Get the members of a dynamic distribution list; prompts for the group if -GroupIdentity is not provided
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-08
# Modified Date : 2026-10-13
# Changelog :
# 1.0.0 initial release
# 1.2.0 add -CompareDomain: report domain user mailboxes missing from the list, and list members outside the domain; prompts if omitted (press Enter to skip)
# 1.1.0 switch to interactive browser sign-in (no device code / appverify page); add -OutputType (Email or Full, prompts if omitted); return member count

[CmdletBinding()]
param(
    # Name, alias, or email address of the dynamic distribution list. Prompts if omitted.
    [string]$GroupIdentity,

    # What to return: Email (primary SMTP addresses only) or Full (name, email, type, department, title). Prompts if omitted.
    [ValidateSet('Email', 'Full')]
    [string]$OutputType,

    # Email domain to compare against the list (e.g. contoso.com). Reports mailbox users in that domain who are NOT in the list. Prompts if omitted; Enter skips.
    [string]$CompareDomain
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

# Prompt for a domain to compare against (optional)
if (-not $PSBoundParameters.ContainsKey('CompareDomain')) {
    $CompareDomain = (Read-Host "Email domain to compare against the list (e.g. contoso.com), or press Enter to skip").Trim()
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

# Find the dynamic group
try {
    $group = Get-DynamicDistributionGroup -Identity $GroupIdentity
} catch {
    Write-Host "ERROR: Could not find a dynamic distribution list matching '$GroupIdentity'. $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Expand members from the group's recipient filter
$recipients = @(Get-Recipient -RecipientPreviewFilter $group.RecipientFilter -OrganizationalUnit $group.RecipientContainer -ResultSize Unlimited |
    Sort-Object DisplayName)
$count = $recipients.Count

# Return objects to the pipeline; they display at the console and can be piped (e.g. | Export-Csv)
if ($OutputType -eq 'Email') {
    $recipients | ForEach-Object { [string]$_.PrimarySmtpAddress }
} else {
    $recipients | Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails, Department, Title
}

Write-Host "`n$($group.DisplayName) <$($group.PrimarySmtpAddress)> has $count member(s)" -ForegroundColor Green

# Compare against all users in the domain (console only; does not affect pipeline output)
if (-not [string]::IsNullOrWhiteSpace($CompareDomain)) {
    $CompareDomain = $CompareDomain.TrimStart('@')
    Write-Host "Comparing against user mailboxes with a primary address in @$CompareDomain..." -ForegroundColor Cyan
    # Match the domain client-side; server-side wildcard filtering on PrimarySmtpAddress is unreliable
    $domainUsers = @(Get-Recipient -RecipientTypeDetails UserMailbox, MailUser -ResultSize Unlimited |
        Where-Object { ([string]$_.PrimarySmtpAddress) -like "*@$CompareDomain" } |
        Sort-Object DisplayName)

    if ($domainUsers.Count -eq 0) {
        Write-Host "WARNING: No user mailboxes found for @$CompareDomain. Check the domain spelling; skipping comparison." -ForegroundColor Yellow
        return
    }

    $memberEmails = @($recipients | ForEach-Object { ([string]$_.PrimarySmtpAddress).ToLower() })
    $domainEmails = @($domainUsers | ForEach-Object { ([string]$_.PrimarySmtpAddress).ToLower() })

    $missing = @($domainUsers | Where-Object { ([string]$_.PrimarySmtpAddress).ToLower() -notin $memberEmails })
    # Shared mailboxes in the list are expected, so they are not reported as extras
    $extra = @($recipients | Where-Object {
        $_.RecipientTypeDetails -ne 'SharedMailbox' -and
        ([string]$_.PrimarySmtpAddress).ToLower() -notin $domainEmails
    })

    Write-Host "@$CompareDomain users: $($domainUsers.Count) | In list: $count | Missing from list: $($missing.Count) | In list but not in domain: $($extra.Count)" -ForegroundColor Green

    if ($missing.Count -gt 0) {
        Write-Host "`nUsers in @$CompareDomain NOT in the list:" -ForegroundColor Yellow
        $missing | Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails, Department, Title | Format-Table -AutoSize | Out-Host
    } else {
        Write-Host "No @$CompareDomain users are missing from the list." -ForegroundColor Green
    }
    if ($extra.Count -gt 0) {
        Write-Host "In the list but not an @$CompareDomain user mailbox:" -ForegroundColor Yellow
        $extra | Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails | Format-Table -AutoSize | Out-Host
    }
}

# Example Usage:
#   .\Get-DynamicDistributionListMembers.ps1
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com" -OutputType Email
#   .\Get-DynamicDistributionListMembers.ps1 -GroupIdentity "all-staff@company.com" -OutputType Full | Export-Csv members.csv -NoTypeInformation
