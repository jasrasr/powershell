# Filename : download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1
# Revision : 2.1
# Description : Downloads GRC Security Now TXT transcripts, PDF show notes, and JPG episode images with resume, logging, and persistent tracking
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-05-16
# Modified Date : 2026-02-25
# Changelog :
# Changelog :
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

$global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
$global:baseUrl = "https://www.grc.com/sn/"
$global:jpgBaseUrl = "https://www.grc.com/SN/"

$startingPointTXT = 1     # 001
$startingPointPDF = 595
$startingPointJPG = 999

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

# ===== LOAD TRACKING =====
if (Test-Path $trackingFile) {
    try {
        $trackingData = Get-Content $trackingFile -Raw | ConvertFrom-Json

        $global:nextTXT = [int]$trackingData.LastTXT + 1
        $global:nextPDF = [int]$trackingData.LastPDF + 1
        $global:nextJPG = [int]$trackingData.LastJPG + 1

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
$global:jpgDownloaded = 0

$global:lastTXT = $null
$global:lastPDF = $null
$global:lastJPG = $null

# ===== TXT =====
function Get-GRCTXT {

    $failureCount = 0

    while ($failureCount -lt 2) {

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
        }

        $global:nextTXT++
    }
}

# ===== PDF =====
function Get-GRCPDF {

    $failureCount = 0

    while ($failureCount -lt 2) {

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
        }

        $global:nextPDF++
    }
}

# ===== JPG =====
function Get-GRCJPG {

    $failureCount = 0

    while ($failureCount -lt 2) {

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
# - If last-downloaded.json exists, the script resumes from it.
# - If it does not exist, it starts at:
#   TXT : 001
#   PDF : 595
#   JPG : 999
# - Each section stops after two consecutive missing items.
#>
