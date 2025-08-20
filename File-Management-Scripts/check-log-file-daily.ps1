# Path to the log
$logFile = "\\server\c$\temp\logfile.log"

# Expected: modified today
$lastWrite = (Get-Item $logFile).LastWriteTime
$today     = (Get-Date).Date

if ($lastWrite.Date -eq $today) {
    Write-Host "OK : $logFile was modified today at $lastWrite" -ForegroundColor Green
} else {
    Write-Host "ALERT : $logFile has not been modified today! Last change: $lastWrite" -ForegroundColor Red
}

$logPath = "C:\temp\powershell-exports\check-adkit-log-$(Get-Date -Format 'yyyyMMdd').log"
Add-Content -Path $logPath -Value "$(Get-Date) : $logFile - File last modified $lastWrite"
