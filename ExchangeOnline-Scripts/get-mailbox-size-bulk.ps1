# Filename: get-mailbox-size-bulk.ps1
# Revision : 1.0.1
# Description : Get primary and archive mailbox sizes for a list of users from a CSV
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-04
# Modified Date : 2026-05-07
# Changelog :
# 1.0.0 initial release
# 1.0.1 open exported CSV in Notepad when complete

param(
    [string]$CsvPath,
    [string]$ExportPath,
    [string]$EmailColumn = 'EmailAddress'
)

$dateStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$defaultExport = "C:\temp\mailbox-report-$dateStamp.csv"

if (-not $CsvPath) {
    $inputCsvPath = Read-Host "Source CSV path (press Enter for C:\temp\user-emails.csv)"
    $CsvPath = if ($inputCsvPath.Trim()) { $inputCsvPath.Trim() } else { 'C:\temp\user-emails.csv' }
}

if (-not $ExportPath) {
    $inputExportPath = Read-Host "Export path (press Enter for $defaultExport)"
    $ExportPath = if ($inputExportPath.Trim()) { $inputExportPath.Trim() } else { $defaultExport }
}

function Convert-ToBytes {
    param([Parameter(Mandatory)][object]$BQSize)
    try {
        if ($BQSize.Value -and ($BQSize.Value | Get-Member -Name ToBytes -MemberType Method)) {
            return [int64]$BQSize.Value.ToBytes()
        }
    } catch { }

    $txt = $BQSize.ToString()
    $m = [regex]::Match($txt, '\((?<bytes>[0-9,]+)\s+bytes\)')
    if ($m.Success) { return [int64]($m.Groups['bytes'].Value -replace ',','') }

    $mu = [regex]::Match($txt, '^(?<val>\d+(\.\d+)?)\s*(?<unit>KB|MB|GB|TB)', 'IgnoreCase')
    if (-not $mu.Success) { throw "Unable to parse size from '$txt'" }
    $val = [double]$mu.Groups['val'].Value
    switch ($mu.Groups['unit'].Value.ToUpperInvariant()) {
        'KB' { return [int64]($val * 1KB) }
        'MB' { return [int64]($val * 1MB) }
        'GB' { return [int64]($val * 1GB) }
        'TB' { return [int64]($val * 1TB) }
    }
}

# Check EXO connection
$exoConnection = Get-ConnectionInformation -ErrorAction SilentlyContinue
if (-not $exoConnection) {
    Connect-ExchangeOnline -Device -ShowBanner:$false
} else {
    Write-Host "Already connected to Exchange Online as $($exoConnection.UserPrincipalName)" -ForegroundColor Green
}

# Load CSV
if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV file not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv -Path $CsvPath

if (-not ($users | Get-Member -Name $EmailColumn -MemberType NoteProperty -ErrorAction SilentlyContinue)) {
    Write-Host "Column '$EmailColumn' not found in CSV. Available columns: $(($users[0].PSObject.Properties.Name) -join ', ')" -ForegroundColor Red
    exit 1
}

$results = @()

foreach ($user in $users) {
    $email = $user.$EmailColumn.Trim()
    Write-Host "`nProcessing: $email" -ForegroundColor Cyan

    $row = [PSCustomObject]@{
        EmailAddress     = $email
        PrimarySize_MB   = $null
        PrimarySize_GB   = $null
        PrimaryItems     = $null
        PrimaryDeleted_MB = $null
        ArchiveSize_MB   = $null
        ArchiveSize_GB   = $null
        ArchiveItems     = $null
        ArchiveDeleted_MB = $null
        Error            = $null
    }

    try {
        $primary = Get-MailboxStatistics -Identity $email -ErrorAction Stop

        if ($primary.TotalItemSize) {
            $bytes = Convert-ToBytes $primary.TotalItemSize
            $row.PrimarySize_MB = [math]::Round($bytes / 1MB, 2)
            $row.PrimarySize_GB = [math]::Round($bytes / 1GB, 2)
            $row.PrimaryItems   = $primary.ItemCount
            Write-Host "  Primary : $($row.PrimarySize_GB) GB ($($row.PrimaryItems) items)" -ForegroundColor Yellow
        }

        if ($primary.TotalDeletedItemSize) {
            $delBytes = Convert-ToBytes $primary.TotalDeletedItemSize
            $row.PrimaryDeleted_MB = [math]::Round($delBytes / 1MB, 2)
            Write-Host "  Primary Deleted Items : $($row.PrimaryDeleted_MB) MB" -ForegroundColor Gray
        }
    } catch {
        $row.Error = "Primary: $_"
        Write-Host "  Primary error: $_" -ForegroundColor Red
    }

    try {
        $archive = Get-MailboxStatistics -Identity $email -Archive -ErrorAction Stop

        if ($archive.TotalItemSize) {
            $bytes = Convert-ToBytes $archive.TotalItemSize
            $row.ArchiveSize_MB = [math]::Round($bytes / 1MB, 2)
            $row.ArchiveSize_GB = [math]::Round($bytes / 1GB, 2)
            $row.ArchiveItems   = $archive.ItemCount
            Write-Host "  Archive : $($row.ArchiveSize_GB) GB ($($row.ArchiveItems) items)" -ForegroundColor Yellow
        }

        if ($archive.TotalDeletedItemSize) {
            $delBytes = Convert-ToBytes $archive.TotalDeletedItemSize
            $row.ArchiveDeleted_MB = [math]::Round($delBytes / 1MB, 2)
            Write-Host "  Archive Deleted Items : $($row.ArchiveDeleted_MB) MB" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  Archive : not found or not enabled" -ForegroundColor DarkGray
    }

    $results += $row
}

Write-Host "`n--- Summary ---" -ForegroundColor Cyan
$results | Format-Table -AutoSize

if ($ExportPath) {
    $exportDir = Split-Path $ExportPath -Parent
    if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }
    $results | Export-Csv -Path $ExportPath -NoTypeInformation
    Write-Host "Exported to: $ExportPath" -ForegroundColor Green
    Start-Process notepad.exe $ExportPath
}

# Example Usage:
#   .\get-mailbox-size-bulk.ps1
#   .\get-mailbox-size-bulk.ps1 -CsvPath "C:\temp\users.csv"
#   .\get-mailbox-size-bulk.ps1 -CsvPath "C:\temp\users.csv" -ExportPath "C:\temp\mailbox-report.csv"
#   .\get-mailbox-size-bulk.ps1 -CsvPath "C:\temp\users.csv" -ExportPath "C:\temp\mailbox-report.csv" -EmailColumn "Email"
