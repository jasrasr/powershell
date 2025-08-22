# Revision : 1.6
# Description : Remove upgrade block by clearing TargetReleaseVersion settings and DisableOSUpgrade. 
# Adds ping check, unreachable hosts in red, successful completions in green, before/after reports in yellow. 
# Logs all actions to C:\temp\powershell-exports\ with timestamp. Rev 1.6
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-13
# Modified Date : 2025-08-22

param(
    [string[]]$ComputerName = @($env:COMPUTERNAME)
)

$WUPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$WSPath = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
$LogFolder = "C:\temp\powershell-exports"
if (-not (Test-Path $LogFolder)) { New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null }
$TimeStamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$LogFile = Join-Path $LogFolder "Remove-UpgradeBlock-$TimeStamp.log"

# helper for writing both to console and log
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $LogFile -Value ("[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)
}

# --- scriptblock to run locally/remotely ---
$sb = {
    param($WUPath,$WSPath,$LogFile)

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
            [string]$Color = "White",
            [string]$LogFile
        )
        Write-Host $Message -ForegroundColor $Color
        Add-Content -Path $LogFile -Value ("[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)
    }

    Write-Log "=== Clearing Windows Update upgrade restrictions on $env:COMPUTERNAME ===" "Cyan" $LogFile

    # Ensure policy keys exist
    Ensure-Key -Path $WUPath
    Ensure-Key -Path $WSPath

    Write-Log "Before state on $env:COMPUTERNAME :" "Yellow" $LogFile
    $before = Get-Report -WUPath $WUPath -WSPath $WSPath | Format-Table -AutoSize | Out-String
    Write-Host $before -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $before

    # Set TargetReleaseVersion to 0 (DWORD)
    New-ItemProperty -Path $WUPath -Name 'TargetReleaseVersion' -Value 0 -PropertyType DWord -Force | Out-Null
    Write-Log "Set TargetReleaseVersion to 0" "White" $LogFile

    # Remove TargetReleaseVersionInfo completely
    Remove-ItemProperty -Path $WUPath -Name 'TargetReleaseVersionInfo' -ErrorAction SilentlyContinue
    Write-Log "Removed TargetReleaseVersionInfo (if present)" "White" $LogFile

    # Set DisableOSUpgrade to 0 (DWORD) in both locations
    foreach ($path in @($WUPath,$WSPath)) {
        New-ItemProperty -Path $path -Name 'DisableOSUpgrade' -Value 0 -PropertyType DWord -Force | Out-Null
        Write-Log "Set DisableOSUpgrade to 0 at $path" "White" $LogFile
    }

    Write-Log "After state on $env:COMPUTERNAME :" "Yellow" $LogFile
    $after = Get-Report -WUPath $WUPath -WSPath $WSPath | Format-Table -AutoSize | Out-String
    Write-Host $after -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $after

    Write-Log "Upgrade block settings cleared on $env:COMPUTERNAME ." "Green" $LogFile
}

# --- iterate computers ---
foreach ($cn in $ComputerName) {
    Write-Log "Pinging $cn ..." "White"

    if (-not (Test-Connection -ComputerName $cn -Count 1 -Quiet)) {
        Write-Log "Computer $cn is not reachable. Skipping." "Red"
        continue
    }

    try {
        if ($cn -ieq $env:COMPUTERNAME -or $cn -in @('localhost','127.0.0.1','.')) {
            & $sb $WUPath $WSPath $LogFile
        } else {
            Invoke-Command -ComputerName $cn -ScriptBlock $sb -ArgumentList $WUPath,$WSPath,$LogFile -ErrorAction Stop
        }
    } catch {
        Write-Log "Error on $cn : $_" "Red"
    }
}

Write-Host "Log file saved to : $LogFile" -ForegroundColor Cyan
