# Revision : 1.3
# Description : Stream-filter a very large CSV and remove rows containing the cell "List Folder Contents". Saves output in the SAME folder with "-filtered" suffix, reports how many lines were removed, and shows a responsive progress bar with ETA. Rev 1.3
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-29
# Modified Date : 2025-09-29

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$InputCsv,

    [string]$FilterText = 'List Folder Contents',

    [switch]$PreserveHeader = $true,

    # Throttle progress UI updates (in milliseconds)
    [int]$ProgressIntervalMS = 250
)

# -- Output in same folder with -filtered suffix
$inputFolder = Split-Path $InputCsv
$inputName   = [System.IO.Path]::GetFileNameWithoutExtension($InputCsv)
$inputExt    = [System.IO.Path]::GetExtension($InputCsv)
$OutputCsv   = Join-Path $inputFolder "$inputName-filtered$inputExt"

# -- Counters
$linesTotal   = 0
$linesKept    = 0
$linesRemoved = 0

# -- Prepare encoding and search token
$encoding = New-Object System.Text.UTF8Encoding($false)   # UTF-8 without BOM
$cmp      = [System.StringComparison]::OrdinalIgnoreCase
$needle   = '"' + $FilterText + '"'                       # match the quoted cell text anywhere in the row

# -- Size for progress
$totalBytes = (Get-Item -LiteralPath $InputCsv).Length
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$lastUpdate = Get-Date

# -- Open streams
$reader = [System.IO.StreamReader]::new($InputCsv)
$writer = [System.IO.StreamWriter]::new($OutputCsv, $false, $encoding)

try {
    $isFirstLine = $true

    while (-not $reader.EndOfStream) {
        $line = $reader.ReadLine()
        $linesTotal++

        if ($isFirstLine -and $PreserveHeader) {
            $writer.WriteLine($line)
            $linesKept++
            $isFirstLine = $false
        }
        else {
            if ($line.IndexOf($needle, $cmp) -ge 0) {
                $linesRemoved++
            } else {
                $writer.WriteLine($line)
                $linesKept++
            }
        }

        # -- Progress (throttled)
        $now = Get-Date
        if ( ($now - $lastUpdate).TotalMilliseconds -ge $ProgressIntervalMS ) {
            $bytesRead  = $reader.BaseStream.Position
            if ($totalBytes -gt 0) {
                $pct   = [Math]::Min(100, [Math]::Round(($bytesRead / $totalBytes) * 100, 2))
                $rate  = if ($sw.Elapsed.TotalSeconds -gt 0) { $bytesRead / $sw.Elapsed.TotalSeconds } else { 0 }  # bytes/sec
                $eta   = if ($rate -gt 0) { [TimeSpan]::FromSeconds( ($totalBytes - $bytesRead) / $rate ) } else { [TimeSpan]::Zero }

                Write-Progress -Id 1 -Activity "Filtering CSV..." -Status "Processed $linesTotal lines | Kept $linesKept | Removed $linesRemoved | ${pct}% | ETA $($eta.ToString())" -PercentComplete $pct
            } else {
                Write-Progress -Id 1 -Activity "Filtering CSV..." -Status "Processed $linesTotal lines | Kept $linesKept | Removed $linesRemoved" -PercentComplete 0
            }
            $lastUpdate = $now
        }
    }

    # -- Final progress at 100%
    Write-Progress -Id 1 -Activity "Filtering CSV..." -Completed
}
finally {
    $writer.Flush()
    $writer.Dispose()
    $reader.Dispose()
    $sw.Stop()
}

Write-Host "Input file $InputCsv : processed $linesTotal lines in $([int]$sw.Elapsed.TotalSeconds)s"
Write-Host "Output file $OutputCsv : wrote $linesKept lines"
Write-Host "Filtered value $FilterText : removed $linesRemoved lines"

# --- Example run ---
# .\filter-csv.ps1 -InputCsv 'C:\file.csv'
