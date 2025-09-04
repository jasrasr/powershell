# Revision : 1.6
# Description : Restart only EgnyteClient/EgnyteDrive with rolling log; do NOT stop WebEdit/SyncService/Update  (Rev 1.6)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-03
# Modified Date : 2025-09-03

# Targets (stop ONLY these if present)
$targetProcesses = @("EgnyteClient","EgnyteDrive")

# Start path for the desktop app (updated to EgnyteClient.exe)
$appPath = "C:\Program Files (x86)\Egnyte Connect\EgnyteClient.exe"

# Log setup
$logFolder = "C:\temp\powershell-exports"
if (-not (Test-Path $logFolder)) { New-Item -ItemType Directory -Path $logFolder -Force | Out-Null }
$logFile = Join-Path $logFolder "egnyte-restart.log"

# Separator
Add-Content -Path $logFile -Value "`n----- Restart Attempt $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -----"

# Stop ONLY the specified targets
foreach ($name in $targetProcesses) {
    try {
        $procs = Get-Process -Name $name -ErrorAction SilentlyContinue
        if ($procs) {
            $procs | Stop-Process -Force
            Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : Stopped $name"
        } else {
            Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : $name not running"
        }
    } catch {
        Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : Error stopping $name - $_"
    }
}

# Wait 5 seconds
Start-Sleep -Seconds 5

# Start Egnyte Client from full path
try {
    $p = Start-Process -FilePath $appPath -PassThru
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : Started $appPath (PID $($p.Id))"
} catch {
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') : Error starting $appPath - $_"
}

Write-Host "Egnyte Client restart complete. Log file : $logFile"
