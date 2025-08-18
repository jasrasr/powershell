# Revision : 1.7
# Description : Downloads GRC Security Now transcripts and PDF show notes until two consecutive failures occur, logs results, and opens the log file.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-05-16
# Modified Date : 2025-08-18

$global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
$global:baseUrl = "https://www.grc.com/sn/"
$startingPoint = 1030

# Ensure base download folder exists
if (-not (Test-Path $global:downloadbase)) {
    New-Item -Path $global:downloadbase -ItemType Directory -Force | Out-Null
}

# Auto-calculate the next available number by checking file presence
$txtFolder = "$global:downloadbase\TXT-Transcriptions"
$pdfFolder = "$global:downloadbase\PDF-Show-Notes"

$nextAvailable = $startingPoint
while ($true) {
    $txtPath = Join-Path $txtFolder "sn-$nextAvailable.txt"
    $pdfPath = Join-Path $pdfFolder "sn-$nextAvailable-notes.pdf"

    if ((Test-Path $txtPath) -and (Test-Path $pdfPath)) {
        $nextAvailable++
    } else {
        break
    }
}

$global:nextFileNumber = $nextAvailable
$global:nextfilenumberpdf = $nextAvailable

$global:logFile = "$global:downloadbase\download-log-$(Get-Date -Format 'yyyyMMdd').txt"

$global:txtDownloaded = 0
$global:pdfDownloaded = 0

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $global:logFile -Value "[$timestamp] $Message"
}

function get-grctxttranscript {
    $txtFolder = "$global:downloadbase\TXT-Transcriptions"
    $failureCount = 0

    while ($failureCount -lt 2) {
        Write-Host "Next file number to check: $global:nextFileNumber"
        Write-Log "Checking TXT: sn-$global:nextFileNumber.txt"

        $txtUrl = "${global:baseUrl}sn-$global:nextFileNumber.txt"
        $txtFilePath = "$txtFolder\sn-$global:nextFileNumber.txt"

        if (Test-Path $txtFilePath) {
            Write-Host "TXT already exists: sn-$global:nextFileNumber.txt, skipping download." -ForegroundColor Green
            Write-Log "Skipped (exists): sn-$global:nextFileNumber.txt"
            $failureCount = 0
            $global:nextFileNumber++
            continue
        } else {
            try {
                $txtResponse = Invoke-WebRequest -Uri $txtUrl -Method Head -ErrorAction Stop
                if ($txtResponse.StatusCode -eq 200) {
                    Write-Host "Downloading TXT: sn-$global:nextFileNumber.txt" -ForegroundColor Yellow
                    Invoke-WebRequest -Uri $txtUrl -OutFile $txtFilePath
                    Write-Host $txtUrl -ForegroundColor Yellow
                    Write-Log "Downloaded: sn-$global:nextFileNumber.txt"
                    $global:txtDownloaded++
                    $failureCount = 0
                    $global:nextFileNumber++
                } else {
                    Write-Host "TXT url not found on web: sn-$global:nextFileNumber.txt" -ForegroundColor Red
                    Write-Log "Not found (HEAD 404): sn-$global:nextFileNumber.txt"
                    $failureCount++
                    $global:nextFileNumber++
                }
            } catch {
                Write-Host "Error accessing the URL: $txtUrl" -ForegroundColor Red
                Write-Log "Error: $txtUrl - $_"
                $failureCount++
                $global:nextFileNumber++
            }
        }

        if ($failureCount -eq 2) {
            Write-Host "Stopped downloading after two consecutive failures." -ForegroundColor Red
            Write-Log "TXT stopped after 2 consecutive failures at sn-$global:nextFileNumber.txt"
            break
        }
    }
}

function get-grcpdfshownotes {
    $pdfFolder = "$global:downloadbase\PDF-Show-Notes"
    $failureCount = 0

    while ($failureCount -lt 2) {
        Write-Host "Next file number to check: $global:nextfilenumberpdf"
        Write-Log "Checking PDF: sn-$global:nextfilenumberpdf-notes.pdf"

        $pdfUrl = "${global:baseUrl}sn-$global:nextfilenumberpdf-notes.pdf"
        $pdfFilePath = "$pdfFolder\sn-$global:nextfilenumberpdf-notes.pdf"

        if (Test-Path $pdfFilePath) {
            Write-Host "PDF already exists: sn-$global:nextfilenumberpdf-notes.pdf, skipping download." -ForegroundColor Green
            Write-Log "Skipped (exists): sn-$global:nextfilenumberpdf-notes.pdf"
            $failureCount = 0
            $global:nextfilenumberpdf++
            continue
        } else {
            try {
                $pdfResponse = Invoke-WebRequest -Uri $pdfUrl -Method Head -ErrorAction Stop
                if ($pdfResponse.StatusCode -eq 200) {
                    Write-Host "Downloading PDF: sn-$global:nextfilenumberpdf-notes.pdf" -ForegroundColor Yellow
                    Invoke-WebRequest -Uri $pdfUrl -OutFile $pdfFilePath
                    Write-Host $pdfUrl -ForegroundColor Yellow
                    Write-Log "Downloaded: sn-$global:nextfilenumberpdf-notes.pdf"
                    $global:pdfDownloaded++
                    $failureCount = 0
                } else {
                    Write-Host "PDF url not found on web: sn-$global:nextfilenumberpdf-notes.pdf" -ForegroundColor Red
                    Write-Host $pdfUrl -ForegroundColor Red
                    Write-Log "Not found (HEAD 404): sn-$global:nextfilenumberpdf-notes.pdf"
                    $failureCount++
                }
            } catch {
                Write-Host "Error with URL: $pdfUrl" -ForegroundColor Red
                Write-Log "Error: $pdfUrl - $_"
                $failureCount++
            }

            $global:nextfilenumberpdf++
        }

        if ($failureCount -eq 2) {
            Write-Host "Stopped downloading after two consecutive failures." -ForegroundColor Red
            Write-Log "PDF stopped after 2 consecutive failures at sn-$global:nextfilenumberpdf-notes.pdf"
            break
        }
    }
}

# Run download functions
get-grctxttranscript
get-grcpdfshownotes

# Output summary
Write-Host "Downloaded TXT transcripts : $global:txtDownloaded" -ForegroundColor Cyan
Write-Host "Downloaded PDF notes       : $global:pdfDownloaded" -ForegroundColor Cyan

Write-Log "TXT files downloaded: $global:txtDownloaded"
Write-Log "PDF files downloaded: $global:pdfDownloaded"
Write-Log "Log complete."

# Open the log file
Start-Process -FilePath $global:logFile
