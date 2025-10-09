# Revision : 1.0
# Description : Benchmark hash speeds (MD5 vs SHA1 vs SHA256) with progress, per-iteration stats, and CSV export. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-06
# Modified Date : 2025-10-06

param(
    [Parameter(Mandatory)]
    [string]$FilePath,

    [int]$Iterations = 1,

    [ValidateSet('MD5','SHA1','SHA256')]
    [string[]]$Algorithms = @('MD5','SHA1','SHA256')
)

# --- Prep --------------------------------------------------------------------
if (-not (Test-Path -LiteralPath $FilePath)) {
    Write-Host "File not found : $FilePath" -ForegroundColor Red
    return
}

try {
    $fileInfo = Get-Item -LiteralPath $FilePath -ErrorAction Stop
} catch {
    Write-Host "Unable to access file : $_" -ForegroundColor Red
    return
}

$bytesTotal   = $fileInfo.Length
$sizeMB       = [math]::Round($bytesTotal / 1MB, 2)
$dtStamp      = Get-Date -Format 'yyyyMMdd-HHmmss'
$exportFolder = 'C:\temp\powershell-exports'
$exportPath   = Join-Path $exportFolder "hash-benchmark-$dtStamp.csv"

if (-not (Test-Path $exportFolder)) { New-Item -Path $exportFolder -ItemType Directory -Force | Out-Null }

Write-Host "Benchmark target : $FilePath"
Write-Host "File size (MB)   : $sizeMB"
Write-Host "Iterations       : $Iterations"
Write-Host "Algorithms       : $($Algorithms -join ', ')"
Write-Host "CSV export path  : $exportPath"
Write-Host ""

# --- Helper : compute hash with progress -------------------------------------
function Get-FileHashProgress {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Algorithm,
        [int]$BufferSize = 4MB,
        [int]$ProgressId = 1
    )

    $stream = $null
    $hashAlg = $null
    try {
        $stream  = [System.IO.File]::OpenRead($Path)
        $hashAlg = [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm)

        $total   = $stream.Length
        $buf     = New-Object byte[] $BufferSize
        $readSum = 0
        $lastPct = -1

        $sw = [System.Diagnostics.Stopwatch]::StartNew()

        while (($read = $stream.Read($buf,0,$BufferSize)) -gt 0) {
            $hashAlg.TransformBlock($buf,0,$read,$null,0)
            $readSum += $read
            $pct = [int](($readSum / $total) * 100)
            if ($pct -ne $lastPct) {
                Write-Progress -Id $ProgressId -Activity "Hashing ${Algorithm}" -Status "$pct% ($([math]::Round($readSum/1MB,2)) / $([math]::Round($total/1MB,2)) MB)" -PercentComplete $pct
                $lastPct = $pct
            }
        }

        $hashAlg.TransformFinalBlock($buf,0,0) | Out-Null
        $sw.Stop()
        $hashBytes = $hashAlg.Hash
        $hash = ($hashBytes | ForEach-Object { $_.ToString('x2') }) -join ''

        Write-Progress -Id $ProgressId -Activity "Hashing ${Algorithm}" -Completed

        [pscustomobject]@{
            Algorithm    = $Algorithm
            Hash         = $hash
            ElapsedSec   = [math]::Round($sw.Elapsed.TotalSeconds,3)
            ThroughputMBs= if ($sw.Elapsed.TotalSeconds -gt 0) { [math]::Round(($total/1MB)/$sw.Elapsed.TotalSeconds,2) } else { [double]::PositiveInfinity }
        }
    }
    finally {
        if ($null -ne $stream)  { $stream.Dispose() }
        if ($null -ne $hashAlg) { $hashAlg.Dispose() }
    }
}

# --- Run bench ----------------------------------------------------------------
$results = New-Object System.Collections.Generic.List[object]

$progressMainId = 999
$totalWork = $Algorithms.Count * $Iterations
$workDone  = 0

for ($i = 1; $i -le $Iterations; $i++) {
    foreach ($algo in $Algorithms) {
        $workDone++
        $pctMain = [int](($workDone / $totalWork) * 100)
        Write-Progress -Id $progressMainId -Activity "Benchmarking hashes" -Status "Iteration $i of $Iterations : ${algo}" -PercentComplete $pctMain

        $res = Get-FileHashProgress -Path $FilePath -Algorithm $algo -ProgressId ($i*10)
        $results.Add([pscustomobject]@{
            FilePath       = $FilePath
            FileSizeMB     = $sizeMB
            Iteration      = $i
            Algorithm      = $res.Algorithm
            ElapsedSec     = $res.ElapsedSec
            ThroughputMBs  = $res.ThroughputMBs
            Hash           = $res.Hash
            Timestamp      = Get-Date
        })
        Write-Host "Completed ${algo} Iteration $i : ${res.ElapsedSec}s at ${res.ThroughputMBs} MB/s"
    }
}
Write-Progress -Id $progressMainId -Activity "Benchmarking hashes" -Completed

# --- Show summary -------------------------------------------------------------
$summary = $results | Group-Object Algorithm | ForEach-Object {
    $avgSec = ($_.Group | Measure-Object -Property ElapsedSec -Average).Average
    $avgThr = ($_.Group | Measure-Object -Property ThroughputMBs -Average).Average
    [pscustomobject]@{
        Algorithm     = $_.Name
        AvgElapsedSec = [math]::Round($avgSec,3)
        AvgMBps       = [math]::Round($avgThr,2)
    }
} | Sort-Object AvgElapsedSec

Write-Host ""
Write-Host "Average results by algorithm :" -ForegroundColor Cyan
$summary | Format-Table -AutoSize

# --- Export CSV ---------------------------------------------------------------
$results | Export-Csv -Path $exportPath -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Benchmark complete : $FilePath" -ForegroundColor Green
Write-Host "CSV saved          : $exportPath"
