# Get folder permissions using icacls

# Define folder paths
$projectFolderPath = '\\middough.local\corp\data\proj\!newprojecttemplate-BIM'
$clientFolderPath = '\\middough.local\corp\data\proj\!newclienttemplate'

# Array of folder paths to process
$folders = @($projectFolderPath, $clientFolderPath)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "Getting permissions for folders in: $folder" -ForegroundColor Green

        # Get only directories (folders) and process them
        Get-ChildItem -Path $folder -Directory -Recurse | ForEach-Object {
            icacls $_.FullName | out-file "C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls1.txt" -Append
        }
    } else {
        Write-Host "The specified folder path does not exist: $folder" -ForegroundColor Red
    }
}
notepad "C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls.txt"

$files = @(
    'C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\robocopy Logs\clean\robocopy-2025-03-31-12-58-44.log',
    'C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\robocopy Logs\clean\largerobocopy-clean1-clean.log'
)

foreach ($file in $files) {
#$logFilePath = "C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\robo"

if (Test-Path $file) {
    $lineCount = (Get-Content $file).Count
    $fileSizeBytes = (Get-Item $file).Length
    $fileSizeMB = [math]::round($fileSizeBytes / 1MB, 2)
    Write-Host "The log file contains $lineCount lines. Size is $fileSizeMB MB" -ForegroundColor Cyan
} else {
    Write-Host "The log file does not exist: $file" -ForegroundColor Red
}
}

foreach ($file in $files) {
    #$logFilePath = $file
#$logFilePath = "C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls1.txt"
#$logFilePath = "C:\users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls1.txt"
if (Test-Path $file) {
    # Efficient way to count lines without reading entire file into memory
    $lineCount = [System.IO.File]::ReadLines($file) | Measure-Object -Line
    $fileSizeBytes = (Get-Item $file).Length
    $fileSizeMB = [math]::round($fileSizeBytes / 1MB, 2)
    Write-Host "The log file contains $($lineCount.Lines) lines. Size is $fileSizeMB MB" -ForegroundColor Cyan
} else {
    Write-Host "The log file does not exist: $file" -ForegroundColor Red
}

}
