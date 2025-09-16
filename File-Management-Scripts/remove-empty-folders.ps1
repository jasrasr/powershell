# Revision : 1.8
# Description : Fast removal of empty subfolders using .NET enumeration (deepest-first) with progress bar and runtime timestamps. Default WhatIf; use -Delete to actually remove. Logs to parent.  Rev 1.8
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-12
# Modified Date : 2025-09-12

[CmdletBinding()]
param(
    [string] $TargetPath = "\\server\folder",
    [switch] $Delete
)

if (-not (Test-Path -LiteralPath $TargetPath)) {
    Write-Host "Target path does not exist : $TargetPath" -ForegroundColor Red
    exit 1
}

$startTime = Get-Date
$timestamp = $startTime.ToString("yyyyMMdd-HHmmss")
$logFile   = Join-Path -Path $TargetPath -ChildPath "RemoveEmptyFolders-$timestamp.log"
$mode      = if ($Delete) { '--- Actual removal run ---' } else { '--- WhatIf run ---' }

"$mode $startTime" | Out-File -FilePath $logFile -Encoding UTF8 -Force
"TargetPath : $TargetPath" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Start Time : $startTime"  | Out-File -FilePath $logFile -Encoding UTF8 -Append
""                         | Out-File -FilePath $logFile -Encoding UTF8 -Append

# Default = test unless -Delete provided
$whatIf = -not $Delete

# Enumerate directories (faster than Get-ChildItem) and sort deepest-first
$allDirs = [System.IO.Directory]::EnumerateDirectories($TargetPath, '*', [System.IO.SearchOption]::AllDirectories) | ForEach-Object { $_ }
$dirsByDepthDesc = $allDirs | Sort-Object { ($_ -split '[\\/]').Count } -Descending

$removed = 0
$checked = 0
$total   = $dirsByDepthDesc.Count
$index   = 0

foreach ($dir in $dirsByDepthDesc) {
    $index++
    $checked++

    # Progress
    $percent = if ($total -gt 0) { [int](($index / $total) * 100) } else { 100 }
    Write-Progress -Activity "Scanning and removing empty folders" -Status "Processing $index of $total" -PercentComplete $percent -CurrentOperation $dir

    # quick emptiness check
    $enum = [System.IO.Directory]::EnumerateFileSystemEntries($dir).GetEnumerator()
    $hasChild = $false
    if ($enum.MoveNext()) { $hasChild = $true }
    $enum.Dispose()

    if (-not $hasChild) {
        $dir | Out-File -FilePath $logFile -Encoding UTF8 -Append
        try {
            Remove-Item -LiteralPath $dir -Force -WhatIf:$whatIf -ErrorAction Stop -Confirm:$false
            $removed++
        }
        catch {
            "ERROR removing : $dir  Error : $($_.Exception.Message)" | Out-File -FilePath $logFile -Encoding UTF8 -Append
            Write-Host "Error on $dir : $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

Write-Progress -Activity "Scanning and removing empty folders" -Completed

$endTime = Get-Date
$duration = New-TimeSpan -Start $startTime -End $endTime

"" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"---- Summary ----" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Mode : $mode"                           | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Start Time : $startTime"                | Out-File -FilePath $logFile -Encoding UTF8 -Append
"End Time : $endTime"                    | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Elapsed : $($duration.ToString())"      | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Directories checked : $checked"         | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Folders removed/logged : $removed"      | Out-File -FilePath $logFile -Encoding UTF8 -Append
"Log file : $logFile"                    | Out-File -FilePath $logFile -Encoding UTF8 -Append

Write-Host "Mode : $mode"
Write-Host "TargetPath : $TargetPath"
Write-Host "Start Time : $startTime"
Write-Host "End Time : $endTime"
Write-Host "Elapsed : $($duration.ToString())"
Write-Host "Directories checked : $checked"
Write-Host "Folders removed/logged : $removed"
Write-Host "Log file : $logFile" -ForegroundColor Green

# Usage:
#   Test (default WhatIf) : .\Remove-EmptyFolders.ps1 -TargetPath "\\server\share\path\IFD"
#   Actual removal        : .\Remove-EmptyFolders.ps1 -TargetPath "\\server\share\path\IFD" -Delete
