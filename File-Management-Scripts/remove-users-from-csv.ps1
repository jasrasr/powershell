# Revision : 1.7
# Description : Validate paths, then build a unique list of "Display Name" excluding names in an exclude CSV (header "Display Name"). Optionally filter the source CSV rows. Shows progress and writes outputs next to input. Rev 1.7
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-29
# Modified Date : 2025-09-29

function Get-UniqueDisplayNamesFiltered {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$InputCsv,

        [Parameter(Mandatory)]
        [string]$ExcludeListCsv,

        [string]$ExcludeColumn = 'Display Name',

        [int]$TotalLines = 0,

        [int]$ProgressIntervalMS = 250,

        [switch]$FilterSourceRows
    )

    # --- Path validation ---
    if (-not (Test-Path -LiteralPath $InputCsv)) {
        Write-Host "Input CSV $InputCsv : NOT FOUND" -ForegroundColor Red
        return
    }
    if (-not (Test-Path -LiteralPath $ExcludeListCsv)) {
        Write-Host "Exclude CSV $ExcludeListCsv : NOT FOUND" -ForegroundColor Red
        return
    }

    # Resolve to full paths for clarity
    $InputCsv       = (Resolve-Path -LiteralPath $InputCsv).Path
    $ExcludeListCsv = (Resolve-Path -LiteralPath $ExcludeListCsv).Path

    Write-Host "Input CSV $InputCsv : OK" -ForegroundColor Green
    Write-Host "Exclude CSV $ExcludeListCsv : OK" -ForegroundColor Green

    function Get-ExcludeSet {
        param(
            [Parameter(Mandatory)]
            [string]$ExcludeListCsv,
            [string]$ExcludeColumn = 'Display Name'
        )

        $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $reader = [System.IO.StreamReader]::new($ExcludeListCsv)
        try {
            $first = $reader.ReadLine()
            if (-not $first) { return $set }

            $cellsFirst = $first -split ',(?=(?:[^""]*""[^""]*"")*[^""]*$)'
            $hasHeader  = $cellsFirst -contains ('"'+$ExcludeColumn+'"')

            if ($hasHeader) {
                $headers  = $cellsFirst
                $colIndex = $headers.IndexOf('"' + $ExcludeColumn + '"')
                if ($colIndex -lt 0) { $colIndex = 0 }
            } else {
                $colIndex = 0
                $value = $cellsFirst[$colIndex].Trim('"').Trim()
                if ($value) { $null = $set.Add($value) }
            }

            while (-not $reader.EndOfStream) {
                $line = $reader.ReadLine()
                if (-not $line) { continue }
                $cells = $line -split ',(?=(?:[^""]*""[^""]*"")*[^""]*$)'
                if ($cells.Count -gt $colIndex) {
                    $value = $cells[$colIndex].Trim('"').Trim()
                    if ($value) { $null = $set.Add($value) }
                }
            }
        }
        finally {
            if ($reader) { $reader.Dispose() }
        }
        return $set
    }

    $inputFolder = Split-Path $InputCsv
    $inputName   = [System.IO.Path]::GetFileNameWithoutExtension($InputCsv)
    $inputExt    = [System.IO.Path]::GetExtension($InputCsv)

    $uniqueOut   = Join-Path $inputFolder "$inputName-UniqueDisplayNames-Filtered.csv"
    $rowsOut     = Join-Path $inputFolder "$inputName-filteredByList$inputExt"

    Write-Host "Loading exclude list from $ExcludeListCsv ..." -ForegroundColor Cyan
    $excludeSet = Get-ExcludeSet -ExcludeListCsv $ExcludeListCsv -ExcludeColumn $ExcludeColumn
    Write-Host "Exclude list entries loaded $($excludeSet.Count) : names to remove" -ForegroundColor Yellow

    $unique = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $lastUpdate = Get-Date
    $totalBytes = (Get-Item -LiteralPath $InputCsv).Length

    $reader = [System.IO.StreamReader]::new($InputCsv)
    $writerRows = $null
    if ($FilterSourceRows) {
        $writerRows = [System.IO.StreamWriter]::new($rowsOut, $false, (New-Object System.Text.UTF8Encoding($false)))
    }

    $linesProcessed = 0
    $rowsKept = 0
    $rowsRemoved = 0

    try {
        $headerLine = $reader.ReadLine()
        if (-not $headerLine) { Write-Host "Input appears empty $InputCsv :" -ForegroundColor Red; return }

        if ($FilterSourceRows) { $writerRows.WriteLine($headerLine) }

        $headers  = $headerLine -split ',(?=(?:[^""]*""[^""]*"")*[^""]*$)'
        $dnIndex  = $headers.IndexOf('"Display Name"')
        if ($dnIndex -lt 0) { Write-Host "Column `"Display Name`" $InputCsv : NOT FOUND" -ForegroundColor Red; return }

        $dataTotal = if ($TotalLines -gt 0) { [math]::Max(1, $TotalLines - 1) } else { 0 }

        while (-not $reader.EndOfStream) {
            $line = $reader.ReadLine()
            if (-not $line) { continue }
            $linesProcessed++

            $cells = $line -split ',(?=(?:[^""]*""[^""]*"")*[^""]*$)'
            if ($cells.Count -gt $dnIndex) {
                $name = $cells[$dnIndex].Trim('"').Trim()
                if ($name) {
                    if (-not $excludeSet.Contains($name)) {
                        $null = $unique.Add($name)
                        if ($FilterSourceRows) { $writerRows.WriteLine($line); $rowsKept++ }
                    } else {
                        if ($FilterSourceRows) { $rowsRemoved++ }
                    }
                } else {
                    if ($FilterSourceRows) { $writerRows.WriteLine($line); $rowsKept++ }
                }
            } else {
                if ($FilterSourceRows) { $writerRows.WriteLine($line); $rowsKept++ }
            }

            $now = Get-Date
            if ( ($now - $lastUpdate).TotalMilliseconds -ge $ProgressIntervalMS ) {
                if ($TotalLines -gt 0) {
                    $pct  = [math]::Min(100, [math]::Round(($linesProcessed / $dataTotal) * 100, 2))
                    $rate = if ($sw.Elapsed.TotalSeconds -gt 0) { $linesProcessed / $sw.Elapsed.TotalSeconds } else { 0 }
                    $eta  = if ($rate -gt 0) { [TimeSpan]::FromSeconds( ($dataTotal - $linesProcessed) / $rate ) } else { [TimeSpan]::Zero }
                    Write-Progress -Id 1 -Activity "Scanning CSV..." -Status "Processed $linesProcessed of $dataTotal lines | Unique kept $($unique.Count) | Rows kept $rowsKept | Rows removed $rowsRemoved | ${pct}% | ETA $($eta.ToString())" -PercentComplete $pct
                } else {
                    $bytesRead = $reader.BaseStream.Position
                    $pct  = if ($totalBytes -gt 0) { [Math]::Min(100, [Math]::Round(($bytesRead / $totalBytes) * 100, 2)) } else { 0 }
                    $rate = if ($sw.Elapsed.TotalSeconds -gt 0) { $bytesRead / $sw.Elapsed.TotalSeconds } else { 0 }
                    $eta  = if ($rate -gt 0) { [TimeSpan]::FromSeconds( ($totalBytes - $bytesRead) / $rate ) } else { [TimeSpan]::Zero }
                    Write-Progress -Id 1 -Activity "Scanning CSV..." -Status "Processed $linesProcessed lines | Unique kept $($unique.Count) | Rows kept $rowsKept | Rows removed $rowsRemoved | ${pct}% | ETA $($eta.ToString())" -PercentComplete $pct
                }
                $lastUpdate = $now
            }
        }

        Write-Progress -Id 1 -Activity "Scanning CSV..." -Completed
    }
    finally {
        if ($writerRows) { $writerRows.Flush(); $writerRows.Dispose() }
        if ($reader) { $reader.Dispose() }
        $sw.Stop()
    }

    "Display Name" | Set-Content -Path $uniqueOut -Encoding UTF8
    $unique | Sort-Object | ForEach-Object { '"{0}"' -f $_ } | Add-Content -Path $uniqueOut -Encoding UTF8

    Write-Host "Unique names output $uniqueOut : $($unique.Count) entries" -ForegroundColor Green
    if ($FilterSourceRows) {
        Write-Host "Filtered CSV output $rowsOut : kept $rowsKept rows, removed $rowsRemoved rows" -ForegroundColor Green
    }
}

# --- Example usage with FULL PATHS (avoids .\ current-folder issues) ---
$SourceCsv  = 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered.csv'
$ExcludeCsv = 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered-UniqueDisplayNames-removed.csv'
$TotalLines = 1994689  # includes header

Get-UniqueDisplayNamesFiltered -InputCsv $SourceCsv -ExcludeListCsv $ExcludeCsv -TotalLines $TotalLines -FilterSourceRows
