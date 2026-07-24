# Filename: Find-DuplicateFiles.ps1
# Revision : 1.0.0
# Description : Identifies duplicate files by name within a folder tree
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-07-23
# Modified Date : 2026-07-23
# Changelog :
# 1.0.0 initial release

param(
    [Parameter(Mandatory = $false)]
    [string]$ParentFolder
)

# Prompt for folder if not provided
if (-not $ParentFolder) {
    $ParentFolder = Read-Host "Enter the parent folder path"
}

# Validate folder exists
if (-not (Test-Path -Path $ParentFolder -PathType Container)) {
    Write-Host "Error: Folder '$ParentFolder' does not exist." -ForegroundColor Red
    exit 1
}

Write-Host "Scanning '$ParentFolder' for duplicate files..." -ForegroundColor Cyan

# Get all files and group by name
$files = Get-ChildItem -Path $ParentFolder -File -Recurse
$duplicates = $files | Group-Object -Property Name | Where-Object { $_.Count -gt 1 }

if ($duplicates.Count -eq 0) {
    Write-Host "No duplicate files found." -ForegroundColor Green
    exit 0
}

Write-Host "`nFound $($duplicates.Count) duplicate file names:`n" -ForegroundColor Yellow

foreach ($group in $duplicates) {
    Write-Host "[$($group.Count)x] $($group.Name)" -ForegroundColor Red
    foreach ($file in $group.Group) {
        Write-Host "    - $($file.FullName) (Size: $('{0:N0}' -f $file.Length) bytes)" -ForegroundColor Gray
    }
    Write-Host ""
}

# Example Usage:
#   .\Find-DuplicateFiles.ps1
#   .\Find-DuplicateFiles.ps1 -ParentFolder "C:\MyFiles"
