# Revision : 1.0
# Description : Check for missing sequential PDF files (sn-###-notes.pdf) in a folder. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,
    [int]$StartNumber = 595,
    [int]$EndNumber   = 1050
)

if (-not (Test-Path $FolderPath)) {
    Write-Host "Folder not found : $FolderPath" -ForegroundColor Red
    exit
}

Write-Host "Checking folder : $FolderPath" -ForegroundColor Cyan
Write-Host "Expected range : sn-$StartNumber-notes.pdf through sn-$EndNumber-notes.pdf" -ForegroundColor Yellow
Write-Host ""

$expectedFiles = @()
for ($i = $StartNumber; $i -le $EndNumber; $i++) {
    $expectedFiles += "sn-$i-notes.pdf"
}

$actualFiles = Get-ChildItem -Path $FolderPath -Filter "sn-*-notes.pdf" -File | Select-Object -ExpandProperty Name

$missingFiles = $expectedFiles | Where-Object { $_ -notin $actualFiles }

if ($missingFiles.Count -eq 0) {
    Write-Host "✅ No gaps detected. All files from sn-$StartNumber to sn-$EndNumber are present." -ForegroundColor Green
} else {
    Write-Host "⚠ Missing files detected :" -ForegroundColor Red
    $missingFiles | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }

    $logPath = "C:\temp\powershell-exports\missing-files-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    if (-not (Test-Path 'C:\temp\powershell-exports')) {
        New-Item -ItemType Directory -Path 'C:\temp\powershell-exports' | Out-Null
    }
    $missingFiles | Out-File -FilePath $logPath -Encoding utf8
    Write-Host "Log saved to : $logPath" -ForegroundColor Cyan
}
