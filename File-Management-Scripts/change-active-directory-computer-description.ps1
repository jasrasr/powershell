# Define variables
$inputFile = "C:\Temp\haveibeenpwnd\pwnedpasswords_ntlm.txt"  # Full path to the large file
$outputFolder = "C:\Temp\haveibeenpwnd\split\"               # Folder to store split files
$chunkSize = 1GB                                             # Size of each chunk (1GB)

# Ensure the output folder exists
if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Initialize variables
$chunkNumber = 1
$currentChunkSize = 0
$outputFile = $null

# Open the input file for reading
$reader = [System.IO.StreamReader]::new($inputFile)

try {
    while ($reader.Peek() -ne -1) {
        $line = $reader.ReadLine()
        $lineSize = [System.Text.Encoding]::UTF8.GetByteCount($line + "`r`n")

        # Check if we need to create a new chunk
        if ($currentChunkSize + $lineSize -gt $chunkSize) {
            if ($null -ne $outputFile) {
                $outputFile.Close()
            }
            $chunkNumber++
            $currentChunkSize = 0
            $outputFile = [System.IO.StreamWriter]::new("$outputFolder\split_$chunkNumber.txt")
        }

        # Create a new output file if it doesn't exist
        if ($null -eq $outputFile) {
            $outputFile = [System.IO.StreamWriter]::new("$outputFolder\split_$chunkNumber.txt")
        }

        # Write the line to the current chunk
        $outputFile.WriteLine($line)
        $currentChunkSize += $lineSize
    }
}   
finally {
    if ($null -ne $outputFile) {
        $outputFile.Close()
    }
    $reader.Close()
}

Write-Host "File split completed. Created $chunkNumber chunks."
