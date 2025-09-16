# Revision : 1.3
# Description : Keep retrying every 1 minute until Twinmotion 2022.2.3 Revit Installer.zip is successfully moved, with logging
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-16
# Modified Date : 2025-09-16

$sourceFile = "c:\folder\file.zip"
$destinationFolder = "\\server\folder"

# Prepare log folder and file
$logFolder = "C:\temp\powershell-exports"
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}
$logFile = Join-Path $logFolder ("movefile-{0:yyyyMMdd-HHmmss}.log" -f (Get-Date))

# Ensure destination exists
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory -Force | Out-Null
}

$success = $false
while (-not $success) {
    try {
        Move-Item -Path $sourceFile -Destination $destinationFolder -Force -ErrorAction Stop
        $msg = "SUCCESS : File moved to $destinationFolder : $(Get-Date)"
        Write-Host $msg
        Add-Content -Path $logFile -Value $msg
        $success = $true
    }
    catch {
        $err = "FAILED : $($_.Exception.Message) : $(Get-Date)"
        Write-Host $err
        Add-Content -Path $logFile -Value $err
        Write-Host "Retrying in 60 seconds..."
        Start-Sleep -Seconds 60
    }
}
