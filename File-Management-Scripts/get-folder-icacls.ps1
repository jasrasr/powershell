# Get folder permissions using icacls

# Define folder paths
$projectFolderPath = '\\${domain}.local\corp\data\proj\!newprojecttemplate-BIM'
$clientFolderPath = '\\${domain}.local\corp\data\proj\!newclienttemplate'

# Array of folder paths to process
$folders = @($projectFolderPath, $clientFolderPath)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "Getting permissions for folders in: $folder" -ForegroundColor Green

        # Get only directories (folders) and process them
        Get-ChildItem -Path $folder -Directory -Recurse | ForEach-Object {
            icacls $_.FullName | out-file "C:\users\${usernmae}\OneDrive - ${domain}\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls1.txt" -Append
        }
    } else {
        Write-Host "The specified folder path does not exist: $folder" -ForegroundColor Red
    }
}
notepad "${onedrivepath}\Documents\GitHub\PowerShell-Private\File-Management-Scripts\n drive client and folder icacls.txt"

$files = @(
    '${onedrivepath}\Documents\GitHub\robocopy Logs\clean\robocopy-2025-03-31-12-58-44.log',
    '${onedrivepath}\Documents\GitHub\robocopy Logs\clean\largerobocopy-clean1-clean.log'
)


$logFilePath = "${onedrivepath}\Documents\GitHub\robo"
if (Test-Path $logFilePath) {
    $lineCount = (Get-Content $logFilePath).Count
    $fileSizeBytes = (Get-Item $logFilePath).Length
    $fileSizeMB = [math]::round($fileSizeBytes / 1MB, 2)
    Write-Host "The log file contains $lineCount lines. Size is $fileSizeMB MB" -ForegroundColor Cyan
} else {
    Write-Host "The log file does not exist: $logFilePath" -ForegroundColor Red
}

