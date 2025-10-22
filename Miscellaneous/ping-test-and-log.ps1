# Revision : 1.2
# Description : Periodic internet speed test with live countdown timer, real-time log writing after every test. Rev 1.2
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-21
# Modified Date : 2025-10-21

param(
    [int]$RunForMinutes = 60,
    [int]$IntervalMinutes = 5,
    [string]$LogPath = "C:\temp\powershell-exports\speedtest-network.log",
    [switch]$AutoInstall
)

# --- Setup folders ---
$logFolder = Split-Path -Path $LogPath -Parent
if (-not (Test-Path $logFolder)) { New-Item -Path $logFolder -ItemType Directory -Force | Out-Null }

# --- Write banner to log ---
$startBanner = "===== Speedtest Session Started : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="
Add-Content -Path $LogPath -Value $startBanner
Write-Host $startBanner

# --- Locate or install Ookla CLI ---
function Get-OklaSpeedtestPath {
    $cmd = Get-Command speedtest -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    if ($AutoInstall) {
        Write-Host "speedtest.exe not found, attempting winget install : Ookla.Speedtest.CLI"
        try {
            winget install --id Ookla.Speedtest.CLI -e --accept-package-agreements --accept-source-agreements | Out-Null
            Start-Sleep -Seconds 3
            $cmd = Get-Command speedtest -ErrorAction SilentlyContinue
            if ($cmd) { return $cmd.Source }
        } catch {
            Write-Host "Auto-install failed : $_"
            Add-Content -Path $LogPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Auto-install failed : $_"
        }
    }
    return $null
}

$speedtestPath = Get-OklaSpeedtestPath
if (-not $speedtestPath) {
    $msg = "ERROR : speedtest.exe not found. Install from https://www.speedtest.net/apps/cli or run with -AutoInstall."
    Write-Host $msg
    Add-Content -Path $LogPath -Value $msg
    return
}

# --- Core test ---
function Invoke-NetworkSpeedTest {
    try {
        $raw = & $speedtestPath --accept-license --accept-gdpr -f json 2>$null
        if ([string]::IsNullOrWhiteSpace($raw)) { throw "speedtest returned no output." }

        $j = $raw | ConvertFrom-Json
        $dlMbps = [math]::Round(($j.download.bandwidth * 8) / 1MB, 2)
        $ulMbps = [math]::Round(($j.upload.bandwidth * 8) / 1MB, 2)
        $lat    = $j.ping.latency
        $loss   = $j.packetLoss
        $isp    = $j.isp
        $srvN   = $j.server.name
        $srvL   = $j.server.location
        $url    = $j.result.url
        $ts     = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

        $entry = "[${ts}]  DL : ${dlMbps} Mbps  UL : ${ulMbps} Mbps  Ping : ${lat} ms  ISP : ${isp}  Server : ${srvN} (${srvL})  URL : ${url}"
        Write-Host $entry
        Add-Content -Path $LogPath -Value $entry
    }
    catch {
        $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $err = "[${ts}]  ERROR running speed test : $_"
        Write-Host $err
        Add-Content -Path $LogPath -Value $err
    }
}

# --- Countdown timer ---
function Start-CountdownTimer {
    param([datetime]$EndTime)
    while ((Get-Date) -lt $EndTime) {
        $remaining = $EndTime - (Get-Date)
        $out = "Next run in : {0:hh\:mm\:ss}" -f $remaining
        Write-Host -NoNewline "`r$out"
        Start-Sleep -Seconds 1
    }
    Write-Host ""
}

# --- Scheduler loop ---
$endTime = (Get-Date).AddMinutes($RunForMinutes)
do {
    $start = Get-Date
    Invoke-NetworkSpeedTest

    $nextPlanned = $start.AddMinutes($IntervalMinutes)
    if ($nextPlanned -gt $endTime) { break }

    Start-CountdownTimer -EndTime $nextPlanned
} while ((Get-Date) -lt $endTime)

$endBanner = "===== Speedtest Session Complete : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="
Write-Host "`n$endBanner"
Add-Content -Path $LogPath -Value $endBanner

<# =========================
CHANGELOG / WHAT CHANGED (Rev 1.2)
- Output switched from CSV → .LOG format.
- Each test writes results immediately to log.
- Added session banners at start and end.
- Retains live countdown timer between tests.
- Keeps all prior functionality intact.
========================= #>

<# =========================
USAGE EXAMPLES

. .\Run-SpeedTest-Logger.ps1
Run-SpeedTest-Logger -RunForMinutes 30 -IntervalMinutes 2 -AutoInstall
#>