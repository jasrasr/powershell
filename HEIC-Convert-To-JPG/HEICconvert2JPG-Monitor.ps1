# Filename: HEICconvert2JPG-Monitor.ps1
# Revision : 1.3.0
# Description : Monitors a folder for new HEIC/HEIF files and automatically converts them to JPG
#               using bundled portable ImageMagick. Originals are archived to an 'Original HEIC'
#               subfolder per source directory.
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2026-04-21
# Modified Date : 2026-05-29
# Changelog :
# 1.3.0 added pre-scan of existing HEIC/HEIF files in WatchFolder at startup so the script
#         processes the current backlog before entering the watch loop
# 1.2.0 added Renamed event + larger buffer to support OneDrive synced folders (files arrive
#         via rename, not Created event); increased InternalBufferSize to 65536
# 1.1.0 fixed event detection — switched from Register-ObjectEvent -Action (child runspace,
#         no access to parent scope) to Get-Event polling in main loop
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
$watcher                       = New-Object System.IO.FileSystemWatcher
$watcher.Path                  = $WatchFolder
$watcher.Filter                = '*.*'
$watcher.IncludeSubdirectories = $Recurse.IsPresent
$watcher.NotifyFilter          = [System.IO.NotifyFilters]::FileName
$watcher.InternalBufferSize    = 65536

# Queue to avoid duplicate events
$processedFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

# Watch both Created and Renamed — OneDrive delivers files via rename, not Created
Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier 'HEIC_Created' | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier 'HEIC_Renamed' | Out-Null

$watcher.EnableRaisingEvents = $true

Write-Host ""
Write-Host "Monitoring : $WatchFolder" -ForegroundColor Cyan
Write-Host "Recurse    : $($Recurse.IsPresent)" -ForegroundColor Cyan
Write-Host "Output     : $(if ($OutputFolder) { $OutputFolder } else { '(same as source)' })" -ForegroundColor Cyan
Write-Host "Log        : $logPath" -ForegroundColor Cyan
Write-Host "ImageMagick: $magickExe" -ForegroundColor Cyan
Write-Host ""
# -----------------------------
# Pre-scan existing files
# -----------------------------
$existing = Get-ChildItem -Path $WatchFolder -Recurse:$Recurse.IsPresent -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -imatch '\.heic$|\.heif$' -and $_.DirectoryName -notmatch '\\Original HEIC$' }

if ($existing) {
    Write-Host "Pre-scan : found $($existing.Count) existing HEIC/HEIF file(s) — processing before watch starts." -ForegroundColor Cyan
    Write-Host ""
    foreach ($f in $existing) {
        Write-Host "Existing   : $($f.Name)" -ForegroundColor White
        Convert-HeicFile -FilePath $f.FullName
    }
    Write-Host ""
}

Write-Host "Waiting for HEIC/HEIF files... Press Ctrl+C to stop." -ForegroundColor Gray
Write-Host ""

try {
    while ($true) {
        $events = @()
        $events += Get-Event -SourceIdentifier 'HEIC_Created' -ErrorAction SilentlyContinue
        $events += Get-Event -SourceIdentifier 'HEIC_Renamed' -ErrorAction SilentlyContinue

        foreach ($evt in $events) {
            Remove-Event -EventIdentifier $evt.EventIdentifier
            $path = $evt.SourceEventArgs.FullPath
            if ($path -notmatch '(?i)\.heic$|\.heif$') { continue }
            if (-not $processedFiles.Add($path)) { continue }

            Write-Host "Detected   : $(Split-Path $path -Leaf)" -ForegroundColor White

            # Brief delay to allow file write to complete
            Start-Sleep -Milliseconds 500

            Convert-HeicFile -FilePath $path
            $processedFiles.Remove($path) | Out-Null
        }
        Start-Sleep -Milliseconds 500
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    Unregister-Event -SourceIdentifier 'HEIC_Created' -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier 'HEIC_Renamed' -ErrorAction SilentlyContinue
    $watcher.Dispose()
    Write-Host ""
    Write-Host "Monitor stopped. Log saved to: $logPath" -ForegroundColor Cyan
}

# Example Usage:
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos"
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -Recurse
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -OutputFolder "C:\Converted"
#   .\HEICconvert2JPG-Monitor.ps1 -WatchFolder "C:\Photos" -OutputFolder "C:\Converted" -Recurse
