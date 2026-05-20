# Filename: zip-extract.ps1
# Revision : 1.0.0
# Description : Extract a ZIP file to a destination folder
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-20
# Modified Date : 2026-05-20
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory = $true)]
    [string]$ZipFile,

    [Parameter(Mandatory = $false)]
    [string]$Destination
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Test-Path $ZipFile)) {
    Write-Host "ZIP file not found: $ZipFile" -ForegroundColor Red
    exit 1
}

if (-not $Destination) {
    $Destination = [System.IO.Path]::Combine(
        [System.IO.Path]::GetDirectoryName($ZipFile),
        [System.IO.Path]::GetFileNameWithoutExtension($ZipFile)
    )
}

if (Test-Path $Destination) {
    Write-Host "Destination already exists: $Destination" -ForegroundColor Yellow
    $confirm = Read-Host "Overwrite contents? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Gray
        exit 0
    }
}

$zipSizeGB = [math]::Round((Get-Item $ZipFile).Length / 1GB, 2)

Write-Host ""
Write-Host "ZIP file    : $ZipFile ($zipSizeGB GB)" -ForegroundColor White
Write-Host "Destination : $Destination" -ForegroundColor White
Write-Host ""
Write-Host "Extracting..." -ForegroundColor Cyan

$startTime = Get-Date

try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFile, $Destination)
} catch {
    Write-Host "Extraction failed: $_" -ForegroundColor Red
    exit 1
}

$elapsed    = (Get-Date) - $startTime
$fileCount  = (Get-ChildItem $Destination -Recurse -File).Count
$outputSize = [math]::Round((Get-ChildItem $Destination -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 2)

Write-Host ""
Write-Host "Done. $fileCount files extracted ($outputSize GB)" -ForegroundColor Green
Write-Host "Elapsed     : $([math]::Round($elapsed.TotalMinutes, 1)) minutes" -ForegroundColor Gray
Write-Host ""

# Example Usage:
#   .\zip-extract.ps1 -ZipFile "C:\path\to\archive.zip"
#   .\zip-extract.ps1 -ZipFile "C:\path\to\archive.zip" -Destination "C:\output\folder"
