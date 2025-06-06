# Revision # 3
# Description : Internal speed test by copying a random-sized file from C:\Temp to \\<computer>\C$\Temp and reporting speed
# Author      : Jason Lamb (help from ChatGPT 4o)
# Date        : 2025-06-03

$computerName = Read-Host "Enter the destination computer name"
$destinationPath = "\\$computerName\c$\Temp"
$sourcePath = "C:\Temp"

# Ensure C:\Temp exists on source
if (-not (Test-Path $sourcePath)) {
    New-Item -Path $sourcePath -ItemType Directory | Out-Null
}

# Ensure destination path exists
if (-not (Test-Path $destinationPath)) {
    try {
        New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
        Write-Host "Created destination folder : $destinationPath"
    } catch {
        Write-Host "Failed to access or create destination folder : $_"
        return
    }
}

# Random file size between 1GB and 4GB
$minMB = 1024
$maxMB = 1025
$fileSizeMB = Get-Random -Minimum $minMB -Maximum $maxMB
$fileSizeBytes = $fileSizeMB * 1MB

# Check free space on C:\
$freeBytes = (Get-PSDrive -Name C).Free
if ($fileSizeBytes -gt $freeBytes) {
    Write-Host "Not enough free space on C:\ to create $fileSizeMB MB file. Free space : $([math]::Round($freeBytes / 1MB)) MB"
    return
}

$filename = "speedtest_temp_$fileSizeMB.dat"
$sourceFile = Join-Path $sourcePath $filename
$destFile = Join-Path $destinationPath $filename

# Create random file at source
Write-Host "Creating $fileSizeMB MB file at $sourceFile..."
$fs = [System.IO.File]::Create($sourceFile)
$fs.SetLength($fileSizeBytes)
$fs.Close()

# Start transfer with progress
$bufferSize = 4MB
$buffer = New-Object byte[] $bufferSize
$readTotal = 0

$srcStream = [System.IO.File]::OpenRead($sourceFile)
$dstStream = [System.IO.File]::Create($destFile)

$sw = [System.Diagnostics.Stopwatch]::StartNew()

while (($read = $srcStream.Read($buffer, 0, $bufferSize)) -gt 0) {
    $dstStream.Write($buffer, 0, $read)
    $readTotal += $read
    $progress = [math]::Round(($readTotal / $fileSizeBytes) * 100)
    Write-Progress -Activity "Copying to $destFile" -PercentComplete $progress -Status "$progress% complete"
}

Write-Progress -Activity "Copying $filename" -Completed

$sw.Stop()
$srcStream.Close()
$dstStream.Close()

# Compute stats
$elapsed = $sw.Elapsed.TotalSeconds
$speed = [math]::Round(($fileSizeBytes / 1MB) / $elapsed, 2)

# Cleanup with confirmation
$srcDeleted = $false
$dstDeleted = $false

try {
    Remove-Item $sourceFile -Force -ErrorAction Stop
    $srcDeleted = $true
} catch {
    Write-Host "Failed to delete source file : $_"
}

try {
    Remove-Item $destFile -Force -ErrorAction Stop
    $dstDeleted = $true
} catch {
    Write-Host "Failed to delete destination file : $_"
}

# Final report
# Prepare log message
$log = @()
$log += ""
$log += "🚀 Transfer Test Result"
$log += "------------------------"
$log += "Destination Computer : $($computerName.ToUpper())"
$log += "File Size            : $fileSizeMB MB"
$log += "Elapsed Time         : $($elapsed.ToString('0.00')) seconds"
$log += "Transfer Speed       : $speed MB/s"
$log += ""
$log += if ($srcDeleted -and $dstDeleted) {
    "✅ Temp files cleaned from both locations."
} else {
    "⚠ Temp file cleanup failed for one or both locations."
}

# Output to screen
$log | ForEach-Object { Write-Host $_ }

# Ensure export folder exists
$logPath = 'C:\Temp\powershell-exports\speedtest-log.txt'
$logFolder = Split-Path $logPath
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Append to log file
$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$log | Add-Content -Path $logPath
Add-Content -Path $logPath -Value "Timestamp            : $timestamp"
Add-Content -Path $logPath -Value ("=" * 40)


