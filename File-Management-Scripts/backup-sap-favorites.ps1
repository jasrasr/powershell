# Filename: backup-sap-favorites.ps1
# Revision : 1.0.0
# Description : Backup SAP NWBC favorites folder from %APPDATA% to OneDrive with timestamp
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-07-27
# Modified Date : 2026-07-27
# Changelog :
# 1.0.0 initial release

[CmdletBinding()]
param()

# Get OneDrive path
$oneDrivePath = $env:OneDriveCommercial
if (-not $oneDrivePath) {
    # Fallback to standard OneDrive path
    $oneDrivePath = Join-Path $env:USERPROFILE "OneDrive - Cooper Machinery Services"
}

# Define source and destination
$sourceFolder = Join-Path $env:APPDATA "SAP\NWBC"
$destBaseFolder = Join-Path $oneDrivePath "Documents\! SAP Export"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Files to backup
$filesToBackup = @("NwbcFavorites.xml", "NWBC.fav")
$filesFound = @()

# Validate source folder exists
if (-not (Test-Path $sourceFolder)) {
    Write-Host "ERROR: Source folder not found: $sourceFolder" -ForegroundColor Red
    Write-Host "Expected path: %APPDATA%\SAP\NWBC" -ForegroundColor Yellow
    exit 1
}

# Check which files exist
foreach ($file in $filesToBackup) {
    $filePath = Join-Path $sourceFolder $file
    if (Test-Path $filePath) {
        $filesFound += $file
    }
}

# Validate at least one file was found
if ($filesFound.Count -eq 0) {
    Write-Host "ERROR: Required backup files not found in $sourceFolder" -ForegroundColor Red
    Write-Host "Looking for: $($filesToBackup -join ', ')" -ForegroundColor Yellow
    exit 1
}

# Create destination base folder if it doesn't exist
if (-not (Test-Path $destBaseFolder)) {
    Write-Host "Creating destination folder: $destBaseFolder" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $destBaseFolder -Force | Out-Null
}

# Create timestamped backup folder
$destFolder = Join-Path $destBaseFolder "NWBC_$timestamp"
New-Item -ItemType Directory -Path $destFolder -Force | Out-Null

# Copy files
Write-Host "Backing up SAP NWBC favorites to: $destFolder" -ForegroundColor Cyan
foreach ($file in $filesFound) {
    $sourceFile = Join-Path $sourceFolder $file
    Copy-Item -Path $sourceFile -Destination $destFolder -Force
    Write-Host "  ✓ Copied $file" -ForegroundColor Green
}

Write-Host "Backup completed successfully!" -ForegroundColor Green
Write-Host "Location: $destFolder" -ForegroundColor Green

# Example Usage:
#   .\backup-sap-favorites.ps1
