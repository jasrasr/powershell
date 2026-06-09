# Filename: Add-SharedMailboxReadManage.ps1
# Revision : 1.0.0
# Description : Grants read/manage permission on a shared mailbox to multiple users listed in a CSV
# Author : Jason Lamb (with help from Codex CLI)
# Created Date : 2026-05-28
# Modified Date : 2026-05-28
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory)]
    [string]$SharedMailbox,

    [Parameter(Mandatory)]
    [string]$CsvPath
)

# Set up export paths (CSV + log share the same timestamp base)
$timestamp   = Get-Date -Format "yyyyMMdd_HHmmss"
$exportBase  = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports\SharedMailboxReadManage_$timestamp"
$csvExport   = "$exportBase.csv"
$logExport   = "$exportBase.log"

function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $logExport -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
}

Write-Log "=== Add-SharedMailboxReadManage started $(Get-Date) ===" "Cyan"
Write-Log "Shared mailbox : $SharedMailbox" "Cyan"
Write-Log "CSV path       : $CsvPath" "Cyan"
Write-Log "Log file       : $logExport" "Cyan"

# Module check
foreach ($module in @("ExchangeOnlineManagement")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Log "Installing $module..." "Cyan"
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Log "Importing $module..." "Cyan"
        Import-Module $module
    }
}

# Connect to Exchange Online only if not already connected
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exoConnection) {
    Write-Log "NOTE: Authenticate with your Exchange Online admin account." "Yellow"
    Connect-ExchangeOnline -Device -ShowBanner:$false
    $exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exoConnection) {
        Write-Log "ERROR: Failed to connect. Ensure you authenticated with an Exchange Online admin account." "Red"
        exit 1
    }
}
Write-Log "Connected as: $($exoConnection.UserPrincipalName)" "Green"

# Validate shared mailbox exists and is type SharedMailbox
Write-Log "`nValidating shared mailbox: $SharedMailbox" "Cyan"
$mailbox = Get-Mailbox -Identity $SharedMailbox -ErrorAction SilentlyContinue
if (-not $mailbox) {
    Write-Log "ERROR: Mailbox '$SharedMailbox' not found." "Red"
    exit 1
}
if ($mailbox.RecipientTypeDetails -ne "SharedMailbox") {
    Write-Log "ERROR: '$SharedMailbox' is not a shared mailbox (type: $($mailbox.RecipientTypeDetails))." "Red"
    exit 1
}
Write-Log "Confirmed: '$SharedMailbox' is a shared mailbox." "Green"

# Validate CSV path and column
if (-not (Test-Path $CsvPath)) {
    Write-Log "ERROR: CSV file not found at '$CsvPath'." "Red"
    exit 1
}

$users = Import-Csv -Path $CsvPath
if ($users.Count -eq 0 -or -not $users[0].PSObject.Properties['EmailAddress']) {
    Write-Log "ERROR: CSV must have an 'EmailAddress' column and at least one row." "Red"
    exit 1
}

# Track results
$success = 0
$skipped = 0
$failed  = 0
$results = @()
$total   = $users.Count
$i       = 0

Write-Log "`nProcessing $total user(s)..." "Cyan"

foreach ($user in $users) {
    $i++
    $prefix = "[$i/$total]"
    $email  = $user.EmailAddress.Trim()

    if ([string]::IsNullOrWhiteSpace($email)) {
        Write-Log "  $prefix SKIP   : (empty row)" "Yellow"
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = "(empty)"; Status = "Skipped"; Reason = "Empty row" }
        continue
    }

    # Verify recipient exists in Exchange
    $recipient = Get-Recipient -Identity $email -ErrorAction SilentlyContinue
    if (-not $recipient) {
        Write-Log "  $prefix SKIP   : $email - recipient not found" "Yellow"
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Skipped"; Reason = "Recipient not found" }
        continue
    }

    # Check if FullAccess is already granted directly to this user
    $existing = Get-MailboxPermission -Identity $SharedMailbox -User $email -ErrorAction SilentlyContinue |
        Where-Object {
            $_.AccessRights -contains "FullAccess" -and
            -not $_.IsInherited -and
            $_.Deny -eq $false
        }
    if ($existing) {
        Write-Log "  $prefix SKIP   : $email - already has FullAccess" "DarkGray"
        $skipped++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Skipped"; Reason = "Already has FullAccess" }
        continue
    }

    # Grant read/manage (FullAccess) permission
    try {
        Add-MailboxPermission -Identity $SharedMailbox -User $email -AccessRights FullAccess -InheritanceType All -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Log "  $prefix GRANTED: $email" "Green"
        $success++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Granted"; Reason = "" }
    } catch {
        Write-Log "  $prefix FAILED : $email - $($_.Exception.Message)" "Red"
        $failed++
        $results += [PSCustomObject]@{ EmailAddress = $email; Status = "Failed"; Reason = $_.Exception.Message }
    }
}

# Summary
Write-Log "`n--- Summary ---" "Cyan"
Write-Log "  Granted : $success" "Green"
Write-Log "  Skipped : $skipped" "Yellow"
Write-Log "  Failed  : $failed" "Red"

# Export results CSV
$results | Export-Csv -Path $csvExport -NoTypeInformation
Write-Log "`nCSV  exported to: $csvExport" "Cyan"
Write-Log "Log  exported to: $logExport" "Cyan"
Write-Log "=== Completed $(Get-Date) ===" "Cyan"
Invoke-Item $logExport

# Example Usage:
#   .\Add-SharedMailboxReadManage.ps1 -SharedMailbox "shared@company.com" -CsvPath "C:\path\to\users.csv"
