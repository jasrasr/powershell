# Filename: Invoke-Robocopy.ps1
# Revision : 1.0.0
# Description : Prompts for source and destination, then runs robocopy with standard flags and logging. Runs in list-only (/l) mode for testing.
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-09
# Modified Date : 2026-04-09
# Changelog :
# 1.0.0 initial release

$source      = Read-Host "Enter source path"
$destination = Read-Host "Enter destination path"
$datetime    = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logDir      = "C:\temp\powershell-robocopy-logs"
$logFile     = "$logDir\robocopy-$datetime.log"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

robocopy $source $destination /E /MT:32 /W:1 /R:1 /J /TEE /LOG+:$logFile /L
