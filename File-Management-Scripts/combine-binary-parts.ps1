# Filename: combine-binary-parts.ps1
# Revision : 1.0.0
# Description : Reassemble a large binary file from numbered .part files created by split-large-binary-file.ps1
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-20
# Modified Date : 2026-05-20
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory = $true)]
    [string]$PartsDirectory,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

$bufferSize = 4MB

if (-not (Test-Path $PartsDirectory)) {
    Write-Host "Parts directory not found: $PartsDirectory" -ForegroundColor Red
    exit 1
}

$parts = Get-ChildItem $PartsDirectory -Filter "*.part*" | Sort-Object Name

if ($parts.Count -eq 0) {
    Write-Host "No .part files found in: $PartsDirectory" -ForegroundColor Red
    exit 1
}

if (Test-Path $OutputFile) {
    Write-Host "Output file already exists: $OutputFile" -ForegroundColor Yellow
    $confirm = Read-Host "Overwrite? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Gray
        exit 0
    }
    Remove-Item $OutputFile -Force
}

$totalBytes = ($parts | Measure-Object -Property Length -Sum).Sum
$totalSizeGB = [math]::Round($totalBytes / 1GB, 2)

Write-Host ""
Write-Host "Parts       : $($parts.Count)" -ForegroundColor White
Write-Host "Total size  : $totalSizeGB GB" -ForegroundColor White
Write-Host "Output      : $OutputFile" -ForegroundColor White
Write-Host ""

$startTime    = Get-Date
$bytesWritten = 0

try {
    $writeStream = [System.IO.FileStream]::new(
        $OutputFile,
        [System.IO.FileMode]::Create,
        [System.IO.FileAccess]::Write
    )
} catch {
    Write-Host "Failed to create output file: $_" -ForegroundColor Red
    exit 1
}

$buffer = New-Object byte[] $bufferSize

foreach ($part in $parts) {
    Write-Host "Merging: $($part.Name)  ($([math]::Round($part.Length / 1MB, 1)) MB)" -ForegroundColor Cyan

    try {
        $readStream = [System.IO.FileStream]::new(
            $part.FullName,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::Read
        )
    } catch {
        Write-Host "Failed to open part file: $_" -ForegroundColor Red
        $writeStream.Close()
        exit 1
    }

    while ($true) {
        $read = $readStream.Read($buffer, 0, $bufferSize)
        if ($read -le 0) { break }
        $writeStream.Write($buffer, 0, $read)
        $bytesWritten += $read

        $pct = [math]::Round($bytesWritten / $totalBytes * 100)
        Write-Progress `
            -Activity "Combining parts" `
            -Status "$pct% complete  |  $([math]::Round($bytesWritten / 1GB, 2)) GB of $totalSizeGB GB" `
            -PercentComplete $pct
    }

    $readStream.Close()
}

$writeStream.Close()
Write-Progress -Activity "Combining parts" -Completed

$elapsed     = (Get-Date) - $startTime
$outSizeGB   = [math]::Round((Get-Item $OutputFile).Length / 1GB, 2)

Write-Host ""
Write-Host "Done. Output: $OutputFile ($outSizeGB GB)" -ForegroundColor Green
Write-Host "Elapsed     : $([math]::Round($elapsed.TotalMinutes, 1)) minutes" -ForegroundColor Gray
Write-Host ""

# Example Usage:
#   .\combine-binary-parts.ps1 -PartsDirectory "C:\path\to\parts" -OutputFile "C:\output\archive.zip"
#   .\combine-binary-parts.ps1 -PartsDirectory "D:\downloads\parts" -OutputFile "D:\downloads\restored.zip"
