# Filename: zip-split.ps1
# Revision : 1.0.0
# Description : Split a large binary file (zip, exe, etc.) into numbered parts using FileStream for memory-efficient handling
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-19
# Modified Date : 2026-05-19
# Changelog :
# 1.0.0 initial release

param (
    [Parameter(Mandatory = $true)]
    [string]$SourceFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [Parameter(Mandatory = $false)]
    [int]$PartSizeGB = 100
)

$partSizeBytes = $PartSizeGB * 1GB
$bufferSize    = 4MB

if (-not (Test-Path $SourceFile)) {
    Write-Host "Source file not found: $SourceFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $OutputDirectory)) {
    Write-Host "Creating output directory: $OutputDirectory" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
}

$fileName  = [System.IO.Path]::GetFileName($SourceFile)
$fileSize  = (Get-Item $SourceFile).Length
$totalParts = [math]::Ceiling($fileSize / $partSizeBytes)
$fileSizeGB = [math]::Round($fileSize / 1GB, 2)

Write-Host ""
Write-Host "Source      : $SourceFile" -ForegroundColor White
Write-Host "Size        : $fileSizeGB GB" -ForegroundColor White
Write-Host "Part size   : $PartSizeGB GB" -ForegroundColor White
Write-Host "Total parts : $totalParts" -ForegroundColor White
Write-Host "Output dir  : $OutputDirectory" -ForegroundColor White
Write-Host ""

try {
    $readStream = [System.IO.FileStream]::new(
        $SourceFile,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read
    )
} catch {
    Write-Host "Failed to open source file: $_" -ForegroundColor Red
    exit 1
}

$buffer    = New-Object byte[] $bufferSize
$startTime = Get-Date

for ($i = 0; $i -lt $totalParts; $i++) {
    $partNum  = $i + 1
    $partPad  = $partNum.ToString().PadLeft($totalParts.ToString().Length, '0')
    $outPath  = Join-Path $OutputDirectory "$fileName.part$partPad"
    $remaining = [math]::Min($partSizeBytes, $fileSize - $readStream.Position)
    $partSizeActualGB = [math]::Round($remaining / 1GB, 2)

    Write-Host "Writing part $partNum of $totalParts  ($partSizeActualGB GB)  ->  $outPath" -ForegroundColor Cyan

    try {
        $writeStream = [System.IO.FileStream]::new(
            $outPath,
            [System.IO.FileMode]::Create,
            [System.IO.FileAccess]::Write
        )
    } catch {
        Write-Host "Failed to create output file: $_" -ForegroundColor Red
        $readStream.Close()
        exit 1
    }

    $bytesWritten = 0
    while ($remaining -gt 0) {
        $toRead = [math]::Min($bufferSize, $remaining)
        $read   = $readStream.Read($buffer, 0, $toRead)
        if ($read -le 0) { break }
        $writeStream.Write($buffer, 0, $read)
        $remaining    -= $read
        $bytesWritten += $read

        $pctPart    = [math]::Round($bytesWritten / [math]::Min($partSizeBytes, $fileSize - ($readStream.Position - $bytesWritten) + $bytesWritten) * 100)
        $pctOverall = [math]::Round($readStream.Position / $fileSize * 100)
        Write-Progress `
            -Activity "Splitting $fileName" `
            -Status "Part $partNum/$totalParts  |  Overall: $pctOverall%  |  This part: $pctPart%" `
            -PercentComplete $pctOverall
    }

    $writeStream.Close()
    Write-Host "  Done  ($('{0:N0}' -f $bytesWritten) bytes)" -ForegroundColor Green
}

$readStream.Close()
Write-Progress -Activity "Splitting $fileName" -Completed

$elapsed = (Get-Date) - $startTime
Write-Host ""
Write-Host "Complete. $totalParts parts written to $OutputDirectory" -ForegroundColor Green
Write-Host "Elapsed  : $([math]::Round($elapsed.TotalMinutes, 1)) minutes" -ForegroundColor Gray
Write-Host ""

# Example Usage:
#   .\zip-split.ps1 -SourceFile "C:\path\to\archive.zip" -OutputDirectory "C:\path\to\output"
#   .\zip-split.ps1 -SourceFile "C:\path\to\archive.zip" -OutputDirectory "C:\path\to\output" -PartSizeGB 50
#   .\zip-split.ps1 -SourceFile "D:\backups\large-backup.zip" -OutputDirectory "D:\backups\parts" -PartSizeGB 100
