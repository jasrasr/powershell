# Revision : 1.2
# Description : Save a string list into an array-formatted PowerShell file, removing trailing comma on the last item, and append multiple foreach loop examples
# Author : Jason Lamb
# Created Date : 2025-07-23
# Modified Date : 2025-09-12

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "C:\temp\powershell-exports\path-array-output-$datetime.ps1"

$textToArray = @'
alpha
beta
charlie
'@ -split "`r?`n"

New-Item -ItemType File -Path $outputPath -Force | Out-Null

# Start array declaration
Add-Content -Path $outputPath -Value '$textToArray = @('

# Add each item to the array, no trailing comma on last
for ($i = 0; $i -lt $textToArray.Count; $i++) {
    $line = '    "' + $textToArray[$i] + '"'
    if ($i -lt ($textToArray.Count - 1)) {
        $line += ','
    }
    Add-Content -Path $outputPath -Value $line
}

# Close array
Add-Content -Path $outputPath -Value ')'
Add-Content -Path $outputPath -Value ''

# Append foreach loop #1
Add-Content -Path $outputPath -Value 'foreach ($item in $textToArray) {'
Add-Content -Path $outputPath -Value '    # Do something with $item'
Add-Content -Path $outputPath -Value '    Write-Host "Processing : $item"'
Add-Content -Path $outputPath -Value '}'
Add-Content -Path $outputPath -Value ''

Write-Host "Array output saved to : $outputPath" -ForegroundColor Green
notepad $outputPath
