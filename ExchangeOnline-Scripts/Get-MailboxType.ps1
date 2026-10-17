# Filename: Get-MailboxType.ps1
# Revision : 1.2.0
# Description : Get the recipient type (UserMailbox, SharedMailbox, RoomMailbox, MailUniversalDistributionGroup, DynamicDistributionGroup, etc.) for one or more email addresses or names; prompts if -Identity is not provided
# Author : Jason Lamb (with help from Claude Sonnet 5.5)
# Created Date : 2026-10-17
# Modified Date : 2026-10-17
# Changelog :
# 1.0.0 initial release
# 1.1.0 use Get-Recipient instead of Get-Mailbox so distribution lists, groups, contacts and mail users are identified too
# 1.2.0 when a lookup fails, check whether the address domain belongs to a different tenant and say so

[CmdletBinding()]
param(
    # One or more mailbox names, aliases, or email addresses. Prompts if omitted (comma-separate to enter several).
    [string[]]$Identity
)

$ErrorActionPreference = 'Stop'

# Prompt if no mailbox was provided
while (-not $Identity -or -not ($Identity | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
    $Identity = (Read-Host "Enter the email address or name (comma-separate for several)") -split ','
}
$Identity = @($Identity | ForEach-Object { $_.Trim() } | Where-Object { $_ })

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

if (-not (Get-Command Get-Recipient -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: $($exoConnection.UserPrincipalName) does not have permission to run Get-Recipient. Sign in with an Exchange admin account." -ForegroundColor Red
    exit 1
}

# Look up the tenant ID that owns a domain (public Microsoft endpoint, no sign-in); returns $null if unregistered
function Get-DomainTenantId {
    param([string]$Domain)
    try {
        $config = Invoke-RestMethod "https://login.microsoftonline.com/$Domain/.well-known/openid-configuration" -ErrorAction Stop
        if ($config.issuer -match '([0-9a-f]{8}-[0-9a-f-]{27})') { return $Matches[1] }
    } catch { }
    return $null
}

$myTenantId = [string](Get-OrganizationConfig).Guid

$results = foreach ($id in $Identity) {
    try {
        $rcpt = Get-Recipient -Identity $id -ErrorAction Stop
        [PSCustomObject]@{
            Input              = $id
            DisplayName        = $rcpt.DisplayName
            PrimarySmtpAddress = $rcpt.PrimarySmtpAddress
            RecipientType      = $rcpt.RecipientTypeDetails
        }
    } catch {
        $message = "Not found / error: $($_.Exception.Message)"
        if ($id -match '@(.+)$') {
            $domain = $Matches[1]
            $domainTenantId = Get-DomainTenantId -Domain $domain
            if ($domainTenantId -and $domainTenantId -ne $myTenantId) {
                $message = "Not found - domain $domain belongs to a different tenant ($domainTenantId)"
            } elseif ($domainTenantId) {
                $message = "Not found in this tenant (domain is in this tenant, check the address): $($_.Exception.Message)"
            }
        }
        [PSCustomObject]@{
            Input              = $id
            DisplayName        = $null
            PrimarySmtpAddress = $null
            RecipientType      = $message
        }
    }
}

$results | Format-Table -AutoSize
