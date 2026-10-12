<#
.SYNOPSIS
    Heartbeat monitor for a robocopy /MOVE job between two local drives.

.DESCRIPTION
    Captures the source drive's used-space total as the "amount to move" baseline,
    then periodically checks how much used space has been added to the destination
    drive. Reports a running percent-complete. If growth stays below a variance
    threshold for a configurable stall period, the job is treated as finished even
    if it never reaches exactly 100% (accounts for filesystem overhead differences
    between source/dest, e.g. cluster size, so byte counts rarely match exactly).

    This is space-based only — it does NOT parse the robocopy log or verify errors.
    Run it alongside/right after starting robocopy, and still check the robocopy
    log afterward for skipped/failed files.

.PARAMETER SourceDrive
    Drive letter robocopy is moving FROM (no colon), e.g. "D".

.PARAMETER DestDrive
    Drive letter robocopy is moving TO (no colon), e.g. "E".

.PARAMETER HeartbeatSeconds
    How often to check drive space, in seconds. Default 60.

.PARAMETER StallMinutes
    If destination growth stays under the variance threshold for this many
    minutes straight, the job is declared "finished" even if not at 100%.
    Default 15.

.PARAMETER VarianceGB
    Growth (in GB) below this amount, per single check interval, counts as
    "no meaningful change" toward the stall timer. Default 0.05 GB (~50 MB),
    to absorb small metadata/log writes that aren't the bulk transfer.

.PARAMETER CompletionTolerancePct
    How close to 100% counts as "done" outright. Default 0.05, i.e. 99.95%+
    is treated as complete (byte-for-byte matching between source used-space
    and dest used-space is unlikely due to filesystem overhead).

.PARAMETER LogPath
    Where to write the heartbeat log. Defaults to a timestamped file in C:\temp.

.EXAMPLE
    # Run this in its own PowerShell window right when you kick off robocopy:
    .\robocopy-heartbeat.ps1 -SourceDrive D -DestDrive E

.EXAMPLE
    # Tighter stall detection, checking every 30 seconds:
    .\robocopy-heartbeat.ps1 -SourceDrive D -DestDrive E -HeartbeatSeconds 30 -StallMinutes 10
#>

param(
    [string]$SourceDrive            = "D",
    [string]$DestDrive              = "E",
    [int]$HeartbeatSeconds          = 60,
    [int]$StallMinutes              = 15,
    [double]$VarianceGB             = 0.05,
    [double]$CompletionTolerancePct = 0.05,
    [string]$LogPath                = "C:\temp\robocopy-heartbeat-$(Get-Date -Format 'MMddyy-HHmm').log",
    [switch]$NoCountdown
)

# Use DriveInfo instead of Get-PSDrive — Get-PSDrive's Used/Free values can go
# stale inside a long-running session because the provider caches them.
# DriveInfo queries the OS fresh every time.
function Get-UsedBytes {
    param([string]$DriveLetter)
    $di = [System.IO.DriveInfo]::new("$DriveLetter`:")
    return $di.TotalSize - $di.AvailableFreeSpace
}

$GB = 1GB

# Make sure the log directory exists
$logDir = Split-Path -Path $LogPath -Parent
if ($logDir -and -not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-Line {
    param([string]$Text, [string]$Color = "Gray")
    $Text | Out-File -FilePath $LogPath -Append -Encoding utf8
    Write-Host $Text -ForegroundColor $Color
}

# Console-only countdown between checks — never written to the log file,
# just an in-place (carriage-return) live display so the log stays clean.
function Show-Countdown {
    param([int]$Seconds)
    if ($NoCountdown -or $Seconds -le 0) {
        Start-Sleep -Seconds $Seconds
        return
    }
    for ($i = $Seconds; $i -ge 1; $i--) {
        $label = "Next check in: {0,3}s" -f $i
        Write-Host ("`r{0}{1}" -f $label, (" " * 10)) -NoNewline -ForegroundColor DarkGray
        Start-Sleep -Seconds 1
    }
    # Clear the countdown line before the heartbeat line prints
    Write-Host ("`r" + (" " * 40) + "`r") -NoNewline
}

Write-Line "Capturing baseline at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')..." "Cyan"

$initialSourceUsed = Get-UsedBytes -DriveLetter $SourceDrive
$initialDestUsed   = Get-UsedBytes -DriveLetter $DestDrive
$totalToMove       = $initialSourceUsed   # assumes source's current used space = what needs to move

Write-Line ("Source ({0}:) used = {1:N2} GB  <- total to move" -f $SourceDrive, ($initialSourceUsed / $GB)) "Cyan"
Write-Line ("Dest   ({0}:) used = {1:N2} GB  <- baseline, pre-existing data on dest excluded from %" -f $DestDrive, ($initialDestUsed / $GB)) "Cyan"
Write-Line ("Heartbeat every {0}s | stall = finished after {1} min under {2} GB growth | complete >= {3}%" -f `
    $HeartbeatSeconds, $StallMinutes, $VarianceGB, (100 - $CompletionTolerancePct)) "Cyan"
Write-Line "----------------------------------------------------------------------" "Cyan"

if ($totalToMove -le 0) {
    Write-Line "Source drive shows 0 bytes used already — nothing to monitor. Exiting." "Yellow"
    return
}

$varianceBytes  = $VarianceGB * $GB
$lastDeltaAdded = 0
$lastChangeTime = Get-Date
$startTime      = Get-Date

while ($true) {
    Show-Countdown -Seconds $HeartbeatSeconds

    $currentDestUsed   = Get-UsedBytes -DriveLetter $DestDrive
    $currentSourceUsed = Get-UsedBytes -DriveLetter $SourceDrive

    $deltaAdded = $currentDestUsed - $initialDestUsed
    if ($deltaAdded -lt 0) { $deltaAdded = 0 }   # guard against odd/negative readings

    $sourceRemoved = $initialSourceUsed - $currentSourceUsed
    if ($sourceRemoved -lt 0) { $sourceRemoved = 0 }

    $percent = if ($totalToMove -gt 0) { ($deltaAdded / $totalToMove) * 100 } else { 100 }
    $percent = [math]::Min($percent, 100)

    $growthSinceLastCheck = $deltaAdded - $lastDeltaAdded
    $rateGBPerMin = if ($HeartbeatSeconds -gt 0) { ($growthSinceLastCheck / $GB) / ($HeartbeatSeconds / 60) } else { 0 }

    $now = Get-Date
    $elapsed = $now - $startTime

    $line = "{0}  {1,8:N4}%  dest+={2,9:N2} GB  src-={3,9:N2} GB  of {4,9:N2} GB  rate={5,6:N2} GB/min  elapsed={6}" -f `
        $now.ToString("yyyy-MM-dd HH:mm:ss"), $percent, ($deltaAdded/$GB), ($sourceRemoved/$GB), ($totalToMove/$GB), `
        $rateGBPerMin, ($elapsed.ToString("hh\:mm\:ss"))

    Write-Line $line "White"

    # Flag if dest growth and source shrinkage disagree by more than the variance
    # (can indicate copy errors, skipped files, or ACL/overhead differences)
    $mismatch = [math]::Abs($deltaAdded - $sourceRemoved)
    if ($mismatch -gt ($varianceBytes * 5)) {
        Write-Line ("  NOTE: dest growth and source shrinkage differ by {0:N2} GB — check robocopy log for errors/skips." -f ($mismatch/$GB)) "Yellow"
    }

    if ($growthSinceLastCheck -gt $varianceBytes) {
        $lastChangeTime = $now
    }
    $lastDeltaAdded = $deltaAdded

    if ($percent -ge (100 - $CompletionTolerancePct)) {
        Write-Line "" "Green"
        Write-Line ("{0}: Reached {1:N4}% (within tolerance of 100%). Treating as COMPLETE." -f $now, $percent) "Green"
        break
    }

    $stalledMinutes = ($now - $lastChangeTime).TotalMinutes
    if ($stalledMinutes -ge $StallMinutes) {
        Write-Line "" "Yellow"
        Write-Line ("{0}: No growth beyond {1} GB for {2}+ minutes. Currently at {3:N4}% — treating as FINISHED/STALLED, not necessarily 100%. Check the robocopy log/window for errors, locked files, or a paused job." -f `
            $now, $VarianceGB, $StallMinutes, $percent) "Yellow"
        break
    }
}

Write-Line "" "Green"
Write-Line ("Heartbeat monitor exited at {0}. Full log: {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $LogPath) "Green"