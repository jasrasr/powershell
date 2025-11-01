# Revision : 1.2
# Description : Save a string list into an array-formatted PowerShell file, removing trailing comma on the last item, and append multiple foreach loop examples
# Author : Jason Lamb
# Created Date : 2025-07-23
# Modified Date : 2025-09-12

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "C:\temp\powershell-exports\path-array-output-$datetime.ps1"

$textToArray = @'
robert.bordon@middough.com
donavynn.hayes@middough.com
joseph.kalic@middough.com
joseph.khater@middough.com
nikolas.santarelli@middough.com
mark.custer@middough.com
kyle.cussen@middough.com
brian.molnar@middough.com
jason.thompson@middough.com
chip.hoppel@middough.com
thomas.popp@middough.com
richard.genser@middough.com
richard.johnson@middough.com
jeffery.kuzma@middough.com
david.mayares@middough.com
nathan.schuerman@middough.com
benjamin.thompson@middough.com
michael.roberts@middough.com
christopher.ryan@middough.com
michael.smith@middough.com
ian.sarata@middough.com
nicholas.scibetta@middough.com
brad.malone@middough.com
harold.kropp@middough.com
james.carns@middough.com
james.weinheimer@middough.com
william.winter@middough.com
jimmy.wood@middough.com
rodney.roth@middough.com
james.weinheimer@middough.com
tim.thole@middough.com
kauveh.aynafshar@middough.com
matthew.hammond@middough.com
barbara.palmer@middough.com
austin.lackritz@middough.com
drew.zimmerman@middough.com
haley.mason@middough.com
george.rowe@middough.com
jim.johnson@middough.com
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
code $outputPath
