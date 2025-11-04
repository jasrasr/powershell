# ------------------------------------------------------------
# Script: Check-ExcelLegacyShare_Console_AllMacroAndXlsx.ps1
# Revision: 1.6
# Description: Scan current folder & subfolders for .xlsx & .xlsm,
#              report whether legacy “Shared Workbook” mode is enabled.
#              DOES NOT make any changes. Shows status every step.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : [current date]
# Modified Date : [current date]
# ------------------------------------------------------------
[CmdletBinding()]
param (
    [switch]$VerboseScan
)

# 1. Determine current folder
$RootFolder = Get-Location
Write-Host "Starting scan in folder : $RootFolder" -ForegroundColor Cyan

# 2. Create Excel COM instance
Write-Host "Initializing Excel COM object…" -ForegroundColor Cyan
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

# 3. Find files
Write-Host "Searching for .xlsx & .xlsm files (recursive)…" -ForegroundColor Cyan
$files = Get-ChildItem -Path $RootFolder -Include *.xlsx,*.xlsm -Recurse -File
$filesCount = $files.Count
Write-Host "Found ${filesCount} file(s) to check." -ForegroundColor Cyan

if (${filesCount} -eq 0) {
    Write-Host "No .xlsx or .xlsm files found. Exiting." -ForegroundColor Yellow
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    return
}

# 4. Prepare results list
$results = @()
$counter = 0

# 5. Process each file
foreach ($file in $files) {
    $counter++
    Write-Host "Processing file ${counter} of ${filesCount} : $($file.FullName)" -ForegroundColor Gray
    try {
        $wb = $excel.Workbooks.Open($file.FullName,
                                     [Type]::Missing,
                                     $true,
                                     [Type]::Missing,
                                     [Type]::Missing,
                                     [Type]::Missing,
                                     $true)
        $isShared = $wb.MultiUserEditing
        if ($VerboseScan) {
            Write-Host "    Shared Workbook mode = $isShared" -ForegroundColor yellow
        }
        $results += [PSCustomObject]@{
            FilePath     = $file.FullName
            SharedStatus = $isShared
        }
        $wb.Close($false)
    }
    catch {
        if ($VerboseScan) {
            Write-Host "    ERROR checking file : $($_.Exception.Message)" -ForegroundColor Red
        }
        $results += [PSCustomObject]@{
            FilePath     = $file.FullName
            SharedStatus = "ERROR : $($_.Exception.Message)"
        }
    }
}

# 6. Clean up COM object
Write-Host "Cleaning up Excel COM object…" -ForegroundColor Cyan
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

# 7. Summary output with coloured statuses
Write-Host "`n***************************************" -ForegroundColor Cyan
Write-Host "Summary Report (File – SharedStatus)" -ForegroundColor Cyan
Write-Host "***************************************" -ForegroundColor Cyan

foreach ($r in $results) {
    if ($r.SharedStatus -eq $true) {
        Write-Host ("{0} - {1}" -f $r.FilePath, $r.SharedStatus) -ForegroundColor Red
    }
    elseif ($r.SharedStatus -eq $false) {
        Write-Host ("{0} - {1}" -f $r.FilePath, $r.SharedStatus) -ForegroundColor Green
    }
    else {
        Write-Host ("{0} - {1}" -f $r.FilePath, $r.SharedStatus) -ForegroundColor Yellow
    }
}

Write-Host "`nScan complete." -ForegroundColor Cyan
