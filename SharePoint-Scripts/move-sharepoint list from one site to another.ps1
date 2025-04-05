  Install-Module PnP.PowerShell
import-Module PnP.PowerShell

  $SourceSiteURL = "https://middough.sharepoint.com/sites/Operations"
Connect-PnPOnline -Url $SourceSiteURL -Interactive

Register-PnPEntraIDAppForInteractiveLogin -ApplicationName "PnP PowerShell App" -Tenant middough.onmicrosoft.com -Interactive


$ListName = "Software License to Build Numbers" #https://middough.sharepoint.com/sites/Operations/Lists/Software%20License%20to%20Build%20Numbers/AllItems.aspx
$TemplateFile = "C:\Temp\Software-License-to-Build-Numbers.xml"

# Export the list schema
Get-PnPSiteTemplate -Out $TemplateFile -ListsToExtract $ListName -Handlers Lists

# Include data in the template
Add-PnPDataRowsToSiteTemplate -Path $TemplateFile -List $ListName


$DestinationSiteURL = "https://middough.sharepoint.com/sites/InformationTechnology" #https://middough.sharepoint.com/sites/InformationTechnology/Lists/Middough%20Software%20Updates/AllItems.aspx?as=json
Connect-PnPOnline -Url $DestinationSiteURL -Interactive


# Apply the template to create the list with data
Invoke-PnPSiteTemplate -Path $TemplateFile

###

# Revision 2

# Parameters
$SourceSiteURL = "https://middough.sharepoint.com/sites/Operations"
$DestinationSiteURL = "https://middough.sharepoint.com/sites/InformationTechnology"
$ListName = "Software License to Build Numbers"
$TemplateFile = "$env:TEMP\ListTemplate.xml"

# Connect to the Source Site
Connect-PnPOnline -Url $SourceSiteURL -ClientId "your-client-id" -Tenant "middough.onmicrosoft.com" -Interactive

# Export the List Structure
Get-PnPSiteTemplate -Out $TemplateFile -ListsToExtract $ListName -Handlers Lists

# Include Data in the Template
Add-PnPDataRowsToSiteTemplate -Path $TemplateFile -List $ListName

# Connect to the Destination Site
Connect-PnPOnline -Url $DestinationSiteURL -ClientId "your-client-id" -Tenant "yourtenant.onmicrosoft.com" -Interactive

# Apply the Template to Create the List with Data
Invoke-PnPSiteTemplate -Path $TemplateFile
