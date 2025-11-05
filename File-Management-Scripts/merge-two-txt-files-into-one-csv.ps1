# Revision : 1.0
# Description : Merge two TXT files side-by-side into a CSV file without quotes.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-11-04
# Modified Date : 2025-11-04

param(
    [Parameter(Mandatory = $true)]
    [string] $File1,
    [Parameter(Mandatory = $true)]
    [string] $File2,
    [Parameter(Mandatory = $true)]
    [string] $OutputCsv
)

# Read both text files
$f1 = Get-Content $File1
$f2 = Get-Content $File2

# Determine max length (in case one file is longer)
$max = [Math]::Max($f1.Count, $f2.Count)

# Pad missing lines with empty strings to align
$f1 = $f1 + @("" * ($max - $f1.Count))
$f2 = $f2 + @("" * ($max - $f2.Count))

# Start CSV with header row
"File1,File2" | Out-File -FilePath $OutputCsv -Encoding UTF8

# Merge line by line and write without quotes
for ($i = 0; $i -lt $max; $i++) {
    "$($f1[$i]),$($f2[$i])" | Out-File -FilePath $OutputCsv -Append -Encoding UTF8
}

Write-Host "Merged $File1 and $File2 into $OutputCsv successfully."


# example
# .\Merge-Txt-To-Csv.ps1 -File1 "C:\temp\listA.txt" -File2 "C:\temp\listB.txt" -OutputCsv "C:\temp\merged.csv"
