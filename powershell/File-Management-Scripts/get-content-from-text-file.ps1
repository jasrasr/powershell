# Define the path to the text files
$txtFilesPath = "C:\Users\jason.lamb\OneDrive - middough\Downloads\GRC_SN_Files\Transcriptions\*.txt"

# Define the output file path
$outputCsvPath = "C:\Users\jason.lamb\OneDrive - middough\Downloads\GRC_SN_Files\Transcriptions\output\output.txt"

# Initialize the output file with headers
"File,Series,Episode,Date,Title" | Out-File -FilePath $outputCsvPath

# Get all text files in the directory
$txtFiles = Get-ChildItem -Path $txtFilesPath

foreach ($file in $txtFiles) {
    # Get the content of the current file
    $content = Get-Content -Path $file.FullName

    # Ensure the file has at least 6 rows
    if ($content.Count -ge 6) {
        try {
            # Extract rows 3 to 6 and parse data
            $seriesRaw = $content[2]
            $episodeRaw = $content[3]
            $dateRaw = $content[4]
            $titleRaw = $content[5]

            # Parse fields with more flexible handling
            $series = ($seriesRaw -split "[:`t]+")[1].Trim()
            $episode = ($episodeRaw -split "[:`t]+")[1].Trim()
            $dateString = ($dateRaw -split "[:`t]+")[1].Trim()
            $title = ($titleRaw -split "[:`t]+")[1].Trim()

            # Convert date to MM/DD/YY format
            if (-not [string]::IsNullOrWhiteSpace($dateString)) {
                $date = (Get-Date $dateString -Format "MM/dd/yy")
            } else {
                $date = "Invalid Date"
            }

            # Escape problematic characters (e.g., quotes) in the title or other fields
            $series = $series -replace '"', '""'
            $episode = $episode -replace '"', '""'
            $title = $title -replace '"', '""'

            # Create the output row
            $output = "$($file.Name),$series,$episode,$date,$title"

            # Append to the output file
            $output | Out-File -FilePath $outputCsvPath -Append
        } catch {
            # Log parsing errors with details
            $errorMessage = "File: $($file.Name) could not parse rows 3-6 correctly. Error: $($_.Exception.Message)"
            $errorMessage | Out-File -FilePath $outputCsvPath -Append
        }
    } else {
        # Log files with insufficient rows
        $errorMessage = "File: $($file.Name) does not have at least 6 rows."
        $errorMessage | Out-File -FilePath $outputCsvPath -Append
    }
}
