# Filename: Add-SharedMailboxSendAs.ps1
# Revision : 1.0.0
# Description : Grants Send As permission on a shared mailbox to multiple users listed in a CSV
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-20
# Modified Date : 2026-05-20
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory)]
    [string]$SharedMailbox,

    [Parameter(Mandatory)]
    [string]$CsvPath
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

# Connect to Exchange Online only if not already connected
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Connect-ExchangeOnline -Device -ShowBanner:$false
} else {
    Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
}

# Validate shared mailbox exists and is type SharedMailbox
Write-Host "`nValidating shared mailbox: $SharedMailbox" -ForegroundColor Cyan
$mailbox = Get-Mailbox -Identity $SharedMailbox -ErrorAction SilentlyContinue
if (-not $mailbox) {
    Write-Host "ERROR: Mailbox '$SharedMailbox' not found." -ForegroundColor Red
    exit 1
}
if ($mailbox.RecipientTypeDetails -ne "SharedMailbox") {
    Write-Host "ERROR: '$SharedMailbox' is not a shared mailbox (type: $($mailbox.RecipientTypeDetails))." -ForegroundColor Red
    exit 1
}
Write-Host "Confirmed: '$SharedMailbox' is a shared mailbox." -ForegroundColor Green

# Validate CSV path and column
if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: CSV file not found at '$CsvPath'." -ForegroundColor Red
    exit 1
}

$users = Import-Csv -Path $CsvPath
if ($users.Count -eq 0 -or -not $users[0].PSObject.Properties['EmailAddress']) {
    Write-Host "ERROR: CSV must have an 'EmailAddress' column and at least one row." -ForegroundColor Red
    exit 1
}

# Track results
$success = 0
$skipped = 0
$failed  = 0
$results = @()

Write-Host "`nProcessing $($users.Count) user(s)..." -ForegroundColor Cyan

foreach ($user in $users) {
    $email = $user.EmailAddress.Trim()

    if ([string]::IsNullOrWhiteSpace($email)) {
        Write-Host "  SKIP  : (empty row)" -ForegroundColor Yellow
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = "(empty)"; Status = "Skipped"; Reason = "Empty row" }
        continue
    }

    # Verify recipient exists in Exchange
    $recipient = Get-Recipient -Identity $email -ErrorAction SilentlyContinue
    if (-not $recipient) {
        Write-Host "  SKIP  : $email — recipient not found" -ForegroundColor Yellow
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Skipped"; Reason = "Recipient not found" }
        continue
    }

    # Check if Send As is already granted
    $existing = Get-RecipientPermission -Identity $SharedMailbox -Trustee $email -ErrorAction SilentlyContinue |
        Where-Object { $_.AccessRights -contains "SendAs" }
    if ($existing) {
        Write-Host "  SKIP  : $email — already has Send As" -ForegroundColor DarkGray
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Skipped"; Reason = "Already has Send As" }
        continue
    }

    # Grant Send As
    try {
        Add-RecipientPermission -Identity $SharedMailbox -Trustee $email -AccessRights SendAs -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "  GRANTED: $email" -ForegroundColor Green
        $success++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Granted"; Reason = "" }
    } catch {
        Write-Host "  FAILED : $email — $($_.Exception.Message)" -ForegroundColor Red
        $failed++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Failed"; Reason = $_.Exception.Message }
    }
}

# Summary
Write-Host "`n--- Summary ---" -ForegroundColor Cyan
Write-Host "  Granted : $success" -ForegroundColor Green
Write-Host "  Skipped : $skipped" -ForegroundColor Yellow
Write-Host "  Failed  : $failed" -ForegroundColor Red

# Export results CSV
$timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$exportPath = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\SharedMailboxSendAs_$timestamp.csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "`nResults exported to: $exportPath" -ForegroundColor Cyan

# Example Usage:
#   .\Add-SharedMailboxSendAs.ps1 -SharedMailbox "shared@company.com" -CsvPath "C:\path\to\users.csv"
