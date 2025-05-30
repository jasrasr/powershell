# ConvertCsvToXlsx.ps1

# Define the folder to monitor
$watchFolder = 'C:\Users\jason.lamb\OneDrive - middough\Downloads\csv2xlsx'
$processedFolder = Join-Path $watchFolder 'Processed'

# Ensure the processed folder exists
if (!(Test-Path -Path $processedFolder)) {
    New-Item -ItemType Directory -Path $processedFolder | Out-Null
}

# Import the ImportExcel module
if (!(Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}
Import-Module ImportExcel

# Get all CSV files in the watch folder
$csvFiles = Get-ChildItem -Path $watchFolder -Filter '*.csv' -File

foreach ($file in $csvFiles) {
    try {
        $xlsxPath = [System.IO.Path]::ChangeExtension($file.FullName, '.xlsx')

        # Convert CSV to XLSX
        Import-Csv -Path $file.FullName | Export-Excel -Path $xlsxPath -WorksheetName 'Data' -AutoSize

        # Move processed CSV to the processed folder
        Move-Item -Path $file.FullName -Destination $processedFolder
    }
    catch {
        Write-Error "Failed to process $($file.FullName): $_"
    }
}

