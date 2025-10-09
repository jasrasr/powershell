# Revision : 1.1
# Description : Check for missing sequential TXT transcript files (sn-###.txt) in a folder. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

param(
    [string]$FolderPath = "$GitHubPath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\TXT-Transcriptions",
    [int]$StartNumber = 1,
    [int]$EndNumber   = 1050
)

if (-not (Test-Path $FolderPath)) {
    Write-Host "Folder not found : $FolderPath" -ForegroundColor Red
    exit
}

Write-Host "Checking folder : $FolderPath" -ForegroundColor Cyan
Write-Host "Expected range : sn-$('{0:D3}' -f $StartNumber).txt through sn-$('{0:D3}' -f $EndNumber).txt" -ForegroundColor Yellow
Write-Host ""

$expectedFiles = @()
for ($i = $StartNumber; $i -le $EndNumber; $i++) {
    $expectedFiles += "sn-$('{0:D3}' -f $i).txt"
}

$actualFiles = Get-ChildItem -Path $FolderPath -Filter "sn-*.txt" -File | Select-Object -ExpandProperty Name

$missingFiles = $expectedFiles | Where-Object { $_ -notin $actualFiles }

$totalExpected = $expectedFiles.Count
$totalFound = $actualFiles.Count
$totalMissing = $missingFiles.Count

if ($missingFiles.Count -eq 0) {
    Write-Host "✅ No gaps detected. All files from sn-$('{0:D3}' -f $StartNumber) to sn-$('{0:D3}' -f $EndNumber) are present." -ForegroundColor Green
} else {
    Write-Host "⚠ Missing files detected :" -ForegroundColor Red
    $missingFiles | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }

    $logFolder = "C:\temp\powershell-exports"
    if (-not (Test-Path $logFolder)) { New-Item -ItemType Directory -Path $logFolder | Out-Null }

    $logPath = Join-Path $logFolder ("missing-txt-files-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".txt")
    $missingFiles | Out-File -FilePath $logPath -Encoding utf8

    Write-Host ""
    Write-Host "Summary : $totalFound of $totalExpected files found ($totalMissing missing)" -ForegroundColor Cyan
    Write-Host "Log saved to : $logPath" -ForegroundColor Gray
    Invoke-Item $logPath
}
