# Revision : 2.5
# Description : Stream folders exactly at depth 4 with live progress, timestamped incremental batch output every 1000 items,
#               Egnyte-offline retry detection, diagnostic comfort output, persistent heartbeats every minute (even below 1000),
#               checkpoint resume mid-batch, safe checkpoint retention, cached enumeration, and visual countdown to known baseline.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-05

param(
    [string]$BasePath   = "I:\",
    [string]$OutputRoot = "C:\temp",
    [int]   $BatchSize  = 1000,
    [int]   $KnownProcessed = 396094   # baseline from last run (for countdown display)
)

# --- constants ---
$BaseDepth  = ($BasePath.TrimEnd('\') -split '\\').Count
$found      = 0
$processed  = 0
$results    = @()
$HeartbeatInterval = [timespan]::FromMinutes(1)     # heartbeat every minute
$LastHeartbeat = Get-Date
$RunStamp   = "20251104-1155"   # reuse timestamp from current run
$SummaryFile = "C:\temp\egnyte-depth4-summary-20251104-1155.txt"
$Checkpoint  = "C:\temp\egnyte-depth4-checkpoint.txt"
$CacheFile   = "C:\temp\egnyte-depth4-master.txt"
$Resume      = $false
$batchNum    = 1
$LastPath    = $null

# --- detect checkpoint ---
if (Test-Path $Checkpoint) {
    try {
        $LastPath = Get-Content $Checkpoint -ErrorAction Stop | Select-Object -Last 1
        if ($LastPath) {
            $Resume = $true
            Write-Host "Checkpoint detected. Resuming scan after last processed path :" -ForegroundColor Yellow
            Write-Host "  $LastPath" -ForegroundColor Yellow
        }
    } catch {
        Write-Warning "Unable to read checkpoint file. Starting fresh."
    }
}

# --- intro ---
if (-not $Resume) {
    "Scan started : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content -Path $SummaryFile
    Write-Host "Starting new depth-4 scan of $BasePath : $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
}
else {
    Add-Content -Path $SummaryFile -Value ("Scan resumed : {0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
    Write-Host "Resuming scan... crawling directories to checkpoint (this may take several minutes)" -ForegroundColor DarkYellow
}

$StartTime = Get-Date
$Skip = $Resume

# --- main loop ---
Get-ChildItem -Path $BasePath -Directory -Recurse -Depth 4 -ErrorAction SilentlyContinue |
ForEach-Object {
    $processed++

    # diagnostic heartbeat every 1000 processed
    if ($processed % 1000 -eq 0) {
        $remaining = [Math]::Max($KnownProcessed - $processed, 0)
        Write-Host ("Still enumerating... processed {0} so far | remaining to baseline : {1:N0}" -f $processed, $remaining) -ForegroundColor Gray
    }

    # time-based heartbeat every minute even if <1000
    $Now = Get-Date
    if ($Now - $LastHeartbeat -ge $HeartbeatInterval) {
        $remaining = [Math]::Max($KnownProcessed - $processed, 0)
        $NextBeat  = 60 - ((Get-Date).Second)
        Write-Host ("[Heartbeat] {0} — Processed {1} | Remaining to baseline : {2:N0} | Next update in {3}s" -f $Now.ToString("HH:mm:ss"), $processed, $remaining, $NextBeat) -ForegroundColor DarkCyan
        Add-Content -Path $SummaryFile -Value ("[Heartbeat] {0} — Processed {1} | Remaining {2:N0} | Batch {3}" -f $Now.ToString("yyyy-MM-dd HH:mm:ss"), $processed, $remaining, $batchNum)
        $LastHeartbeat = $Now
    }

    # Egnyte offline detection
    if (-not (Test-Path $BasePath)) {
        Write-Warning "Egnyte drive offline — pausing for 30s"
        Add-Content -Path $SummaryFile -Value ("[Offline] {0} — Egnyte path not accessible" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
        Start-Sleep -Seconds 30
        return
    }

    $currentPath = $_.FullName

    # --- cache enumeration ---
    Add-Content -Path $CacheFile -Value $currentPath

    # skip until we reach the checkpoint path
    if ($Skip) {
        if ($currentPath -eq $LastPath) {
            $Skip = $false
        }
        return
    }

    # progress bar
    if ($processed % 100 -eq 0) {
        Write-Progress -Activity "Scanning directories..." -Status "Processed $processed | Found $found | Current batch $batchNum" -PercentComplete 0
    }

    # only count depth 4
    if (($_.FullName -split '\\').Count -eq ($BaseDepth + 4)) {
        $results += $_.FullName
        $found++
        Set-Content -Path $Checkpoint -Value $currentPath

        if ($results.Count -ge $BatchSize) {
            $BatchFile = Join-Path $OutputRoot ("egnyte-depth4-batch{0:000}-{1}.txt" -f $batchNum, $RunStamp)
            $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $results | Set-Content -Path $BatchFile
            Add-Content -Path $BatchFile -Value ("`n# Batch {0:000} complete : {1} items : {2}" -f $batchNum, $BatchSize, $TimeStamp)
            Write-Host "Batch $batchNum complete : $BatchSize items saved to $BatchFile" -ForegroundColor Green
            Add-Content -Path $SummaryFile -Value ("Batch {0:000} complete : {1} items : {2}" -f $batchNum, $BatchSize, $TimeStamp)
            Start-Process notepad.exe $BatchFile
            $results = @()
            $batchNum++
        }
    }
}

# --- export remainder ---
if ($results.Count -gt 0) {
    $BatchFile = Join-Path $OutputRoot ("egnyte-depth4-batch{0:000}-{1}.txt" -f $batchNum, $RunStamp)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $results | Set-Content -Path $BatchFile
    Add-Content -Path $BatchFile -Value ("`n# Batch {0:000} complete : {1} items : {2}" -f $batchNum, $results.Count, $TimeStamp)
    Write-Host "Final batch $batchNum complete : $($results.Count) items saved to $BatchFile" -ForegroundColor Green
    Add-Content -Path $SummaryFile -Value ("Batch {0:000} complete : {1} items : {2}" -f $batchNum, $results.Count, $TimeStamp)
    Start-Process notepad.exe $BatchFile
}

# --- wrap up ---
$EndTime  = Get-Date
$Elapsed  = ($EndTime - $StartTime).ToString("hh\:mm\:ss")
$EndStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Add-Content -Path $SummaryFile -Value "`nScan complete : $found folders found in $Elapsed (ended $EndStamp)"
Write-Host "Scan complete. Total found : $found folders at depth 4. Time taken : $Elapsed" -ForegroundColor Cyan
Write-Host "Batch summary logged to : $SummaryFile"

# --- safe checkpoint cleanup ---
if ($found -gt 0) {
    Write-Host "Scan finished normally; checkpoint retained for verification." -ForegroundColor Yellow
}
else {
    Write-Host "No new folders found; keeping checkpoint for next run." -ForegroundColor DarkYellow
}

Write-Host "Cached enumeration saved to : $CacheFile" -ForegroundColor Gray
