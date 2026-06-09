# Revision : 1.2
# Description : Remove duplicate lines (preserving first occurrence) from a specified text file and overwrite the original file atomically.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath
)

if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
    Write-Host "File not found or not a file: $FilePath" -ForegroundColor Red
    exit 1
}

Write-Host "Processing file : $FilePath" -ForegroundColor Yellow

try {
    # Read all lines first to avoid read/write collisions
    $lines = Get-Content -Path $FilePath -ErrorAction Stop

    # Keep first occurrence of each line (case-insensitive)
    $result = New-Object System.Collections.Generic.List[string]
    $seen = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($line in $lines) {
        # Add returns $true only when the item was not already present
        if ($seen.Add($line)) {
            [void]$result.Add($line)
        }
    }

    # Write to a temp file and replace the original to avoid truncation/read-write issues
    $tempFile = [System.IO.Path]::GetTempFileName()
    $result | Set-Content -Path $tempFile -Encoding UTF8

    Move-Item -Path $tempFile -Destination $FilePath -Force

    Write-Host "Duplicate lines removed successfully from $FilePath" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Example:
# .\Remove-Duplicates.ps1 -FilePath '\\server\folder\file.txt'
