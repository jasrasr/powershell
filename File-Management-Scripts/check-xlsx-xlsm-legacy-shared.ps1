# ------------------------------------------------------------
# Script: check-xlsx-xlsm-legacy-shared.ps1
# Revision: 1.8
# Purpose: Scan current folder & subfolders for .xlsx & .xlsm,
#          check legacy “Shared Workbook” mode,
#          and write each result to a live CSV log file
#          as the scan runs — so partial progress is preserved.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2026-01-20
# ------------------------------------------------------------

[CmdletBinding()]
param (
    [switch]$VerboseScan
)

# --- 1. Setup ---
$RootFolder = Get-Location
Write-Host "Starting scan in folder : $RootFolder" -ForegroundColor Cyan

# Log file (timestamped to avoid overwrite)
$logPath = Join-Path -Path "C:\temp\powershell-exports" -ChildPath "ExcelLegacyShareStatus_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Write-Host "Logging results to: $logPath" -ForegroundColor Cyan

# Create log header
"FilePath,SharedStatus,Error" | Out-File -FilePath $logPath -Encoding UTF8

# Create Excel COM (headless)
Write-Host "Initializing Excel COM object…" -ForegroundColor Cyan
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

# --- 2. Collect Files ---
Write-Host "Searching for .xlsx & .xlsm files (recursive)..." -ForegroundColor Cyan
$files = Get-ChildItem -Path $RootFolder -Include *.xlsx,*.xlsm -Recurse -File
$total = $files.Count
Write-Host "Found $total file(s) to check." -ForegroundColor Cyan

if ($total -eq 0) {
    Write-Host "No .xlsx or .xlsm to process. Exiting." -ForegroundColor Yellow
    $excel.Quit()
    return
}

$counter = 0
# --- 3. Process Files ---
foreach ($file in $files) {
    $counter++
    Write-Host "Processing file $counter of $total : $($file.FullName)" -ForegroundColor Gray

    try {
        # Open read-only to avoid any change
        $wb = $excel.Workbooks.Open($file.FullName,
                                    [Type]::Missing,
                                    $true,         # ReadOnly
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    $true)         # IgnoreReadOnlyRecommended

        $isShared = $wb.MultiUserEditing
        $wb.Close($false) # Close no save

        # Log to disk
        $line = '"' + $file.FullName + '",' + $isShared + ',""'
        Add-Content -Path $logPath -Value $line

        if ($VerboseScan) {
            Write-Host "    Shared Workbook mode = $isShared" -ForegroundColor Green
        }
    }
    catch {
        $errMsg = $_.Exception.Message -replace '"','""'
        # Log error
        $line = '"' + $file.FullName + '",ERROR,"' + $errMsg + '"'
        Add-Content -Path $logPath -Value $line

        if ($VerboseScan) {
            Write-Host "    ERROR : $errMsg" -ForegroundColor Red
        }
    }
}

# --- 4. Cleanup Excel COM ---
Write-Host "Cleaning up Excel COM object…" -ForegroundColor Cyan
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

# --- 5. Summary (console only) ---
Write-Host "`n***************************************" -ForegroundColor Cyan
Write-Host "Scan complete. Summary saved to:" -ForegroundColor Cyan
Write-Host "    $logPath" -ForegroundColor Cyan
Write-Host "***************************************" -ForegroundColor Cyan

Write-Host "Partial or full results are safely logged above." -ForegroundColor Cyan
