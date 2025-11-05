# Revision : 2.4
# Description : Stream folders exactly at depth 4 with live progress, timestamped incremental batch output every 1000 items,
#               Egnyte-offline retry detection, checkpoint resume mid-batch, diagnostic comfort messages during catch-up,
#               persistent heartbeats, safe checkpoint retention, and local caching of all enumerated folders.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-05

param(
    [string]$BasePath   = "I:\",
    [string]$OutputRoot = "C:\temp",
    [int]   $BatchSize  = 1000
)

# --- constants ---
$BaseDepth  = ($BasePath.TrimEnd('\') -split '\\').Count
$found      = 0
$processed  = 0
$results    = @()
$HeartbeatInterval = [timespan]::FromMinutes(2)
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

    # diagnostic heartbeat during long pre-checkpoint crawl
    if ($processed % 1000 -eq 0) {
        Write-Host "Still enumerating... processed $processed so far" -ForegroundColor Gray
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

    # heartbeat logging every 2 minutes
    $Now = Get-Date
    if ($Now - $LastHeartbeat -ge $HeartbeatInterval) {
        Add-Content -Path $SummaryFile -Value ("[Heartbeat] {0} — Processed {1} | Found {2} | Batch {3}" -f $Now.ToString("yyyy-MM-dd HH:mm:ss"), $processed, $found, $batchNum)
        $LastHeartbeat = $Now
        Write-Host "Heartbeat logged at $($Now.ToString('HH:mm:ss')) — Processed $processed" -ForegroundColor DarkCyan
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
