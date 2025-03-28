# Get Date and Time
$dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Autodesk\UPI2"

# Define the output file path
$outputFile = "C:\Temp\Automox-Exports\Autodesk-Installed-Apps-v2\AutodeskProgramsInstalledv2-$dateTime.txt"

# Ensure the destination directory structure exists
$outputDirectory = Split-Path -Path $outputFile
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

# Get all subkeys under the specified path
$subkeys = Get-ChildItem -Path $registryPath


# Initialize an array to store the results
$result = @()

foreach ($subkey in $subkeys) {
    # Get the ProductName and BuildNumber from each subkey
    $productName = (Get-ItemProperty -Path $subkey.PSPath -Name "ProductName" -ErrorAction SilentlyContinue).ProductName
    $buildNumber = (Get-ItemProperty -Path $subkey.PSPath -Name "BuildNumber" -ErrorAction SilentlyContinue).BuildNumber

    # Add to the result array if both values exist
    if ($productName -and $buildNumber) {
        $keyFolder = Split-Path -Path $subkey.PSPath -Leaf
        $result += [PSCustomObject]@{
            ProductName = $productName
            BuildNumber = $buildNumber
            KeyFolder   = $keyFolder
        }
    }
}

# Sort the results by ProductName
#$sortedResult = $result | Sort-Object -Property ProductName

# Export the sorted result to screen and file
#$sortedResult | Format-Table -AutoSize | Tee-Object -FilePath $outputFile

# Export the sorted result to file in CSV format
$sortedResult | Export-Csv -Path $outputFile -NoTypeInformation

# Display the sorted result on the screen in table format
$sortedResult | Format-Table -AutoSize