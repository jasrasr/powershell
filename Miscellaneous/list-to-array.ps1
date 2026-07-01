# Revision : 1.2
# Description : Save a string list into an array-formatted PowerShell file, removing trailing comma on the last item, and append multiple foreach loop examples
# Author : Jason Lamb
# Created Date : 2025-07-23
# Modified Date : 2025-09-12

$datetime = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "$psexports\path-array-output-$datetime.ps1"

$textToArray = @'
\\ALTFS01V\F$\Apps
\\ALTFS01V\F$\Apps\00_Altronic _Apps_Stage
\\ALTFS01V\F$\Apps\00_Altronic_Panels_Apps_Stage
\\ALTFS01V\F$\Apps\01_Altronic_Apps_Production
\\ALTFS01V\F$\Apps\01_Altronic_Panels_App_Prod
\\ALTFS01V\F$\Common
\\ALTFS01V\F$\Common\K Neuhaus
\\ALTFS01V\F$\Common\Paul Olbrych\Management Review Info
\\ALTFS01V\F$\Common\RISK Management
\\ALTFS01V\F$\Common\wagner
\\ALTFS01V\F$\Groups
\\ALTFS01V\F$\Groups\$SPEA
\\ALTFS01V\F$\Groups\Accounting
\\ALTFS01V\F$\Groups\Administration
\\ALTFS01V\F$\Groups\DxDesigner
\\ALTFS01V\F$\Groups\Engineering
\\ALTFS01V\F$\Groups\Engineering Managers
\\ALTFS01V\F$\Groups\Engineering\EngFax
\\ALTFS01V\F$\Groups\EngineSolutions
\\ALTFS01V\F$\Groups\ep
\\ALTFS01V\F$\Groups\HR
\\ALTFS01V\F$\Groups\IT
\\ALTFS01V\F$\Groups\Logistics
\\ALTFS01V\F$\Groups\MachineShop
\\ALTFS01V\F$\Groups\Manufacturing
\\ALTFS01V\F$\Groups\Manufacturing\CutNClinch
\\ALTFS01V\F$\Groups\Manufacturing\Production Logs\SAFI2
\\ALTFS01V\F$\Groups\Manufacturing\SMT Live Notes
\\ALTFS01V\F$\Groups\Manufacturing\SMT Profiles
\\ALTFS01V\F$\Groups\Methods
\\ALTFS01V\F$\Groups\Order Processing
\\ALTFS01V\F$\Groups\Panel_Engineering
\\ALTFS01V\F$\Groups\Panel_Engineering\acaddwgs
\\ALTFS01V\F$\Groups\Panel_QC
\\ALTFS01V\F$\Groups\Panel_QC\Firmware
\\ALTFS01V\F$\Groups\Panel_Sales
\\ALTFS01V\F$\Groups\Panel_Supply_Chain
\\ALTFS01V\F$\Groups\Panels
\\ALTFS01V\F$\Groups\Purchasing
\\ALTFS01V\F$\Groups\QA and Test Engineering
\\ALTFS01V\F$\Groups\QC
\\ALTFS01V\F$\Groups\QC\DigitalQC Log Sheets
\\ALTFS01V\F$\Groups\Safety
\\ALTFS01V\F$\Groups\SAKI_data
\\ALTFS01V\F$\Groups\Sales
\\ALTFS01V\F$\Teams
\\ALTFS01V\F$\Teams\AltEngShared
\\ALTFS01V\F$\Teams\Altronic Building Plans
\\ALTFS01V\F$\Teams\Altronic Management Team
\\ALTFS01V\F$\Teams\Artworks
\\ALTFS01V\F$\Teams\Bartender Labels
\\ALTFS01V\F$\Teams\Coil Files
\\ALTFS01V\F$\Teams\Compliance
\\ALTFS01V\F$\Teams\Contracts
\\ALTFS01V\F$\Teams\DataFlo Archives
\\ALTFS01V\F$\Teams\Digital Signage
\\ALTFS01V\F$\Teams\DIV Engine Altronic
\\ALTFS01V\F$\Teams\DMP Security
\\ALTFS01V\F$\Teams\Document Control
\\ALTFS01V\F$\Teams\Drawings
\\ALTFS01V\F$\Teams\Drawings\DESKTOP\ALT\Label Artwork
\\ALTFS01V\F$\Teams\Engineering Documents
\\ALTFS01V\F$\Teams\Engineering Documents\Altronic
\\ALTFS01V\F$\Teams\Engineering Documents\Panels
\\ALTFS01V\F$\Teams\Engineering Project Management Snap Shot
\\ALTFS01V\F$\Teams\Environmental Management
\\ALTFS01V\F$\Teams\EverAlert Clocks
\\ALTFS01V\F$\Teams\Export Documentation
\\ALTFS01V\F$\Teams\Flash-Memories
\\ALTFS01V\F$\Teams\HRTrainingVideos
\\ALTFS01V\F$\Teams\Internal Audit
\\ALTFS01V\F$\Teams\Invoices-fromShipping
\\ALTFS01V\F$\Teams\Invoices-Processed
\\ALTFS01V\F$\Teams\ISO
\\ALTFS01V\F$\Teams\ISO-9001_2025
\\ALTFS01V\F$\Teams\Management Review Info
\\ALTFS01V\F$\Teams\NVR Video
\\ALTFS01V\F$\Teams\OFI Process and List
\\ALTFS01V\F$\Teams\Operations Team Meeting MoM
\\ALTFS01V\F$\Teams\Panel Documentation
\\ALTFS01V\F$\Teams\Panel Pictures
\\ALTFS01V\F$\Teams\Panel Shop
\\ALTFS01V\F$\Teams\PDFdrawingsSAP
\\ALTFS01V\F$\Teams\PFD and Turtles
\\ALTFS01V\F$\Teams\PPAP-APQP_SR
\\ALTFS01V\F$\Teams\Production Planning
\\ALTFS01V\F$\Teams\RACI
\\ALTFS01V\F$\Teams\REPAIR
\\ALTFS01V\F$\Teams\RISK Management
\\ALTFS01V\F$\Teams\RISK Management\Action Updates
\\ALTFS01V\F$\Teams\RISK Management\Overall Risk Logs
\\ALTFS01V\F$\Teams\Safety
\\ALTFS01V\F$\Teams\Sales CAD Drawings
\\ALTFS01V\F$\Teams\Scanned Shipments
\\ALTFS01V\F$\Teams\Scans
\\ALTFS01V\F$\Teams\Scans\Invoices
\\ALTFS01V\F$\Teams\Scans\Receipts
\\ALTFS01V\F$\Teams\Scans\ScanSnapRec
\\ALTFS01V\F$\Teams\Scans\ScanSnapRec1110
\\ALTFS01V\F$\Teams\Scans\ScanSnapRec1110\ScanSnapRec
\\ALTFS01V\F$\Teams\SMT
\\ALTFS01V\F$\Teams\SMT\SMT MSL Tracking
\\ALTFS01V\F$\Teams\Vendor Audits
\\ALTFS01V\F$\Teams\Vendor Change Request
\\ALTFS01V\F$\Teams\Vendor FAITs
\\ALTFS01V\F$\Teams\Vendor Gray Market
\\ALTFS01V\F$\Teams\Vendor Issues
\\ALTFS01V\F$\Teams\Vendor List and Qual Forms
\\ALTFS01V\F$\Teams\WaterJet
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
