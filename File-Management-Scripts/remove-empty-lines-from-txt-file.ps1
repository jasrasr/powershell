# Revision : 1.1
# Description : Remove empty lines from a specified text file and overwrite the original file. Added parameter input. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-06
# Modified Date : 2025-10-06

param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath
)

if (-not (Test-Path -Path $FilePath)) {
    Write-Host "File not found : $FilePath" -ForegroundColor Red
    exit
}

Write-Host "Processing file : $FilePath" -ForegroundColor Yellow

# Read, filter out empty or whitespace-only lines, and overwrite the file
(Get-Content -Path $FilePath) | Where-Object { $_.Trim() -ne '' } | Set-Content -Path $FilePath -Encoding UTF8

Write-Host "Empty lines removed successfully from $FilePath" -ForegroundColor Green

# .\Remove-EmptyLines.ps1 -FilePath '\\server\folder\file.txt'
