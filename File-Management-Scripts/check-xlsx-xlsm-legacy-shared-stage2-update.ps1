# Script: check-xlsx-xlsm-legacy-shared-stage2-update.ps1
# Revision         : 1.0.0
# Description      : Read a CSV log and remove legacy shared workbook mode
#                    from files flagged True, saving changes via Excel COM.
# Author           : Jason Lamb (with help from ChatGPT)
# Created Date     : 2026-01-XX
# Modified Date    : 2026-01-XX
# Changelog 1.0.0  - Initial version to unshare legacy shared workbooks

param (
    [Parameter(Mandatory=$true)]
    [string]$LogPath
)

# Check log file exists
if (-not (Test-Path $LogPath)) {
    Write-Host "Log file not found at $LogPath" -ForegroundColor Red
    return
}

Write-Host "Reading log from : $LogPath" -ForegroundColor Cyan

# Import the log CSV
$entries = Import-Csv -Path $LogPath

# Filter only rows where SharedStatus = True
$toFix = $entries | Where-Object { $_.SharedStatus -eq 'True' }

$count = $toFix.Count
Write-Host "Found $count file(s) flagged as legacy shared to fix." -ForegroundColor Cyan

if ($count -eq 0) {
    Write-Host "No files to process. Exiting." -ForegroundColor Yellow
    return
}

# Create Excel COM
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

$index = 0
foreach ($item in $toFix) {
    $index++
    $filePath = $item.FilePath

    Write-Host "[$index/$count] Processing : $filePath" -ForegroundColor Gray

    try {
        # Open workbook (not read-only)
        $wb = $excel.Workbooks.Open($filePath,
                                    [Type]::Missing,
                                    $false,
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    [Type]::Missing,
                                    $true)

        # Remove legacy shared mode
        if ($wb.MultiUserEditing) {
            Write-Host "    Unsharing workbook…" -ForegroundColor Yellow
            $wb.ExclusiveAccess()
            $wb.Save()
            Write-Host "    Saved (unshared)." -ForegroundColor Green
        }
        else {
            Write-Host "    Already not shared, skipping." -ForegroundColor Green
        }

        $wb.Close()
    }
    catch {
        Write-Host "    ERROR on $filePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Cleanup
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()

Write-Host "`nDone. Processed $count file(s)." -ForegroundColor Cyan
