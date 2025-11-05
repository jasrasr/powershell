# Revision : 2.0
# Description : Merge all TXT files in a folder into one CSV by appending lines vertically (one after another). Rev 2.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string] $SourceFolder,
    [Parameter(Mandatory = $true)]
    [string] $OutputCsv
)

# Get all TXT files in the folder
$txtFiles = Get-ChildItem -Path $SourceFolder -Filter *.txt -File

if (-not $txtFiles) {
    Write-Host "No TXT files found in $SourceFolder" -ForegroundColor Yellow
    exit
}

Write-Host "Merging $($txtFiles.Count) TXT files from $SourceFolder ..." -ForegroundColor Cyan

# Collect all lines
$allLines = @()
foreach ($file in $txtFiles) {
    Write-Host "Reading : $($file.Name)"
    $content = Get-Content $file.FullName | Where-Object { $_.Trim() -ne "" }   # Skip blank lines
    $allLines += $content
}

# Convert each line to an object for CSV export
$csvData = $allLines | ForEach-Object { [PSCustomObject]@{ Line = $_ } }

# Export to CSV (no quotes, just raw data)
"Line" | Out-File -FilePath $OutputCsv -Encoding UTF8
$csvData | ForEach-Object { $_.Line } | Out-File -Append -FilePath $OutputCsv -Encoding UTF8

Write-Host "Merged all TXT files into $OutputCsv successfully." -ForegroundColor Green

# Example Usage
# .\Merge-AllTxt-To-Csv.ps1 -SourceFolder "C:\temp\egnyte-110425\depth3" -OutputCsv "C:\temp\egnyte-110425\merged.csv"
