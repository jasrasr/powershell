# Filename: zip-folder.ps1
# Revision : 1.0.0
# Description : Compress a folder into a ZIP file using .NET ZipFile for memory-efficient handling
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-19
# Modified Date : 2026-05-19
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory = $true)]
    [string]$SourceFolder,

    [Parameter(Mandatory = $false)]
    [string]$OutputZip,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Optimal', 'Fastest', 'NoCompression')]
    [string]$CompressionLevel = 'Optimal'
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Test-Path $SourceFolder)) {
    Write-Host "Source folder not found: $SourceFolder" -ForegroundColor Red
    exit 1
}

if (-not $OutputZip) {
    $parent   = Split-Path $SourceFolder -Parent
    $leafName = Split-Path $SourceFolder -Leaf
    $OutputZip = Join-Path $parent "$leafName.zip"
}

if (Test-Path $OutputZip) {
    Write-Host "Output file already exists: $OutputZip" -ForegroundColor Yellow
    $confirm = Read-Host "Overwrite? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Gray
        exit 0
    }
    Remove-Item $OutputZip -Force
}

$fileCount  = (Get-ChildItem $SourceFolder -Recurse -File).Count
$folderSize = (Get-ChildItem $SourceFolder -Recurse -File | Measure-Object -Property Length -Sum).Sum
$folderSizeGB = [math]::Round($folderSize / 1GB, 2)

Write-Host ""
Write-Host "Source      : $SourceFolder" -ForegroundColor White
Write-Host "Files       : $fileCount" -ForegroundColor White
Write-Host "Size        : $folderSizeGB GB" -ForegroundColor White
Write-Host "Output      : $OutputZip" -ForegroundColor White
Write-Host "Compression : $CompressionLevel" -ForegroundColor White
Write-Host ""
Write-Host "Compressing..." -ForegroundColor Cyan

$startTime = Get-Date

try {
    [System.IO.Compression.ZipFile]::CreateFromDirectory(
        $SourceFolder,
        $OutputZip,
        [System.IO.Compression.CompressionLevel]::$CompressionLevel,
        $false
    )
} catch {
    Write-Host "Compression failed: $_" -ForegroundColor Red
    exit 1
}

$elapsed    = (Get-Date) - $startTime
$zipSize    = (Get-Item $OutputZip).Length
$zipSizeGB  = [math]::Round($zipSize / 1GB, 2)
$ratio      = if ($folderSize -gt 0) { [math]::Round((1 - $zipSize / $folderSize) * 100, 1) } else { 0 }

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "ZIP size    : $zipSizeGB GB (${ratio}% reduction)" -ForegroundColor Green
Write-Host "Elapsed     : $([math]::Round($elapsed.TotalMinutes, 1)) minutes" -ForegroundColor Gray
Write-Host ""

# Example Usage:
#   .\zip-folder.ps1 -SourceFolder "C:\path\to\folder"
#   .\zip-folder.ps1 -SourceFolder "C:\path\to\folder" -OutputZip "C:\output\archive.zip"
#   .\zip-folder.ps1 -SourceFolder "C:\path\to\folder" -OutputZip "C:\output\archive.zip" -CompressionLevel Fastest
#   .\zip-folder.ps1 -SourceFolder "C:\path\to\folder" -CompressionLevel NoCompression
