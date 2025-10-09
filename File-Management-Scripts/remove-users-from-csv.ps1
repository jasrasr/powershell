# Revision : 1.8
# Description : Robust header handling + exclude filtering. Extract/keep unique "Display Name" values excluding a provided CSV list, optionally filter source rows. Fixes "Display Name not found" by normalizing header quotes/whitespace/BOM. Shows progress. Rev 1.8
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

    # --- Path validation
    if (-not (Test-Path -LiteralPath $InputCsv)) {
        Write-Host "Input CSV $InputCsv : NOT FOUND" -ForegroundColor Red
        return
    }
    if (-not (Test-Path -LiteralPath $ExcludeListCsv)) {
        Write-Host "Exclude CSV $ExcludeListCsv : NOT FOUND" -ForegroundColor Red
        return
    }
    $InputCsv       = (Resolve-Path -LiteralPath $InputCsv).Path
    $ExcludeListCsv = (Resolve-Path -LiteralPath $ExcludeListCsv).Path
    Write-Host "Input CSV $InputCsv : OK" -ForegroundColor Green
    Write-Host "Exclude CSV $ExcludeListCsv : OK" -ForegroundColor Green

    # --- Load exclude set (one-column CSV with header "Display Name" OR any CSV with that column)
    function Get-ExcludeSet {
        param(
            [Parameter(Mandatory)] [string]$CsvPath,
            [string]$ColName = 'Display Name'
        )
        $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $r = [System.IO.StreamReader]::new($CsvPath)
        try {
            $first = $r.ReadLine()
            if (-not $first) { return $set }

            $hdrRaw = $first -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
            # Normalize headers: trim whitespace, trim quotes, strip BOM
            $hdr = $hdrRaw | ForEach-Object {
                $s = $_.Trim()
                if ($s.Length -gt 0 -and [int][char]$s[0] -eq 0xFEFF) { $s = $s.Substring(1) } # strip BOM
                $s.Trim('"')
            }

            $idx = [Array]::IndexOf(($hdr | ForEach-Object { $_.ToLowerInvariant() }), $ColName.ToLowerInvariant())
            if ($idx -ge 0) {
                # file has header row; read remaining lines as data
                while (-not $r.EndOfStream) {
                    $line  = $r.ReadLine()
                    if (-not $line) { continue }
                    $cells = $line -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
                    if ($cells.Count -gt $idx) {
                        $val = $cells[$idx].Trim().Trim('"')
                        if ($val) { $null = $set.Add($val) }
                    }
                }
            } else {
                # no header; treat first line as value
                $val = $hdrRaw[0].Trim().Trim('"')
                if ($val) { $null = $set.Add($val) }
                while (-not $r.EndOfStream) {
                    $line = $r.ReadLine()
                    if (-not $line) { continue }
                    $val = ($line -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)')[0].Trim().Trim('"')
                    if ($val) { $null = $set.Add($val) }
                }
            }
        } finally {
            if ($r) { $r.Dispose() }
        }
        return $set
    }

    $excludeSet = Get-ExcludeSet -CsvPath $ExcludeListCsv -ColName $ExcludeColumn
    Write-Host "Exclude list entries loaded $($excludeSet.Count) : names to remove" -ForegroundColor Yellow

    # --- Prep outputs
    $inputFolder = Split-Path $InputCsv
    $inputName   = [System.IO.Path]::GetFileNameWithoutExtension($InputCsv)
    $inputExt    = [System.IO.Path]::GetExtension($InputCsv)

    $uniqueOut   = Join-Path $inputFolder "$inputName-UniqueDisplayNames-Filtered.csv"
    $rowsOut     = Join-Path $inputFolder "$inputName-filteredByList$inputExt"

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
        # --- Read & normalize header
        $headerLine = $reader.ReadLine()
        if (-not $headerLine) { Write-Host "Input appears empty $InputCsv :" -ForegroundColor Red; return }

        if ($FilterSourceRows) { $writerRows.WriteLine($headerLine) }

        $hdrRaw = $headerLine -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
        $hdr = $hdrRaw | ForEach-Object {
            $s = $_.Trim()
            if ($s.Length -gt 0 -and [int][char]$s[0] -eq 0xFEFF) { $s = $s.Substring(1) } # strip BOM if present
            $s.Trim('"')
        }

        # --- Find "Display Name" column index case-insensitively
        $dnIndex = [Array]::IndexOf(($hdr | ForEach-Object { $_.ToLowerInvariant() }), 'display name')
        if ($dnIndex -lt 0) {
            Write-Host "Column `"Display Name`" $InputCsv : NOT FOUND" -ForegroundColor Red
            Write-Host "Detected columns $InputCsv : $($hdr -join '; ')" -ForegroundColor Yellow
            return
        }

        $dataTotal = if ($TotalLines -gt 0) { [math]::Max(1, $TotalLines - 1) } else { 0 }

        # --- Stream rows
        while (-not $reader.EndOfStream) {
            $line = $reader.ReadLine()
            if (-not $line) { continue }
            $linesProcessed++

            $cells = $line -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
            if ($cells.Count -gt $dnIndex) {
                $name = $cells[$dnIndex].Trim().Trim('"')
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

            # --- Progress
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

    # --- Write outputs
    "Display Name" | Set-Content -Path $uniqueOut -Encoding UTF8
    $unique | Sort-Object | ForEach-Object { '"{0}"' -f $_ } | Add-Content -Path $uniqueOut -Encoding UTF8

    Write-Host "Unique names output $uniqueOut : $($unique.Count) entries" -ForegroundColor Green
    if ($FilterSourceRows) {
        Write-Host "Filtered CSV output $rowsOut : kept $rowsKept rows, removed $rowsRemoved rows" -ForegroundColor Green
    }
}

# --- Example usage with your files and exact line count ---
Get-UniqueDisplayNamesFiltered `
  -InputCsv 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered.csv' `
  -ExcludeListCsv 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV-filtered-UniqueDisplayNames-removed.csv' `
  -TotalLines 1994689 `
  -FilterSourceRows
