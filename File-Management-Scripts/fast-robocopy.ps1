<#
    Script Name : Copy-OneFile.ps1
    Revision    : 1.1
    Author      : Jason Lamb (with help from ChatGPT)
    Created     : 2025-12-05
    Modified    : 2025-12-05

    Description :
        Copies a single file using Robocopy. 
        - Supports parameters or interactive prompts if missing.
        - Logs output to C:\temp\powershell-exports with timestamped filename.
        - Uses /V for verbose per-file output.
        - Uses /TEE so output shows on screen AND in the log file.
        - Safe for PowerShell 5 and PowerShell 7.

    Parameters :
        -source       : Folder path where the file currently exists.
        -destination  : Folder path where the file will be copied.
        -file         : File name only (example: report.pdf).

    Notes :
        - This script copies ONE file only.
        - Robocopy requires the filename to be passed separately from the source directory.
        - Log files automatically append a timestamp to avoid overwrites.

    Example Usage :

        # Run with prompts
        .\Copy-OneFile.ps1

        # Run with parameters
        .\Copy-OneFile.ps1 -source "C:\SourceFolder" -destination "C:\DestFolder" -file "example.txt"

        # Dot-source then call manually
        . .\Copy-OneFile.ps1
        Copy-OneFile.ps1 -source "C:\src" -destination "D:\dst" -file "data.csv"
#>

param(
    [string]$source,
    [string]$destination,
    [string]$file
)

# Ask for missing input interactively
if (-not $source) {
    $source = Read-Host "Enter source folder path"
}

if (-not $destination) {
    $destination = Read-Host "Enter destination folder path"
}

if (-not $file) {
    $file = Read-Host "Enter file name (example: file.txt)"
}

# Timestamped log file
$datetime = Get-Date -Format 'yyyyMMdd-HHmmss'
$logfolder = 'C:\temp\powershell-exports'
$logfile = Join-Path $logfolder "robocopy-$datetime.log"

# Create log folder if missing
if (-not (Test-Path $logfolder)) {
    New-Item -ItemType Directory -Path $logfolder | Out-Null
}

Write-Host ""
Write-Host "Starting Robocopy single-file transfer..." -ForegroundColor Cyan
Write-Host "Source      : $source"
Write-Host "Destination : $destination"
Write-Host "File        : $file"
Write-Host "Log File    : $logfile"
Write-Host ""

# Run Robocopy (single file)
robocopy $source $destination $file /MT:64 /W:1 /R:1 /J /V /TEE /LOG+:"$logfile"

Write-Host ""
Write-Host "Robocopy complete." -ForegroundColor Green
Write-Host "Log saved to: $logfile"
