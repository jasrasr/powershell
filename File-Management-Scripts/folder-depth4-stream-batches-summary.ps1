# Revision : 2.2
# Description : Stream folders exactly at depth 4 with live progress bar, timestamped incremental file output every 1000 items,
#               auto-open each batch and summary in Notepad, append per-batch footer, log all batches to a master summary file,
#               exact checkpoint resume mid-batch, and periodic heartbeat logging for long scans
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

# --- Resume override ---
$SummaryFile = "C:\temp\egnyte-depth4-summary-20251104-1155.txt"
$Checkpoint  = "C:\temp\egnyte-depth4-checkpoint.txt"



$BasePath   = "I:\"      # adjust as needed
$OutputRoot = "C:\temp"
$BaseDepth  = ($BasePath.TrimEnd('\') -split '\\').Count
$BatchSize  = 1000
$found      = 0
$processed  = 0
$results    = @()
$HeartbeatInterval = [timespan]::FromMinutes(2)   # how often to log heartbeat
$LastHeartbeat = Get-Date

# --- run metadata ---
# $RunStamp     = Get-Date -Format "yyyyMMdd-HHmm"
# $SummaryFile  = Join-Path $OutputRoot ("egnyte-depth4-summary-{0}.txt" -f $RunStamp) #default
# $SummaryFile = "C:\temp\egnyte-depth4-summary-20251104-1155.txt" # picking up from last run
# $Checkpoint   = Join-Path $OutputRoot "egnyte-depth4-checkpoint.txt"
$Resume       = $false
$LastPath     = $null
$batchNum     = 1

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

<#
if ((Test-Path $SummaryFile) -and (-not $Resume)) {
    Remove-Item $SummaryFile -Force
}
#>

if (-not $Resume) {
    "Scan started : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content -Path $SummaryFile
    Write-Host "Starting new depth-4 scan of $BasePath : $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
}

$StartTime = Get-Date

# --- main loop with heartbeat + checkpoint resume ---
$Skip = $Resume
Get-ChildItem -Path $BasePath -Directory -Recurse -Depth 4 -ErrorAction SilentlyContinue |
ForEach-Object {
    $processed++
    $currentPath = $_.FullName

    # skip until reaching checkpoint
    if ($Skip) {
        if ($currentPath -eq $LastPath) {
            $Skip = $false
        }
        return
    }

    # progress update
    if ($processed % 500 -eq 0) {
        Write-Progress -Activity "Scanning directories..." -Status "Processed $processed | Found $found | Current batch $batchNum" -PercentComplete 0
    }

    # heartbeat logging every few minutes
    $Now = Get-Date
    if ($Now - $LastHeartbeat -ge $HeartbeatInterval) {
        Add-Content -Path $SummaryFile -Value ("[Heartbeat] {0} — Processed {1} items, Found {2}, Current batch {3}" -f ($Now.ToString("yyyy-MM-dd HH:mm:ss")), $processed, $found, $batchNum)
        $LastHeartbeat = $Now
        Write-Host "Heartbeat logged at $($Now.ToString('HH:mm:ss')) — Processed $processed" -ForegroundColor DarkCyan
    }

    # only count depth 4
    if (($_.FullName -split '\\').Count -eq ($BaseDepth + 4)) {
        $results += $_.FullName
        $found++
        # write checkpoint after each item
        Set-Content -Path $Checkpoint -Value $currentPath

        # export when batch full
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

# cleanup checkpoint
# Remove-Item $Checkpoint -Force -ErrorAction SilentlyContinue
Start-Process notepad.exe $SummaryFile

# Example usage:
# & "$githubpath\PowerShell\File-Management-Scripts\folder-depth4-stream-batches-summary.ps1"
