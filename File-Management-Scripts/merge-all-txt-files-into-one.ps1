# Revision : 1.0
# Description : Combine all merged TXT files into a single file and report total line count
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-05
# Modified Date : 2025-11-05

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,

    [string]$FinalFileName = "all-merged.txt"
)

Write-Host "Combining all merged TXT files in $FolderPath ..." -ForegroundColor Cyan

# --- Gather merged text files only ---
$mergedFiles = Get-ChildItem -Path $FolderPath -Filter *-merged.txt -File | Sort-Object Name
$totalCount = $mergedFiles.Count
Write-Host "Found $totalCount merged files to combine" -ForegroundColor Yellow

if ($totalCount -eq 0) {
    Write-Host "No merged files found. Exiting." -ForegroundColor Red
    exit
}

# --- Create final output path ---
$finalFilePath = Join-Path $FolderPath $FinalFileName
if (Test-Path $finalFilePath) {
    Remove-Item $finalFilePath -Force
}

# --- Combine with progress ---
$totalLines = 0
$counter = 0

foreach ($file in $mergedFiles) {
    $counter++
    Write-Progress -Activity "Merging files..." -Status "$counter of $totalCount : $($file.Name)" -PercentComplete (($counter / $totalCount) * 100)

    $lines = Get-Content -Path $file.FullName -Encoding UTF8
    $lines | Add-Content -Path $finalFilePath -Encoding UTF8
    $totalLines += $lines.Count
}

Write-Progress -Activity "Merging files..." -Completed
Write-Host "✅ Merge complete!" -ForegroundColor Green
Write-Host "Final file : $finalFilePath" -ForegroundColor Cyan
Write-Host "Total lines written : $totalLines" -ForegroundColor Yellow

# --- Write summary CSV ---
$summaryCsv = Join-Path $FolderPath "all-merged-summary.csv"
[PSCustomObject]@{
    FinalFile     = $FinalFileName
    TotalFiles    = $totalCount
    TotalLines    = $totalLines
    CreatedDate   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} | Export-Csv -Path $summaryCsv -NoTypeInformation -Encoding UTF8

Write-Host "Summary CSV saved to $summaryCsv" -ForegroundColor Green

# example usage
# "$githubpath\PowerShell\File-Management-Scripts\merge-all-txt-files-into-one.ps1" -FolderPath "C:\Temp\folder" -FinalFileName "all-merged.txt"