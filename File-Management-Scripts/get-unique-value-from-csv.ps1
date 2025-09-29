# Revision : 1.3
# Description : Extract a unique list of "Display Name" values from a very large CSV with a progress bar. Supports exact line-based progress when -TotalLines is provided. Saves results to a new CSV in the same folder with header "Display Name". Rev 1.3
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-29
# Modified Date : 2025-09-29

[CmdletBinding()]
param(
    [string]$InputCsv = 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered.csv',

    # Set this to the total number of lines in the CSV (including header) for exact line-based progress
    [int]$TotalLines = 0,

    # How often to refresh progress bar in ms
    [int]$ProgressIntervalMS = 250
)

$inputFolder = Split-Path $InputCsv
$inputName   = [System.IO.Path]::GetFileNameWithoutExtension($InputCsv)
$outputFile  = Join-Path $inputFolder "$inputName-UniqueDisplayNames.csv"

# HashSet for uniqueness
$hash = [System.Collections.Generic.HashSet[string]]::new()

# Progress tracking
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$lastUpdate = Get-Date

# For byte-based progress fallback
$totalBytes = (Get-Item -LiteralPath $InputCsv).Length

$reader = [System.IO.StreamReader]::new($InputCsv)

try {
    # Parse header row to find the "Display Name" column index
    $headerLine = $reader.ReadLine()
    if (-not $headerLine) {
        throw "Input appears empty or unreadable"
    }

    $headers  = $headerLine -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
    $colIndex = $headers.IndexOf('"Display Name"')
    if ($colIndex -lt 0) {
        throw "Column 'Display Name' not found in header"
    }

    $linesProcessed = 0
    $linesData      = if ($TotalLines -gt 0) { [math]::Max(1, $TotalLines - 1) } else { 0 } # exclude header for progress

    while (-not $reader.EndOfStream) {
        $line = $reader.ReadLine()
        $linesProcessed++

        $cells = $line -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
        if ($cells.Count -gt $colIndex) {
            $value = $cells[$colIndex].Trim('"')
            if ($value -and -not $hash.Contains($value)) {
                $null = $hash.Add($value)
            }
        }

        # Throttled progress update
        $now = Get-Date
        if ( ($now - $lastUpdate).TotalMilliseconds -ge $ProgressIntervalMS ) {
            if ($TotalLines -gt 0) {
                # Exact line-based progress
                $pct  = [math]::Min(100, [math]::Round(($linesProcessed / $linesData) * 100, 2))
                $rate = if ($sw.Elapsed.TotalSeconds -gt 0) { $linesProcessed / $sw.Elapsed.TotalSeconds } else { 0 } # lines/sec
                $eta  = if ($rate -gt 0) { [TimeSpan]::FromSeconds( ($linesData - $linesProcessed) / $rate ) } else { [TimeSpan]::Zero }

                Write-Progress -Id 1 -Activity "Extracting unique Display Names..." -Status "Processed $linesProcessed of $linesData lines | Found $($hash.Count) unique | ${pct}% | ETA $($eta.ToString())" -PercentComplete $pct
            } else {
                # Fallback to byte-based progress
                $bytesRead = $reader.BaseStream.Position
                $pct  = if ($totalBytes -gt 0) { [Math]::Min(100, [Math]::Round(($bytesRead / $totalBytes) * 100, 2)) } else { 0 }
                $rate = if ($sw.Elapsed.TotalSeconds -gt 0) { $bytesRead / $sw.Elapsed.TotalSeconds } else { 0 } # bytes/sec
                $eta  = if ($rate -gt 0) { [TimeSpan]::FromSeconds( ($totalBytes - $bytesRead) / $rate ) } else { [TimeSpan]::Zero }

                Write-Progress -Id 1 -Activity "Extracting unique Display Names..." -Status "Processed $linesProcessed lines | Found $($hash.Count) unique | ${pct}% | ETA $($eta.ToString())" -PercentComplete $pct
            }
            $lastUpdate = $now
        }
    }

    Write-Progress -Id 1 -Activity "Extracting unique Display Names..." -Completed
}
finally {
    $reader.Dispose()
    $sw.Stop()
}

# Write results with header
"Display Name" | Set-Content -Path $outputFile -Encoding UTF8
$hash | Sort-Object | ForEach-Object { '"{0}"' -f $_ } | Add-Content -Path $outputFile -Encoding UTF8

Write-Host "Input file $InputCsv : processed $linesProcessed data lines in $([int]$sw.Elapsed.TotalSeconds)s"
Write-Host "Unique Display Names written to $outputFile"
Write-Host "Total unique Display Names : $($hash.Count)"

# Example using your count:
# .\get-unique-displaynames.ps1 -InputCsv 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered.csv' -TotalLines 1994689
