# Parameters
$psDrive = "N:"
$outputFile = "C:\Temp\Automox-Exports\panzura-space.txt"

# Get current date and time
$currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Try to get drive info
$driveInfo = Get-PSDrive -Name $psDrive.TrimEnd(':')

if ($driveInfo) {
    # Create a custom object for formatting
    $driveData = Get-PSDrive -Name $psDrive.TrimEnd(':') | Select-Object Name, 
        @{Name='Used (GB)';Expression={[math]::Round(($_.Used / 1GB), 2)}}, 
        @{Name='Free (GB)';Expression={[math]::Round(($_.Free / 1GB), 2)}}, 
        @{Name='Used (TB)';Expression={[math]::Round(($_.Used / 1TB), 2)}}, 
        @{Name='Free (TB)';Expression={[math]::Round(($_.Free / 1TB), 2)}}, 
        Root

    # Format the output as a table
    $formattedOutput = $driveData | Format-Table -AutoSize | Out-String

    # Append timestamp and drive info
    $outputString = @"
[$currentDateTime] Drive: $psDrive
$formattedOutput
"@

    # Log output to file
    $outputString | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "-------------------------------" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
    "" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
} else {
    # Log error if drive doesn't exist
    "[$currentDateTime] ERROR: Drive $psDrive does not exist." | Out-File -FilePath $outputFile -Encoding UTF8 -Append
}

# Display the same output in the console
if ($driveInfo) {
    Write-Host $outputString
} else {
    Write-Host "[$currentDateTime] ERROR: Drive $psDrive does not exist."
}
