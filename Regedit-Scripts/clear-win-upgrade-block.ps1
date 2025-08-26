# Revision : 1.7
# Description : Remove upgrade block by clearing TargetReleaseVersion and DisableOSUpgrade. Adds ping check, unreachable hosts in red, successes in green, before/after reports in yellow. Creates per-target log folder if missing to prevent path errors. Rev 1.7
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-13
# Modified Date : 2025-08-26

param(
    [string[]]$ComputerName = @($env:COMPUTERNAME)
)

# --- constants (policy keys & default log root) ---
$WUPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$WSPath    = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
$LogFolder = "C:\temp\powershell-exports"
$TimeStamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# Ensure local log root exists (for local status + localhost run)
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

# Helper to write locally (loop status)
function Write-Local {
    param(
        [string]$Message,
        [ConsoleColor]$Color = 'White'
    )
    Write-Host $Message -ForegroundColor $Color
}

# --- scriptblock to run locally/remotely; logs on the TARGET machine ---
$sb = {
    param(
        [string]$WUPath,
        [string]$WSPath,
        [string]$LogFolder,
        [string]$TimeStamp
    )

    # Build per-target log file path and ensure folder
    if (-not (Test-Path -Path $LogFolder)) {
        New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
    }
    $LogFile = Join-Path $LogFolder ("Remove-UpgradeBlock-{0}.log" -f $TimeStamp)

    function Ensure-Key {
        param([string]$Path)
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    }

    function Get-Report {
        param([string]$WUPath,[string]$WSPath)
        $wu = Get-ItemProperty -Path $WUPath -ErrorAction SilentlyContinue
        $ws = Get-ItemProperty -Path $WSPath -ErrorAction SilentlyContinue
        [pscustomobject]@{
            Computer                 = $env:COMPUTERNAME
            TargetReleaseVersion     = $wu.TargetReleaseVersion
            TargetReleaseVersionInfo = $wu.TargetReleaseVersionInfo
            DisableOSUpgrade_WU      = $wu.DisableOSUpgrade
            DisableOSUpgrade_WS      = $ws.DisableOSUpgrade
        }
    }

    function Write-Log {
        param(
            [string]$Message,
            [string]$Color = "White"
        )
        Write-Host $Message -ForegroundColor $Color
        Add-Content -Path $LogFile -Value ("[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)
    }

    Write-Log "=== Clearing Windows Update upgrade restrictions on $env:COMPUTERNAME ===" "Cyan"

    # Ensure policy keys exist
    Ensure-Key -Path $WUPath
    Ensure-Key -Path $WSPath

    Write-Log "Before state on $env:COMPUTERNAME :" "Yellow"
    $before = Get-Report -WUPath $WUPath -WSPath $WSPath | Format-Table -AutoSize | Out-String
    Write-Host $before -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $before

    # Set TargetReleaseVersion to 0 (DWORD)
    New-ItemProperty -Path $WUPath -Name 'TargetReleaseVersion' -Value 0 -PropertyType DWord -Force | Out-Null
    Write-Log "Set TargetReleaseVersion to 0" "White"

    # Remove TargetReleaseVersionInfo completely
    Remove-ItemProperty -Path $WUPath -Name 'TargetReleaseVersionInfo' -ErrorAction SilentlyContinue
    Write-Log "Removed TargetReleaseVersionInfo (if present)" "White"

    # Set DisableOSUpgrade to 0 (DWORD) in both locations
    foreach ($path in @($WUPath,$WSPath)) {
        New-ItemProperty -Path $path -Name 'DisableOSUpgrade' -Value 0 -PropertyType DWord -Force | Out-Null
        Write-Log "Set DisableOSUpgrade to 0 at $path" "White"
    }

    Write-Log "After state on $env:COMPUTERNAME :" "Yellow"
    $after = Get-Report -WUPath $WUPath -WSPath $WSPath | Format-Table -AutoSize | Out-String
    Write-Host $after -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $after

    Write-Log "Upgrade block settings cleared on $env:COMPUTERNAME ." "Green"
    Write-Host "Log file saved to on $env:COMPUTERNAME : $LogFile" -ForegroundColor Cyan
}

# --- iterate computers ---
foreach ($cn in $ComputerName) {
    Write-Local "Pinging $cn ..." "White"

    if (-not (Test-Connection -ComputerName $cn -Count 1 -Quiet)) {
        Write-Local "Computer $cn is not reachable. Skipping." "Red"
        continue
    }

    try {
        if ($cn -ieq $env:COMPUTERNAME -or $cn -in @('localhost','127.0.0.1','.')) {
            & $sb $WUPath $WSPath $LogFolder $TimeStamp
        } else {
            Invoke-Command -ComputerName $cn -ScriptBlock $sb -ArgumentList $WUPath,$WSPath,$LogFolder,$TimeStamp -ErrorAction Stop
        }
    } catch {
        Write-Local "Error on $cn : $_" "Red"
    }
}

Write-Host "Completed. Per-target logs are in $LogFolder : Remove-UpgradeBlock-$TimeStamp.log" -ForegroundColor Cyan
