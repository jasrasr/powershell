# Start the job
$job = start-job -name 'n-bpstatus-filter-folders' -scriptblock {
    param (
        $inputnum,
        $outputnum
    )

    # Path to the input file (updated to clean5.txt)
    $inputFile = "c:\temp\n-bpstatus-tol-files-clean$inputnum.txt"

    # Path to the output file (updated to clean6.txt)
    $outputFile = "c:\temp\n-bpstatus-tol-files-clean$outputnum.txt"

    # Read the file content
    $filePaths = Get-Content $inputFile

    # Filter out lines with .msg and .rtf extensions
    $foldersOnly = $filePaths | Where-Object { 
        $_ -notmatch '\.html$' -and $_ -notmatch '\.tmp$' -and $_ -notmatch '\.vsd$' -and $_ -notmatch '\.mdb$' -and $_ -notmatch '\.vsdx$' -and $_ -notmatch '\.mpp$' -and $_ -notmatch '\.mppx$' -and $_ -notmatch '\.xer$'  -and $_ -notmatch '\.zip$' -and $_ -notmatch '\.plf$' -and $_ -notmatch '\.ppt$' -and $_ -notmatch '\.pub$' -and $_ -notmatch '\.xlr$' -and $_ -notmatch '\.dwg$' -and $_ -notmatch '\.xlsm$' -and $_ -notmatch '\.822$'
    }

    # Calculate line count changes
    $inputLineCount = $filePaths.Count
    $outputLineCount = $foldersOnly.Count
    $lineChange = $inputLineCount - $outputLineCount

    # Display the changes
    Write-Host "Input file line count: $inputLineCount"
    Write-Host "Output file line count: $outputLineCount"
    Write-Host "Lines removed: $lineChange"

    # Output the updated content to the output file
    $foldersOnly | Out-File $outputFile

    write-host "Current: Input #$inputnum & Output #$outputnum"

    # Do not increment here, return the inputnum and outputnum to main script
    return @{InputNum = $inputnum; OutputNum = $outputnum; LineChange = $lineChange}
} -ArgumentList $inputnum, $outputnum

# Check job status every second while it's running
do {
    # Get the current job status
    $jobStatus = Get-Job -Id $job.Id

    # Check if the job is still running
    if ($jobStatus.State -eq 'Running') {
        Write-Host "Job is still running... checking again in 1 second."
        Start-Sleep -Seconds 1
    }
} while ($jobStatus.State -eq 'Running')

Write-Host "Job completed with status: $($jobStatus.State)"

# Get the job results (inputnum, outputnum, and line changes)
$jobResults = Receive-Job -Id $job.Id

# Clean up the job
Remove-Job -Id $job.Id

# Display the line change result from the job
Write-Host "Lines removed: $($jobResults.LineChange)"

# Open the output file in Notepad
Start-Process "C:\Windows\System32\notepad.exe" -ArgumentList "c:\temp\n-bpstatus-tol-files-clean$($jobResults.OutputNum).txt"

# Increment the input and output numbers AFTER the job is done
$inputnum = $jobResults.OutputNum
$outputnum = $inputnum + 1

write-host "Next: Input #$inputnum & Output #$outputnum"
