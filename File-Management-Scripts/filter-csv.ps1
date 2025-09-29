# Revision : 1.2
# Description : Stream-filter a very large CSV and remove rows containing the cell "List Folder Contents". Saves output in the SAME folder with "-filtered" suffix and reports how many lines were removed. Rev 1.2
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-29
# Modified Date : 2025-09-29

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$InputCsv,

    [string]$FilterText = 'List Folder Contents',

    [switch]$PreserveHeader = $true
)

$inputFolder = Split-Path $InputCsv
$inputName   = [System.IO.Path]::GetFileNameWithoutExtension($InputCsv)
$inputExt    = [System.IO.Path]::GetExtension($InputCsv)
$OutputCsv   = Join-Path $inputFolder "$inputName-filtered$inputExt"

$linesTotal   = 0
$linesKept    = 0
$linesRemoved = 0

$encoding = New-Object System.Text.UTF8Encoding($false)
$cmp      = [System.StringComparison]::OrdinalIgnoreCase
$needle   = '"' + $FilterText + '"'

$reader = [System.IO.StreamReader]::new($InputCsv)
$writer = [System.IO.StreamWriter]::new($OutputCsv, $false, $encoding)
try {
    $isFirstLine = $true
    while (-not $reader.EndOfStream) {
        $line = $reader.ReadLine()
        $linesTotal++

        if ($isFirstLine -and $PreserveHeader) {
            $writer.WriteLine($line)
            $linesKept++
            $isFirstLine = $false
            continue
        }
        $isFirstLine = $false

        if ($line.IndexOf($needle, $cmp) -ge 0) {
            $linesRemoved++
            continue
        } else {
            $writer.WriteLine($line)
            $linesKept++
        }
    }
}
finally {
    $writer.Flush()
    $writer.Dispose()
    $reader.Dispose()
}

Write-Host "Input file $InputCsv : processed $linesTotal lines"
Write-Host "Output file $OutputCsv : wrote $linesKept lines"
Write-Host "Filtered value $FilterText : removed $linesRemoved lines"

# --- Example run for your file ---
# .\filter-csv.ps1 -InputCsv 'C:\Temp\csv-split-staging\NTFS Permissions Report R drive 092525 CSV.csv'
