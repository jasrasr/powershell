# Revision : 1.0
# Description : Modify file LastWriteTime (modification date) using PowerShell. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-14
# Modified Date : 2025-10-14

$files =@(
'file1.txt',
'file2.txt'
)
$NewDate  = Get-Date "2025-09-01 08:00:00"  # desired new modification date/time

foreach ($file in $files){

    # -----------------------
    # ACTION
    # -----------------------
    if (Test-Path $file) {
        (Get-Item $file).LastWriteTime = $NewDate
        Write-Host "Updated modification date for $file : $NewDate" -ForegroundColor Green
    } else {
        Write-Host "File not found : $file" -ForegroundColor Red
    }
    # OPTIONAL FOR MULTIPLE FILES
    # add one day for each file iteration
    # $NewDate = $NewDate.AddDays(1)
}
