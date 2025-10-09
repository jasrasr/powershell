# Revision : 1.8
# Description : Downloads GRC Security Now transcripts and PDF show notes with resume, logging, and persistent tracking
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-05-16
# Modified Date : 2025-08-18

$global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
$global:baseUrl = "https://www.grc.com/sn/"
$startingPoint = 1030
$global:lastTXTDownloaded = $null
$global:lastPDFDownloaded = $null
$trackingFile = Join-Path $global:downloadbase 'last-downloaded.json'

# Ensure base folder exists
if (-not (Test-Path $global:downloadbase)) {
    New-Item -Path $global:downloadbase -ItemType Directory -Force | Out-Null
}

# Init folders
$txtFolder = "$global:downloadbase\TXT-Transcriptions"
$pdfFolder = "$global:downloadbase\PDF-Show-Notes"

# Init log
$global:logFile = "$global:downloadbase\Download-Logs\download-log-$(Get-Date -Format 'yyyyMMdd').txt"
# Test if log file exist and create if not
if(-not(Test-Path $global:logFile)) {
    New-Item -Path "$global:downloadbase\Download-Logs" -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $global:logFile -Value "[$timestamp] $Message"
}

# Load last downloaded number or fallback to starting point
if (Test-Path $trackingFile) {
    try {
        $trackingData = Get-Content -Path $trackingFile | ConvertFrom-Json
        $global:nextFileNumber = [int]$trackingData.LastTXT + 1
        $global:nextfilenumberpdf = [int]$trackingData.LastPDF + 1
        Write-Host "Resuming from JSON : TXT $($global:nextFileNumber), PDF $($global:nextfilenumberpdf)" -ForegroundColor Cyan
        Write-Log "Resuming from last-downloaded.json"
    } catch {
        Write-Host "Failed to parse last-downloaded.json, defaulting to $startingPoint" -ForegroundColor Red
        Write-Log "Failed to parse last-downloaded.json, defaulting to $startingPoint"
        $global:nextFileNumber = $startingPoint
        $global:nextfilenumberpdf = $startingPoint
    }
} else {
    $global:nextFileNumber = $startingPoint
    $global:nextfilenumberpdf = $startingPoint
    Write-Host "No tracking file found, starting from $startingPoint" -ForegroundColor Yellow
    Write-Log "No tracking file found, starting from $startingPoint"
}


$global:txtDownloaded = 0
$global:pdfDownloaded = 0

function get-grctxttranscript {
    $failureCount = 0
    while ($failureCount -lt 2) {
        Write-Host "Next TXT file number to check: $global:nextFileNumber"
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
                    $global:lastTXTDownloaded = $global:nextFileNumber
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
    $failureCount = 0
    while ($failureCount -lt 2) {
        Write-Host "Next PDF file number to check: $global:nextfilenumberpdf"
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
                    $global:lastPDFDownloaded = $global:nextfilenumberpdf
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

function Save-LastDownloaded {
    if ($global:txtDownloaded -eq 0 -and $global:pdfDownloaded -eq 0) {
        Write-Host "No successful downloads, skipping update to last-downloaded.json" -ForegroundColor Yellow
        Write-Log "No downloads — last-downloaded.json was NOT updated"
        return
    }

    $data = @{
        LastTXT = if ($global:lastTXTDownloaded) { $global:lastTXTDownloaded } else { $global:nextFileNumber - 1 }
        LastPDF = if ($global:lastPDFDownloaded) { $global:lastPDFDownloaded } else { $global:nextfilenumberpdf - 1 }
    }

    $data | ConvertTo-Json | Set-Content -Path $trackingFile -Encoding UTF8
    Write-Host "Saved last downloaded numbers to: $trackingFile" -ForegroundColor Cyan
    Write-Log "Saved last TXT : sn-$($data.LastTXT).txt"
    Write-Log "Saved last PDF : sn-$($data.LastPDF)-notes.pdf"
}



# Run downloads
get-grctxttranscript
get-grcpdfshownotes

# Summary
Write-Host "Downloaded TXT transcripts : $global:txtDownloaded" -ForegroundColor Cyan
Write-Host "Downloaded PDF notes       : $global:pdfDownloaded" -ForegroundColor Cyan
Write-Log "TXT files downloaded: $global:txtDownloaded"
Write-Log "PDF files downloaded: $global:pdfDownloaded"


# Save last known downloaded state
Save-LastDownloaded

Write-Log "Log complete."
Write-Log "~~~`n"

# Open the log file
Start-Process -FilePath $global:logFile
