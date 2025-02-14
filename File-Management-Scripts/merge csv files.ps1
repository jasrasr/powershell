# Define the folder containing the CSV files
$inputFolder = "C:\Users\jason.lamb\OneDrive - middough\Downloads\Microsoft Access database engine 2010"
# Define the output file path
$outputFile = "C:\Users\jason.lamb\OneDrive - middough\Downloads\Microsoft Access database engine 2010\merged\merged 121724.csv"
$outputFilepath = Split-Path -Path $outputFile -Parent

if (-not (Test-Path $outputFile)) {
    New-Item -Path $outputFilepath -ItemType Directory
}

# Get all CSV files from the input folder
$csvFiles = Get-ChildItem -Path $inputFolder -Filter *.csv

# Initialize an array to store CSV content
$mergedData = @()

# Loop through each CSV file and import its content
foreach ($file in $csvFiles) {
    Write-Host "Processing file: $($file.Name)"
    $csvContent = Import-Csv -Path $file.FullName
    $mergedData += $csvContent
}

# Export the merged data to the output CSV file
$mergedData | Export-Csv -Path $outputFile -NoTypeInformation -Force

Write-Host "CSV files merged successfully into $outputFile"
