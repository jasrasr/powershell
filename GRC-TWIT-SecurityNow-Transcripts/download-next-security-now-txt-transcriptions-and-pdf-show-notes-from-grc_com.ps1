# Filename: download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1
# Revision: 2.4
# Description: Downloads GRC Security Now TXT transcripts, PDF show notes, and JPG episode images (all weekly podcast) with smart empty folder detection and resume, logging, and persistent tracking
# Author: Jason Lamb (with help from ChatGPT)
# Created Date: 2025-05-16
# Modified Date: 2026-03-13
# Changelog:
# 1.0 Initial release
# 1.1 Added logging improvements
# 1.2 Added resume via JSON tracking
# 1.3 Added two-consecutive-failure stop logic
# 1.4 Improved folder initialization and error handling
# 1.5 Added PDF show notes support
# 1.6 Refined resume handling and logging output
# 1.7 Minor stability fixes
# 1.8 Improved persistent tracking and resume reliability
# 1.9 Added JPG download support
# 2.0 Added proper JPG starting point (999) and unlimited forward growth
# 2.1 Set TXT start to 001 (padded), PDF start to 595, starting numbers used only when JSON not present
# 2.2 Updated JPG to grab all available from 1 to 1069+
# 2.3 Removed hard 1069 limit, JPG now runs indefinitely for weekly podcast with smart failure detection
# 2.4 All three file types (TXT, PDF, JPG) now run indefinitely with independent empty folder detection - works with new and existing computers

$global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
$global:baseUrl = "https://www.grc.com/sn/"
$global:jpgBaseUrl = "https://www.grc.com/SN/"

$startingPointTXT = 1     # 001
$startingPointPDF = 595
$startingPointJPG = 1     # Changed from 999 to 1 to grab full range

$trackingFile = Join-Path $global:downloadbase 'last-downloaded.json'

# Ensure base folders exist
New-Item -Path $global:downloadbase -ItemType Directory -Force | Out-Null

$txtFolder = Join-Path $global:downloadbase "TXT-Transcriptions"
$pdfFolder = Join-Path $global:downloadbase "PDF-Show-Notes"
$jpgFolder = Join-Path $global:downloadbase "JPG-Episode-Images"
$logFolder = Join-Path $global:downloadbase "Download-Logs"

New-Item -Path $txtFolder -ItemType Directory -Force | Out-Null
New-Item -Path $pdfFolder -ItemType Directory -Force | Out-Null
New-Item -Path $jpgFolder -ItemType Directory -Force | Out-Null
New-Item -Path $logFolder -ItemType Directory -Force | Out-Null

$global:logFile = Join-Path $logFolder ("download-log-{0}.txt" -f (Get-Date -Format 'yyyyMMdd'))

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $global:logFile -Value ("[{0}] {1}" -f $timestamp, $Message)
}

# ===== CHECK IF FOLDERS ARE EMPTY =====
$txtFilesExist = (Get-ChildItem -Path $txtFolder -Filter "*.txt" -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
$pdfFilesExist = (Get-ChildItem -Path $pdfFolder -Filter "*.pdf" -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
$jpgFilesExist = (Get-ChildItem -Path $jpgFolder -Filter "*.jpg" -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0

# ===== LOAD TRACKING =====
if (Test-Path $trackingFile) {
    try {
        $trackingData = Get-Content $trackingFile -Raw | ConvertFrom-Json

        # If folder is empty, force start from beginning (ignore JSON for that type)
        if ($txtFilesExist) {
            $global:nextTXT = [int]$trackingData.LastTXT + 1
        }
        else {
            $global:nextTXT = $startingPointTXT
            Write-Host "TXT folder is empty. Force-starting TXT download from $startingPointTXT." -ForegroundColor Yellow
            Write-Log "TXT folder is empty. Force-starting TXT download from $startingPointTXT."
        }

        if ($pdfFilesExist) {
            $global:nextPDF = [int]$trackingData.LastPDF + 1
        }
        else {
            $global:nextPDF = $startingPointPDF
            Write-Host "PDF folder is empty. Force-starting PDF download from $startingPointPDF." -ForegroundColor Yellow
            Write-Log "PDF folder is empty. Force-starting PDF download from $startingPointPDF."
        }

        if ($jpgFilesExist) {
            $global:nextJPG = [int]$trackingData.LastJPG + 1
        }
        else {
            $global:nextJPG = $startingPointJPG
            Write-Host "JPG folder is empty. Force-starting JPG download from $startingPointJPG." -ForegroundColor Yellow
            Write-Log "JPG folder is empty. Force-starting JPG download from $startingPointJPG."
        }

        Write-Host ("Resuming from JSON : TXT {0:000}, PDF {1}, JPG {2}" -f $global:nextTXT, $global:nextPDF, $global:nextJPG) -ForegroundColor Cyan
        Write-Log ("Resumed from JSON : TXT {0:000}, PDF {1}, JPG {2}" -f $global:nextTXT, $global:nextPDF, $global:nextJPG)
    }
    catch {
        Write-Host "Tracking file corrupt. Using starting numbers." -ForegroundColor Red
        Write-Log "Tracking file corrupt. Using starting numbers."

        $global:nextTXT = $startingPointTXT
        $global:nextPDF = $startingPointPDF
        $global:nextJPG = $startingPointJPG
    }
}
else {
    $global:nextTXT = $startingPointTXT
    $global:nextPDF = $startingPointPDF
    $global:nextJPG = $startingPointJPG

    Write-Host ("No tracking file found. Starting from : TXT {0:000}, PDF {1}, JPG {2}" -f $global:nextTXT, $global:nextPDF, $global:nextJPG) -ForegroundColor Yellow
    Write-Log ("No tracking file found. Starting from : TXT {0:000}, PDF {1}, JPG {2}" -f $global:nextTXT, $global:nextPDF, $global:nextJPG)
}

$global:txtDownloaded = 0
$global:pdfDownloaded = 0
$global:jpgDownloaded = 19

$global:lastTXT = $null
$global:lastPDF = $null
$global:lastJPG = $null

# ===== TXT =====
function Get-GRCTXT {

    $txtMaxConsecutiveFailures = 2
    $failureCount = 0

    while ($true) {

        $txtNumPadded = $global:nextTXT.ToString('000')
        $txtUrl = "{0}sn-{1}.txt" -f $global:baseUrl, $txtNumPadded
        $txtPath = Join-Path $txtFolder ("sn-{0}.txt" -f $txtNumPadded)

        Write-Host ("Checking TXT : sn-{0}.txt" -f $txtNumPadded)
        Write-Log ("Checking TXT : sn-{0}.txt" -f $txtNumPadded)

        if (Test-Path $txtPath) {
            $failureCount = 0
            $global:nextTXT++
            continue
        }

        try {
            $response = Invoke-WebRequest -Uri $txtUrl -Method Head -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Invoke-WebRequest -Uri $txtUrl -OutFile $txtPath -ErrorAction Stop
                $global:txtDownloaded++
                $global:lastTXT = $global:nextTXT
                $failureCount = 0
                Write-Log ("Downloaded TXT : sn-{0}.txt" -f $txtNumPadded)
            }
        }
        catch {
            $failureCount++
            Write-Log ("Missing TXT : sn-{0}.txt" -f $txtNumPadded)
            
            if ($failureCount -ge $txtMaxConsecutiveFailures) {
                Write-Host ("Stopping TXT download after {0} consecutive failures at episode {1}" -f $txtMaxConsecutiveFailures, $txtNumPadded) -ForegroundColor Yellow
                Write-Log ("Stopping TXT download after {0} consecutive failures at episode {1}" -f $txtMaxConsecutiveFailures, $txtNumPadded)
                break
            }
        }

        $global:nextTXT++
    }
}

# ===== PDF =====
function Get-GRCPDF {

    $pdfMaxConsecutiveFailures = 2
    $failureCount = 0

    while ($true) {

        $pdfUrl = "{0}sn-{1}-notes.pdf" -f $global:baseUrl, $global:nextPDF
        $pdfPath = Join-Path $pdfFolder ("sn-{0}-notes.pdf" -f $global:nextPDF)

        Write-Host ("Checking PDF : sn-{0}-notes.pdf" -f $global:nextPDF)
        Write-Log ("Checking PDF : sn-{0}-notes.pdf" -f $global:nextPDF)

        if (Test-Path $pdfPath) {
            $failureCount = 0
            $global:nextPDF++
            continue
        }

        try {
            $response = Invoke-WebRequest -Uri $pdfUrl -Method Head -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Invoke-WebRequest -Uri $pdfUrl -OutFile $pdfPath -ErrorAction Stop
                $global:pdfDownloaded++
                $global:lastPDF = $global:nextPDF
                $failureCount = 0
                Write-Log ("Downloaded PDF : sn-{0}-notes.pdf" -f $global:nextPDF)
            }
        }
        catch {
            $failureCount++
            Write-Log ("Missing PDF : sn-{0}-notes.pdf" -f $global:nextPDF)
            
            if ($failureCount -ge $pdfMaxConsecutiveFailures) {
                Write-Host ("Stopping PDF download after {0} consecutive failures at episode {1}" -f $pdfMaxConsecutiveFailures, $global:nextPDF) -ForegroundColor Yellow
                Write-Log ("Stopping PDF download after {0} consecutive failures at episode {1}" -f $pdfMaxConsecutiveFailures, $global:nextPDF)
                break
            }
        }

        $global:nextPDF++
    }
}

# ===== JPG =====
function Get-GRCJPG {

    $failureCount = 0
    $failureThreshold = 200  # Allow up to 20 failures before 1070 (more tolerant for early gaps/missing episodes)

    while ($true) {

        $jpgUrl = "{0}{1}.jpg" -f $global:jpgBaseUrl, $global:nextJPG
        $jpgPath = Join-Path $jpgFolder ("{0}.jpg" -f $global:nextJPG)

        Write-Host ("Checking JPG : {0}.jpg" -f $global:nextJPG)
        Write-Log ("Checking JPG : {0}.jpg" -f $global:nextJPG)

        if (Test-Path $jpgPath) {
            $failureCount = 0
            $global:nextJPG++
            continue
        }

        try {
            $response = Invoke-WebRequest -Uri $jpgUrl -Method Head -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Invoke-WebRequest -Uri $jpgUrl -OutFile $jpgPath -ErrorAction Stop
                $global:jpgDownloaded++
                $global:lastJPG = $global:nextJPG
                $failureCount = 0
                Write-Log ("Downloaded JPG : {0}.jpg" -f $global:nextJPG)
            }
        }
        catch {
            $failureCount++
            Write-Log ("Missing JPG : {0}.jpg" -f $global:nextJPG)
            
            # Adaptive failure threshold: before 1070 allow many gaps, after 1070 stop at 2 failures
            $currentThreshold = if ($global:nextJPG -ge 1070) { 2 } else { $failureThreshold }
            
            if ($failureCount -ge $currentThreshold) {
                Write-Host ("Stopping JPG download after {0} consecutive failures at episode {1}" -f $failureCount, $global:nextJPG) -ForegroundColor Yellow
                Write-Log ("Stopping JPG download after {0} consecutive failures at episode {1}" -f $failureCount, $global:nextJPG)
                break
            }
        }

        $global:nextJPG++
    }
}

# ===== SAVE STATE =====
function Save-State {

    $data = @{
        LastTXT = if ($global:lastTXT) { $global:lastTXT } else { $global:nextTXT - 1 }
        LastPDF = if ($global:lastPDF) { $global:lastPDF } else { $global:nextPDF - 1 }
        LastJPG = if ($global:lastJPG) { $global:lastJPG } else { $global:nextJPG - 1 }
    }

    $data | ConvertTo-Json | Set-Content -Path $trackingFile -Encoding UTF8

    Write-Host ("Saved JSON state : TXT {0:000}, PDF {1}, JPG {2}" -f $data.LastTXT, $data.LastPDF, $data.LastJPG) -ForegroundColor Cyan
    Write-Log ("Saved JSON state : TXT {0:000}, PDF {1}, JPG {2}" -f $data.LastTXT, $data.LastPDF, $data.LastJPG)
}

# ===== RUN =====
Get-GRCTXT
Get-GRCPDF
Get-GRCJPG

Write-Host ("Downloaded TXT : {0}" -f $global:txtDownloaded) -ForegroundColor Cyan
Write-Host ("Downloaded PDF : {0}" -f $global:pdfDownloaded) -ForegroundColor Cyan
Write-Host ("Downloaded JPG : {0}" -f $global:jpgDownloaded) -ForegroundColor Cyan

Write-Log ("Downloaded TXT : {0}" -f $global:txtDownloaded)
Write-Log ("Downloaded PDF : {0}" -f $global:pdfDownloaded)
Write-Log ("Downloaded JPG : {0}" -f $global:jpgDownloaded)

Save-State

Write-Log "Run complete"
Write-Log "~~~`n"

Start-Process -FilePath $global:logFile

<# 
======================
EXAMPLE USAGE
======================

# Option 1 (dot-source then run):
. .\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1

# Option 2 (run directly):
.\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1

# Notes:
# - Script works with NEW computers (no existing files) and EXISTING computers (with files)
# - Each file type (TXT, PDF, JPG) is checked independently:
#   * If folder is empty, it starts from the beginning
#   * If folder has files, it resumes from JSON tracking file
# - Starting points (used only when JSON tracking file is missing):
#   TXT : 001
#   PDF : 595
#   JPG : 1
# - All three file types run indefinitely (weekly podcast) and stop after 2 consecutive failures
# - Run this script weekly to pick up new episodes as they are released
# - JSON tracking file (last-downloaded.json) is created/updated automatically
#>