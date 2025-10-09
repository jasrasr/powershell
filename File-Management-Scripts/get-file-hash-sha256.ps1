# Revision : 1.1
# Description : Quick SHA256 file hash calculator (no console spam). Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-06
# Modified Date : 2025-10-06

param(
    [Parameter(Mandatory)]
    [string]$FilePath
)

if (-not (Test-Path -LiteralPath $FilePath)) {
    Write-Host "File not found : $FilePath" -ForegroundColor Red
    return
}

$bufferSize = 4MB
$stream     = [System.IO.File]::OpenRead($FilePath)
$hashAlg    = [System.Security.Cryptography.SHA256]::Create()
$buffer     = New-Object byte[] $bufferSize
$totalBytes = $stream.Length
$readBytes  = 0
$lastPct    = -1
$start      = Get-Date

Write-Host "Calculating SHA256 hash for $FilePath ..."
while (($read = $stream.Read($buffer,0,$bufferSize)) -gt 0) {
    $hashAlg.TransformBlock($buffer,0,$read,$null,0) | Out-Null   # suppress 4194304 spam
    $readBytes += $read
    $pct = [int](($readBytes / $totalBytes) * 100)
    if ($pct -ne $lastPct) {
        Write-Progress -Activity "Hashing file" `
                       -Status "$pct% ($([math]::Round($readBytes / 1MB,2)) / $([math]::Round($totalBytes / 1MB,2)) MB)" `
                       -PercentComplete $pct
        $lastPct = $pct
    }
}
$hashAlg.TransformFinalBlock($buffer,0,0) | Out-Null
$hash = ($hashAlg.Hash | ForEach-Object { $_.ToString('x2') }) -join ''
$stream.Close()
$hashAlg.Dispose()

$elapsed = (Get-Date) - $start
$mbps = [math]::Round(($totalBytes / 1MB) / $elapsed.TotalSeconds,2)

Write-Progress -Activity "Hashing file" -Completed
Write-Host "SHA256 hash  : $hash"
Write-Host "File size    : $([math]::Round($totalBytes / 1MB,2)) MB"
Write-Host "Time elapsed : $([math]::Round($elapsed.TotalSeconds,2)) sec"
Write-Host "Throughput   : $mbps MB/s"
