# Get folder permissions using icacls

$projectRoot = if ($ndrive) {
    $ndrive
} elseif ($domain) {
    "\\$domain.local\corp\data\proj"
} else {
    throw "Set `$ndrive or `$domain before running this script."
}

$githubRoot = if ($githubpath) {
    $githubpath
} elseif ($onedrivepath) {
    Join-Path $onedrivepath 'Documents\GitHub'
} else {
    throw "Set `$githubpath or `$onedrivepath before running this script."
}

$projectFolderPath = Join-Path $projectRoot '!newprojecttemplate-BIM'
$clientFolderPath = Join-Path $projectRoot '!newclienttemplate'
$folders = @($projectFolderPath, $clientFolderPath)

$outputFile = Join-Path $githubRoot 'PowerShell-Private\File-Management-Scripts\n drive client and folder icacls1.txt'
$files = @(
    (Join-Path $githubRoot 'robocopy Logs\clean\robocopy-2025-03-31-12-58-44.log'),
    (Join-Path $githubRoot 'robocopy Logs\clean\largerobocopy-clean1-clean.log')
)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "Getting permissions for folders in: $folder" -ForegroundColor Green

        Get-ChildItem -Path $folder -Directory -Recurse | ForEach-Object {
            icacls $_.FullName | Out-File $outputFile -Append
        }
    } else {
        Write-Host "The specified folder path does not exist: $folder" -ForegroundColor Red
    }
}

notepad $outputFile

foreach ($file in $files) {
    if (Test-Path $file) {
        $lineCount = [System.IO.File]::ReadLines($file) | Measure-Object -Line
        $fileSizeBytes = (Get-Item $file).Length
        $fileSizeMB = [math]::Round($fileSizeBytes / 1MB, 2)
        Write-Host "The log file contains $($lineCount.Lines) lines. Size is $fileSizeMB MB" -ForegroundColor Cyan
    } else {
        Write-Host "The log file does not exist: $file" -ForegroundColor Red
    }
}

