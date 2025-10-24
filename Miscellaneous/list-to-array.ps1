# Revision : 1.2
# Description : Save a string list into an array-formatted PowerShell file, removing trailing comma on the last item, and append multiple foreach loop examples
# Author : Jason Lamb
# Created Date : 2025-07-23
# Modified Date : 2025-09-12

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "C:\temp\powershell-exports\path-array-output-$datetime.ps1"

$textToArray = @'
\\middough.local\corp\data\archive\Comm_metals.CLE\CML2001\10.0 Cad\10.5 Wrk Dwgs\Structural
\\middough.local\corp\data\archive\Abbvie.CHI\ABV1415\10.0 Cad
\\middough.local\corp\data\archive\Ecolab\ECL2164\10.0 Cad
\\middough.local\corp\data\archive\United_st_steel.IND\USS2162\10.0 Cad\10.6 Discipline\Structural
\\middough.local\corp\data\archive\Cargill\CAG2204\10.0 Cad\10.5 Wrk Dwgs\100 - Structural
\\middough.local\corp\data\archive\Cargill.CHI\CAG1113\10.0 Cad\10.10 Laser Scan Data\Feedhouse
\\middough.local\corp\data\archive\Cleve-cliffs\CNR2155\10.0 Cad\10.5 Wrk Dwgs\Piping
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20074\10.0 Cad\10.5 Wrk Dwgs\Mechanical\BQ20074
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20068\10.0 Cad\10.5 Wrk Dwgs\Mechanical\BQ20068
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20027\10.0 Cad\10.5 Wrk Dwgs\Mechanical
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20089\10.0 Cad\10.5 Wrk Dwgs\Mechanical\BQ20089
\\middough.local\corp\data\archive\BP_Oil\2022\BQ22051\10.0 Cad\10.5 Wrk Dwgs\PIPING
\\middough.local\corp\data\archive\BP_Oil\2021\BQ21006\10.0 Cad\10.5 Wrk Dwgs\Mechanical
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20029\10.0 Cad\10.5 Wrk Dwgs\Mechanical
\\middough.local\corp\data\archive\BP_Oil\2022\BF22003\10.0 Cad\10.5 Wrk Dwgs\Mechanical
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20015\10.0 Cad\10.5 Wrk Dwgs\Mechanical\BQ20015
\\middough.local\corp\data\archive\BP_Oil\2020\BQ20083\10.0 Cad\10.5 Wrk Dwgs\Mechanical\BQ20083B
\\middough.local\corp\data\archive\MAP.ASH\2020_projects\MAP2027\10.0 Cad\10.5 Wrk Dwgs
\\middough.local\corp\data\archive\Blanchard_refin.HOU\BRC1512\10.0 Cad\10.7 Scanning
\\middough.local\corp\data\archive\HP_Hood_LLC.CHI\HPH2003\10.0 Cad
\\middough.local\corp\data\archive\Delaware_city.PHL\_Gen
\\middough.local\corp\data\archive\Delaware_city.PHL\DCR1601\10.0 Cad
\\middough.local\corp\data\archive\ADM\ADM2101\10.0 Cad
\\middough.local\corp\data\archive\Basf\ENG1840\10.0 Cad\10.5 Wrk Dwgs
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
