# Revision : 1.5
# Description : Downloads GRC Security Now transcripts and PDF show notes until two consecutive failures occur
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-05-16
# Modified Date : 2025-07-10

$global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads" # base folder on computer
$global:baseUrl = "https://www.grc.com/sn/"     # Define the base URL and file pattern
$global:nextFileNumber = 1030   # Start at 1032 (or set explicitly to the highest number) 7/10/25
$global:nextfilenumberpdf = $global:nextFileNumber #this mimics the original script start but is not modified by the txt file incremental

function get-grctxttranscript{

    $txtFolder = "$global:downloadbase\TXT-Transcriptions"

    # Initialize failure count and the starting file number
    $failureCount = 0
    
    # Keep downloading until two consecutive failures
    while ($failureCount -lt 2) {

        Write-Host "Next file number to check: $global:nextFileNumber"

        # Format the URL for the next TXT file
        $txtUrl = "${global:baseUrl}sn-$global:nextFileNumber.txt"

        # Define the local file path
        $txtFilePath = "$txtFolder\sn-$global:nextFileNumber.txt"

        # Check if the TXT file already exists, if so, skip
        if (Test-Path $txtFilePath) {
            Write-Host "TXT already exists: sn-$global:nextFileNumber.txt, skipping download." -ForegroundColor Green
            # Reset failure count since file exists
            $failureCount = 0
            $global:nextFileNumber++  # Increment to the next file number
            continue
        } else {
            # Attempt to download if the file does not exist
            try {
                $txtResponse = Invoke-WebRequest -Uri $txtUrl -Method Head -ErrorAction Stop
                if ($txtResponse.StatusCode -eq 200) {
                    Write-Host "Downloading TXT: sn-$global:nextFileNumber.txt" -ForegroundColor Yellow
                    Invoke-WebRequest -Uri $txtUrl -OutFile $txtFilePath
                    Write-Host $txtUrl -ForegroundColor Yellow

                    # Reset failure count since file was successfully downloaded
                    $failureCount = 0
                    $global:nextFileNumber++  # Increment to the next file number
                } else {
                    Write-Host "TXT url not found on web: sn-$global:nextFileNumber.txt"  -ForegroundColor Red
                    $failureCount++
                    $global:nextFileNumber++
                }

            } catch {
                Write-Host "Error accessing the URL: $txtUrl" -ForegroundColor Red
                $failureCount++
                $global:nextFileNumber++
            }

        }

        # Exit the loop if two consecutive failures occur
        if ($failureCount -eq 2) {
            Write-Host "Stopped downloading after two consecutive failures."  -ForegroundColor Red
            break
        }
    }
}

get-grctxttranscript



function get-grcpdfshownotes{
    # Define the base URL and file pattern
    $pdfFolder = "$global:downloadbase\PDF-Show-Notes"

    # Initialize failure count and the starting file number
    $failureCount = 0
    

    # Keep downloading until two consecutive failures
    while ($failureCount -lt 2) {

        Write-Host "Next file number to check: $global:nextfilenumberpdf"

        # Format the URL for the next pdf file
        $pdfUrl = "${global:baseUrl}sn-$global:nextfilenumberpdf-notes.pdf"

        # Define the local file path
        $pdfFilePath = "$pdfFolder\sn-$global:nextfilenumberpdf-notes.pdf"

        # Check if the pdf file already exists, if so, skip
        if (Test-Path $pdfFilePath) {
            Write-Host "PDF already exists: sn-$global:nextfilenumberpdf-notes.pdf, skipping download." -ForegroundColor Green
            # Reset failure count since file exists
            $failureCount = 0
            $global:nextfilenumberpdf++  # Increment to the next file number
            continue # restart the loop for next file
        } else {
            # Attempt to download if the file does not exist
            try {
                $pdfResponse = Invoke-WebRequest -Uri $pdfUrl -Method Head -ErrorAction Stop
                if ($pdfResponse.StatusCode -eq 200) {
                    Write-Host "Downloading PDF: sn-$global:nextfilenumberpdf-notes.pdf" -ForegroundColor yellow
                    Invoke-WebRequest -Uri $pdfUrl -OutFile $pdfFilePath
                    Write-Host $pdfUrl -ForegroundColor yellow

                    # Reset failure count since file was successfully downloaded
                    $failureCount = 0
                } else {
                    Write-Host "PDF url not found on web: sn-$global:nextfilenumberpdf-notes.pdf" -ForegroundColor Red
                    Write-Host $pdfUrl -ForegroundColor Red

                    # Increment failure count if file is not found
                    $failureCount++
                }
            } catch {
                Write-Host "Error with URL: $pdfUrl" -ForegroundColor Red
                $failureCount++
            }

            # Increment the file number after processing
            $global:nextfilenumberpdf++
        }

        # Exit the loop if two consecutive failures occur
        if ($failureCount -eq 2) {
            Write-Host "Stopped downloading after two consecutive failures." -ForegroundColor red
            break
        }
    }
}

get-grcpdfshownotes
