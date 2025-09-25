# Revision : 1.4
# Description : Monitor provided folders for total file count, folder count, and size every 60 seconds; stop when 5 sequential snapshots are identical. Includes -Depth, per-iteration runtime, and a visible countdown to the next run. Rev 1.4
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-25
# Modified Date : 2025-09-25

param(
    [Parameter(Mandatory = $true)]
    [string[]] $TargetPaths,

    [int] $IntervalSeconds = 60,

    [int] $SameThreshold = 5,

    [switch] $ShowPerPath,

    [int] $Depth = -1   # -1 means full recursion (no depth limit)
)

function Convert-Size {
    param([long] $Bytes)
    if ($Bytes -lt 1KB) { '{0:N0} B' -f [long]$Bytes; return }
    $units = 'KB','MB','GB','TB','PB'
    $size = [double]$Bytes
    foreach ($u in $units) {
        $size = $size / 1KB
        if ($size -lt 1024) { return ('{0:N2} ' + $u) -f $size }
    }
    return ('{0:N2} EB' -f ($size / 1024))
}

function Get-PathStats {
    param([string] $Path, [int] $Depth)

    $fileCount   = 0
    $folderCount = 0
    $totalBytes  = 0L
    $ok          = $true
    $err         = $null

    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            throw "Path not found"
        }

        $dirParams = @{ LiteralPath = $Path; Force = $true; ErrorAction = 'Stop' }
        if ($Depth -ge 0) { $dirParams['Depth'] = $Depth } else { $dirParams['Recurse'] = $true }

        # Folders
        $folderCount = (Get-ChildItem @dirParams -Directory | Measure-Object).Count

        # Files + size
        $files = Get-ChildItem @dirParams -File
        $m     = $files | Measure-Object -Property Length -Sum
        $fileCount  = [int]$m.Count
        $totalBytes = [long]($m.Sum)
    }
    catch {
        $ok  = $false
        $err = $_.Exception.Message
        Write-Host "Error scanning ${Path} : $err" -ForegroundColor Red
    }

    [PSCustomObject]@{
        Path        = $Path
        OK          = $ok
        Error       = $err
        FileCount   = $fileCount
        FolderCount = $folderCount
        TotalBytes  = $totalBytes
        HumanSize   = Convert-Size -Bytes $totalBytes
    }
}

function Get-CombinedStats {
    param([string[]] $Paths, [int] $Depth)

    $start = Get-Date
    $perPath = foreach ($p in $Paths) { Get-PathStats -Path $p -Depth $Depth }
    $stop  = Get-Date
    $elapsed = New-TimeSpan -Start $start -End $stop

    $totalFiles   = ($perPath | Measure-Object -Property FileCount   -Sum).Sum
    $totalFolders = ($perPath | Measure-Object -Property FolderCount -Sum).Sum
    $totalBytes   = ($perPath | Measure-Object -Property TotalBytes  -Sum).Sum

    [PSCustomObject]@{
        Timestamp    = Get-Date
        PerPath      = $perPath
        TotalFiles   = [int64]$totalFiles
        TotalFolders = [int64]$totalFolders
        TotalBytes   = [int64]$totalBytes
        HumanSize    = Convert-Size -Bytes $totalBytes
        Signature    = "{0}|{1}|{2}" -f $totalFiles, $totalFolders, $totalBytes
        DurationSec  = [math]::Round($elapsed.TotalSeconds,2)
    }
}

# Show what we are watching
Write-Host "Monitoring combined paths :" -ForegroundColor Cyan
$TargetPaths | ForEach-Object { Write-Host "  $_" -ForegroundColor Cyan }
Write-Host "Interval seconds : $IntervalSeconds" -ForegroundColor Yellow
Write-Host "Sequential identical threshold : $SameThreshold" -ForegroundColor Yellow
if ($Depth -ge 0) {
    Write-Host "Depth limit : $Depth" -ForegroundColor Yellow
} else {
    Write-Host "Depth : Full recursion" -ForegroundColor Yellow
}
Write-Host ""

$streak        = 0
$lastSignature = $null

while ($true) {
    $stats = Get-CombinedStats -Paths $TargetPaths -Depth $Depth

    # Optional per-path breakdown
    if ($ShowPerPath) {
        foreach ($pp in $stats.PerPath) {
            if ($pp.OK) {
                Write-Host ("{0:HH:mm:ss} | {1} | Files {2} | Folders {3} | Size {4}" -f $stats.Timestamp, $pp.Path, $pp.FileCount, $pp.FolderCount, $pp.HumanSize) -ForegroundColor DarkGray
            } else {
                Write-Host ("{0:HH:mm:ss} | {1} | Error {2}" -f $stats.Timestamp, $pp.Path, $pp.Error) -ForegroundColor Red
            }
        }
    }

    # Combined line with runtime
    Write-Host ("{0:yyyy-MM-dd HH:mm:ss} | COMBINED | Files {1} | Folders {2} | Size {3} | Duration {4}s" -f $stats.Timestamp, $stats.TotalFiles, $stats.TotalFolders, $stats.HumanSize, $stats.DurationSec) -ForegroundColor Green

    # Streak logic on combined signature
    if ($lastSignature -and $stats.Signature -eq $lastSignature) {
        $streak++
        Write-Host "No change detected : ${streak}/${SameThreshold} identical snapshots" -ForegroundColor DarkYellow
    } else {
        $streak = 1
        Write-Host "Change detected or first sample : resetting streak to ${streak}/${SameThreshold}" -ForegroundColor Yellow
    }

    if ($streak -ge $SameThreshold) {
        Write-Host "Reached ${SameThreshold} sequential identical snapshots : stopping monitor" -ForegroundColor Cyan
        break
    }

    $lastSignature = $stats.Signature

    # ---- Countdown to next run ----
    if ($IntervalSeconds -gt 0) {
        for ($i = $IntervalSeconds; $i -gt 0; $i--) {
            $percent = [math]::Round((($IntervalSeconds - $i) / $IntervalSeconds) * 100, 0)
            $status  = "$i seconds remaining..."
            Write-Progress -Activity "Waiting for next run" -Status $status -PercentComplete $percent
            Start-Sleep -Seconds 1
        }
        Write-Progress -Activity "Waiting for next run" -Completed
    } else {
        Start-Sleep -Milliseconds 1
    }
}

# Final summary
$final = Get-CombinedStats -Paths $TargetPaths -Depth $Depth
Write-Host ""
Write-Host "Final combined counts :" -ForegroundColor Magenta
Write-Host ("Files {0} | Folders {1} | Size {2} | Duration {3}s" -f $final.TotalFiles, $final.TotalFolders, $final.HumanSize, $final.DurationSec) -ForegroundColor Magenta

<# -----------------------------
USAGE
------------------------------
# Monitor two paths with full recursion (default), show countdown:
.\Folder-Monitor.ps1 -TargetPaths '\\middough.local\corp\data\dept\Chicago\740','\\middough.local\corp\data\dept\Cleveland\740'

# Limit recursion depth to 1 (only top-level files/folders):
.\Folder-Monitor.ps1 -TargetPaths 'C:\Temp\1','C:\Temp\2' -Depth 1

# Show per-path details and timing:
.\Folder-Monitor.ps1 -TargetPaths 'C:\Temp\A','C:\Temp\B' -ShowPerPath
#>
