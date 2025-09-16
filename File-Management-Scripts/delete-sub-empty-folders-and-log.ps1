# Revision : 1.1
# Description : Remove empty folders inside target directory (test with -WhatIf first), log results to same folder  
# Author : Jason Lamb (with help from ChatGPT)  
# Created Date : 2025-09-12  
# Modified Date : 2025-09-12  

$targetPath = "\\server\folder"
$timestamp  = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile    = Join-Path $targetPath "RemoveEmptyFolders-$timestamp.log"

# Find empty folders
$emptyFolders = Get-ChildItem -Path $targetPath -Recurse -Directory |
    Where-Object { -not (Get-ChildItem -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue) }

# Write to log
$emptyFolders.FullName | Out-File -FilePath $logFile -Encoding UTF8 -Force

# Simulate removal
$emptyFolders | Remove-Item -WhatIf

Write-Host "Empty folders logged to $logFile"
Write-Host "Use Remove-Item without -WhatIf to actually delete them."
