
# Script: check-xlsx-xlsm-legacy-shared.ps1
# Revision         : 1.8
# Description      : Scan current folder & subfolders for .xlsx & .xlsm,
#                    check legacy “Shared Workbook” mode, log results live,
#                    and support resuming on restart.
# Author           : Jason Lamb (with help from ChatGPT)
# Created Date     : 2025-11-04
# Modified Date    : 2026-01-20
# Changelog 1.0.0  - Initial version with live logging & resume support


[CmdletBinding()]
param (
    [switch]$VerboseScan
)

# --- 1. Setup Paths ---
$RootFolder = Get-Location
Write-Host "Starting scan in folder : $RootFolder" -ForegroundColor Cyan

$baseLogFolder = "C:\temp\powershell-exports"
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'

$liveCsvLog      = Join-Path $baseLogFolder "ExcelLegacyShareStatus_$timestamp.csv"
$allFilesList    = Join-Path $baseLogFolder "AllFilesToProcess_$timestamp.txt"
$doneFilesList   = Join-Path $baseLogFolder "ProcessedFiles_$timestamp.txt"

Write-Host "Live CSV log       : $liveCsvLog" -ForegroundColor Cyan
Write-Host "Master file list   : $allFilesList" -ForegroundColor Cyan
Write-Host "Processed file list: $doneFilesList" -ForegroundColor Cyan

# Create CSV header
"FilePath,SharedStatus,Error" | Out-File -FilePath $liveCsvLog -Encoding UTF8

# Ensure processed list exists
if (!(Test-Path $doneFilesList)) { New-Item -Path $doneFilesList -ItemType File | Out-Null }

# --- 2. Gather Files to Process ---
Write-Host "Collecting list of .xlsx & .xlsm files…" -ForegroundColor Cyan
$allFiles = Get-ChildItem -Path $RootFolder -Include *.xlsx,*.xlsm -Recurse -File | Select-Object -ExpandProperty FullName

# Save master list (so you don’t have to regen this next time)
$allFiles | Out-File -FilePath $allFilesList -Encoding UTF8

# Load processed file list
$processed = @()
if (Test-Path $doneFilesList) {
    $processed = Get-Content -Path $doneFilesList
}

# Filter out files that are already done
$toProcess = $allFiles | Where-Object { $_ -notin $processed }

$total = $toProcess.Count
Write-Host "Total files to process (remaining): $total" -ForegroundColor Cyan

if ($total -eq 0) {
    Write-Host "No new files found to process." -ForegroundColor Yellow
    return
}

# --- 3. Excel COM Setup ---
Write-Host "Initializing Excel COM object…" -ForegroundColor Cyan
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

$counter = 0
# --- 4. Process Loop with Resume Support ---
foreach ($file in $toProcess) {
    $counter++
    Write-Host "[$counter/$total] Processing file : $file" -ForegroundColor Gray

    try {
        $wb = $excel.Workbooks.Open($file,
                                    [Type]::Missing,
                                    $true,
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    $true)

        $isShared = $wb.MultiUserEditing
        $wb.Close($false)

        # Log to CSV
        $csvLine = '"' + $file + '",' + $isShared + ',""'
        Add-Content -Path $liveCsvLog -Value $csvLine

        if ($VerboseScan) {
            Write-Host "    Shared Workbook mode = $isShared" -ForegroundColor Green
        }

        # Mark file as processed
        Add-Content -Path $doneFilesList -Value $file
    }
    catch {
        $errMsg = $_.Exception.Message -replace '"','""'

        # Log error to CSV
        $csvLine = '"' + $file + '",ERROR,"' + $errMsg + '"'
        Add-Content -Path $liveCsvLog -Value $csvLine

        if ($VerboseScan) {
            Write-Host "    ERROR : $errMsg" -ForegroundColor Red
        }

        # Still mark as processed to skip on retry
        Add-Content -Path $doneFilesList -Value $file
    }
}

# --- 5. Cleanup ---
Write-Host "Cleaning up Excel COM object…" -ForegroundColor Cyan
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

Write-Host "`nScan complete." -ForegroundColor Cyan
Write-Host "CSV log   : $liveCsvLog" -ForegroundColor Cyan
Write-Host "Processed : $doneFilesList" -ForegroundColor Cyan
