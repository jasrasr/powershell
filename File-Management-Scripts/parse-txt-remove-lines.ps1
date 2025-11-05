# Revision : 2.6
# Description : Cleans text files with a given prefix by removing standard subfolder patterns and child paths.
# Requires explicit -BatchFolder parameter (no default).
# Processes all *.txt files beginning with -BatchFilePrefix.
# Overwrites cleaned files but appends results and totals to egnyte-clean-summary.csv with date/time tracking.
# Loads exclusion patterns from external exclude-patterns.txt.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string]$BatchFolder,

    [Parameter(Mandatory = $true)]
    [string]$BatchFilePrefix
)

# --- VARIABLES ---
$RunDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$SummaryCsv  = Join-Path $BatchFolder "egnyte-clean-summary.csv"
$PatternFile = Join-Path $BatchFolder "exclude-patterns.txt"

# --- LOAD EXCLUSION PATTERNS ---
if (Test-Path $PatternFile) {
    $patterns = Get-Content $PatternFile | Where-Object { $_.Trim() -ne "" }
    Write-Host "Loaded $($patterns.Count) exclusion patterns from $PatternFile" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ Pattern file not found at $PatternFile — no exclusions loaded." -ForegroundColor Yellow
    $patterns = @()
}

# --- FIND MATCHING FILES ---
$BatchFiles = Get-ChildItem -Path $BatchFolder -Filter "$BatchFilePrefix*.txt" |
               Where-Object { $_.Name -notmatch '-cleaned' }

if (-not $BatchFiles) {
    Write-Host "No eligible batch files found with prefix '$BatchFilePrefix' in $BatchFolder." -ForegroundColor Red
    exit
}

$summary = @()

foreach ($file in $BatchFiles) {
    Write-Host "`nProcessing : $($file.Name)" -ForegroundColor Cyan

    $lines   = Get-Content $file.FullName
    $total   = $lines.Count

    $filtered = if ($patterns.Count -gt 0) {
        $lines | Where-Object {
            $line = $_
            -not ($patterns | Where-Object { $line -like "*$_*" })
        }
    } else {
        $lines
    }

    $kept     = $filtered.Count
    $removed  = $total - $kept
    $percent  = if ($total -gt 0) { [math]::Round(($kept / $total) * 100, 1) } else { 0 }

    # Always overwrite cleaned file
    $outFile  = [System.IO.Path]::Combine($BatchFolder, ($file.BaseName + "-cleaned" + $file.Extension))
    $filtered | Set-Content -Path $outFile -Encoding UTF8 -Force

    Write-Host "Original lines : $total" -ForegroundColor Yellow
    Write-Host "Removed lines  : $removed" -ForegroundColor Red
    Write-Host "Kept lines     : $kept ($percent`%)" -ForegroundColor Green
    Write-Host "Cleaned file saved : $outFile" -ForegroundColor White

    $summary += [PSCustomObject]@{
        RunDateTime   = $RunDateTime
        FileName      = $file.Name
        OriginalLines = $total
        RemovedLines  = $removed
        KeptLines     = $kept
        PercentKept   = "$percent`%"
    }
}

# --- SUMMARY OUTPUT ---
Write-Host "`n==================== CLEAN SUMMARY ====================" -ForegroundColor Yellow
$summary | Format-Table RunDateTime, FileName, OriginalLines, RemovedLines, KeptLines, PercentKept -AutoSize

$totalOriginal = ($summary.OriginalLines | Measure-Object -Sum).Sum
$totalRemoved  = ($summary.RemovedLines  | Measure-Object -Sum).Sum
$totalKept     = ($summary.KeptLines     | Measure-Object -Sum).Sum
$totalPercent  = if ($totalOriginal -gt 0) { [math]::Round(($totalKept / $totalOriginal) * 100, 1) } else { 0 }

Write-Host "`nTOTAL Original : $totalOriginal" -ForegroundColor Yellow
Write-Host "TOTAL Removed  : $totalRemoved"  -ForegroundColor Red
Write-Host "TOTAL Kept     : $totalKept ($totalPercent`%)" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Yellow

# --- APPEND SUMMARY TO CSV ---
if (Test-Path $SummaryCsv) {
    Add-Content -Path $SummaryCsv -Value "`n=== NEW RUN STARTED $RunDateTime ===`n"
} else {
    "=== NEW RUN STARTED $RunDateTime ===" | Out-File -FilePath $SummaryCsv -Encoding UTF8
}

$summary | Export-Csv -Path $SummaryCsv -NoTypeInformation -Encoding UTF8 -Append

# Append total line
$totalLine = "TOTAL,$totalOriginal,$totalRemoved,$totalKept,$totalPercent%"
Add-Content -Path $SummaryCsv -Value $totalLine
Add-Content -Path $SummaryCsv -Value "`n"

Write-Host "`nSummary appended with totals to : $SummaryCsv" -ForegroundColor Cyan
Write-Host "`nAll batch files processed and cleaned successfully at $RunDateTime." -ForegroundColor Yellow
