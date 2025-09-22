function get-grcpdfshownotes{
    # Define the base URL and file pattern
    $baseUrl = "https://grc.com/sn/"
    $pdfFolder = "$onedrivepath\Downloads\GRC_SN_Files\PDF Show Notes"

    # Initialize failure count and the starting file number
    $failureCount = 0
    $nextFileNumber = 1000  # Start at 1000 (or set explicitly to the highest number)

    # Keep downloading until two consecutive failures
    while ($failureCount -lt 2) {

        Write-Host "Next file number to check: $nextFileNumber"

        # Format the URL for the next pdf file
        $pdfUrl = "${baseUrl}sn-$nextFileNumber-notes.pdf"

        # Define the local file path
        $pdfFilePath = "$pdfFolder\sn-$nextFileNumber-notes.pdf"

        # Check if the pdf file already exists, if so, skip
        if (Test-Path $pdfFilePath) {
            Write-Host "PDF already exists: sn-$nextFileNumber-notes.pdf, skipping download." -ForegroundColor Green
            # Reset failure count since file exists
            $failureCount = 0
            $nextFileNumber++  # Increment to the next file number
            continue # restart the loop for next file
        } else {
            # Attempt to download if the file does not exist
            try {
                $pdfResponse = Invoke-WebRequest -Uri $pdfUrl -Method Head -ErrorAction Stop
                if ($pdfResponse.StatusCode -eq 200) {
                    Write-Host "Downloading PDF: sn-$nextFileNumber-notes.pdf"
                    Invoke-WebRequest -Uri $pdfUrl -OutFile $pdfFilePath
                    Write-Host $pdfUrl

                    # Reset failure count since file was successfully downloaded
                    $failureCount = 0
                } else {
                    Write-Host "PDF not found: sn-$nextFileNumber-notes.pdf" -ForegroundColor Red
                    Write-Host $pdfUrl -ForegroundColor Red

                    # Increment failure count if file is not found
                    $failureCount++
                }
            } catch {
                Write-Host "Error with URL: $pdfUrl" -ForegroundColor Red
                $failureCount++
            }

            # Increment the file number after processing
            $nextFileNumber++
        }

        # Exit the loop if two consecutive failures occur
        if ($failureCount -eq 2) {
            Write-Host "Stopped downloading after two consecutive failures."
            break
        }
    }
}

get-grcpdfshownotes
