<#
.SYNOPSIS
    Reports message/attachment size limits in Exchange Online: the org-wide
    default, the default mailbox plan, and the effective per-mailbox setting
    for every mailbox (flagging anyone who differs from the tenant default).

.NOTES
    Requires the ExchangeOnlineManagement module and a connection with at
    least Exchange View-Only Administrator / Global Reader rights.

    Attachment size vs. message size: Exchange enforces MaxSendSize /
    MaxReceiveSize on the whole MIME message, not the raw attachment bytes.
    Base64 encoding inflates an attachment by roughly 33%, so treat the
    limit as "message size" and expect real attachments to cap out at
    roughly limit / 1.33.
#>

[CmdletBinding()]
param(
    [string]$CsvPath = ".\EXO-MailboxSizeLimits-$(Get-Date -Format yyyyMMdd-HHmm).csv"
)

# --- Connect if needed -------------------------------------------------
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "ExchangeOnlineManagement module not found. Installing for current user..." -ForegroundColor Yellow
    Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
}

if (-not (Get-ConnectionInformation | Where-Object { $_.State -eq 'Connected' })) {
    Connect-ExchangeOnline -ShowBanner:$false
}

# --- 1. Org-wide (tenant) default via Get-TransportConfig ---------------
# In Exchange Online this is normally "Unlimited" — EXO does not enforce a
# real cap here the way on-prem Exchange does. The actual ceiling users hit
# comes from the mailbox plan / per-mailbox settings below, and Outlook/OWA
# client-side caps (150 MB Outlook, 112 MB OWA as of Microsoft's published
# service description).
Write-Host "`n=== Org-wide transport config (Get-TransportConfig) ===" -ForegroundColor Cyan
Get-TransportConfig | Format-List MaxReceiveSize, MaxSendSize, MaxRecipientEnvelopeLimit

# --- 2. Default mailbox plan (applies to newly created mailboxes) -------
Write-Host "`n=== Mailbox plans (defaults for new mailboxes) ===" -ForegroundColor Cyan
Get-MailboxPlan | Format-Table Name, MaxSendSize, MaxReceiveSize, IsDefault -AutoSize

# --- 3. Per-user effective limits ---------------------------------------
Write-Host "`n=== Per-mailbox limits (this is what actually applies to each user) ===" -ForegroundColor Cyan

$mailboxes = Get-EXOMailbox -ResultSize Unlimited -Properties MaxSendSize, MaxReceiveSize

$report = foreach ($mbx in $mailboxes) {
    [PSCustomObject]@{
        DisplayName    = $mbx.DisplayName
        PrimarySmtp    = $mbx.PrimarySmtpAddress
        MaxSendSize    = $mbx.MaxSendSize
        MaxReceiveSize = $mbx.MaxReceiveSize
        # "Unlimited" here means the mailbox inherits the org/plan default
        # rather than having an explicit per-user override.
        IsCustomized   = -not (
            $mbx.MaxSendSize.ToString() -eq 'Unlimited' -and
            $mbx.MaxReceiveSize.ToString() -eq 'Unlimited'
        )
    }
}

$report | Sort-Object IsCustomized -Descending | Format-Table -AutoSize

$report | Export-Csv -Path $CsvPath -NoTypeInformation
Write-Host "`nFull per-mailbox report exported to: $CsvPath" -ForegroundColor Green

# --- 4. Quick lookup for a single user -----------------------------------
# Get-Mailbox -Identity jason.lamb@cooperservices.com | Format-List MaxSendSize, MaxReceiveSize

# --- 5. To raise a limit ---------------------------------------------------
# Single user:
# Set-Mailbox -Identity someone@cooperservices.com -MaxSendSize 100MB -MaxReceiveSize 100MB
#
# Everyone (use cautiously — this is a tenant-wide change):
# Get-Mailbox -ResultSize Unlimited | Set-Mailbox -MaxSendSize 100MB -MaxReceiveSize 100MB
#
# Default plan for mailboxes created going forward:
# Set-MailboxPlan "<PlanName>" -MaxSendSize 100MB -MaxReceiveSize 100MB