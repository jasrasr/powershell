# Filename: HEICconvert2JPG-Monitor.ps1
# Revision : 1.0.2
# Description : Monitors a folder for new HEIC/HEIF files and automatically converts them to JPG
#               using bundled portable ImageMagick. Originals are archived to an 'Original HEIC'
#               subfolder per source directory.
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-21
# Modified Date : 2026-04-21
# Changelog :
# 1.0.2 fixed case-insensitive extension matching for .HEIC/.HEIF
# 1.0.1 added detected/converting screen output messages
# 1.0.0 initial release

param (
    [Parameter(Mandatory = $true)]
    [string]$WatchFolder,

    [string]$OutputFolder = '',

    [switch]$Recurse
)

# -----------------------------
# ImageMagick Detection
# -----------------------------
$scriptRoot = Split-Path -Parent $PSCommandPath
$magickCandidates = @(
    (Join-Path $scriptRoot 'ImageMagick\magick-heic.exe'),
    (Join-Path $scriptRoot 'ImageMagick\magick.exe'),
    'magick'
)
$magickExe = $magickCandidates | Where-Object { $_ -eq 'magick' -or (Test-Path $_) } | Select-Object -First 1

if (-not $magickExe) {
    Write-Host "ImageMagick not found. Expected '.\ImageMagick\magick.exe' or 'magick' in PATH." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $WatchFolder)) {
    Write-Host "Watch folder not found: $WatchFolder" -ForegroundColor Red
    exit 1
}

$logRoot = 'C:\temp\powershell-exports'
if (-not (Test-Path $logRoot)) {
    New-Item -ItemType Directory -Path $logRoot | Out-Null
}

$datetime  = Get-Date -Format 'yyyyMMdd-HHmmss'
$logPath   = Join-Path $logRoot "heic-monitor-$datetime.csv"
"OriginalFile,ConvertedFile,Status,HEIC_KB,JPG_KB,Dimensions,Timestamp" | Out-File $logPath -Encoding utf8

# -----------------------------
# Conversion Function
# -----------------------------
function Convert-HeicFile {
    param ([string]$FilePath)

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $heicSize  = ''

    try {
        $file = Get-Item -LiteralPath $FilePath -ErrorAction Stop
        if ($file.Extension.ToLower() -notin '.heic', '.heif') { return }

        $destFolder = if ($OutputFolder) { $OutputFolder } else { Split-Path $file.FullName -Parent }
        $jpgPath    = Join-Path $destFolder ($file.BaseName + '.jpg')
        $heicSize   = [math]::Round($file.Length / 1KB, 2)
        Write-Host "Converting : $($file.Name)  ($heicSize KB)" -ForegroundColor DarkCyan

        $archiveFolder = Join-Path (Split-Path $file.FullName -Parent) 'Original HEIC'
        if (-not (Test-Path $archiveFolder)) {
            New-Item -ItemType Directory -Path $archiveFolder | Out-Null
        }

        if (Test-Path $jpgPath) {
            $jpgSize = [math]::Round((Get-Item $jpgPath).Length / 1KB, 2)
            "$($file.Name),$($file.BaseName).jpg,Skipped,$heicSize,$jpgSize,N/A,$timestamp" | Out-File $logPath -Append
            Write-Host "Skipped (already exists) : $($file.Name)" -ForegroundColor Yellow
            return
        }

        & $magickExe $file.FullName $jpgPath
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $jpgPath)) {
            throw "ImageMagick failed to convert '$($file.FullName)'."
        }

        $jpg        = Get-Item $jpgPath
        $jpgSize    = [math]::Round($jpg.Length / 1KB, 2)
        $dimensions = & $magickExe identify -format '%wx%h' $jpgPath
        if ($LASTEXITCODE -ne 0) { $dimensions = 'N/A' }

        Move-Item $file.FullName (Join-Path $archiveFolder $file.Name) -Force

        "$($file.Name),$($jpg.Name),Success,$heicSize,$jpgSize,$dimensions,$timestamp" | Out-File $logPath -Append
        Write-Host "Converted : $($file.Name)  →  $($jpg.Name)  ($dimensions)" -ForegroundColor Green
    }
    catch {
        $failedName = if ($file) { $file.Name } else { [System.IO.Path]::GetFileName($FilePath) }
        "$failedName,,Failed,$heicSize,,,$timestamp" | Out-File $logPath -Append
        Write-Host "Failed : $failedName — $($_.Exception.Message)" -ForegroundColor Red
    }
}

# -----------------------------
# FileSystemWatcher Setup
# -----------------------------
$watcher                     = New-Object System.IO.FileSystemWatcher
$watcher.Path                = $WatchFolder
$watcher.Filter              = '*.*'
$watcher.IncludeSubdirectories = $Recurse.IsPresent
$watcher.NotifyFilter        = [System.IO.NotifyFilters]::FileName

# Queue to avoid duplicate events
$processedFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

$action = {
    $path = $Event.SourceEventArgs.FullPath
    if ($path -notmatch '(?i)\.heic$|\.heif$') { return }
    if (-not $processedFiles.Add($path)) { return }

    Write-Host "Detected   : $(Split-Path $path -Leaf)" -ForegroundColor White

    # Brief delay to allow file write to complete
    Start-Sleep -Milliseconds 500

    Convert-HeicFile -FilePath $path
    $processedFiles.Remove($path) | Out-Null
}

$watcher.EnableRaisingEvents = $false
Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier 'HEIC_Created' -Action $action | Out-Null

$watcher.EnableRaisingEvents = $true

Write-Host ""
Write-Host "Monitoring : $WatchFolder" -ForegroundColor Cyan
Write-Host "Recurse    : $($Recurse.IsPresent)" -ForegroundColor Cyan
Write-Host "Output     : $(if ($OutputFolder) { $OutputFolder } else { '(same as source)' })" -ForegroundColor Cyan
Write-Host "Log        : $logPath" -ForegroundColor Cyan
Write-Host "ImageMagick: $magickExe" -ForegroundColor Cyan
Write-Host ""
Write-Host "Waiting for HEIC/HEIF files... Press Ctrl+C to stop." -ForegroundColor Gray
Write-Host ""

try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    Unregister-Event -SourceIdentifier 'HEIC_Created' -ErrorAction SilentlyContinue
    $watcher.Dispose()
    Write-Host ""
    Write-Host "Monitor stopped. Log saved to: $logPath" -ForegroundColor Cyan
}

# Example Usage:
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos"
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -Recurse
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -OutputFolder "C:\Converted"
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -OutputFolder "C:\Converted" -Recurse
