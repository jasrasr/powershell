<# 
.SYNOPSIS
Deploy multiple applications as "Available" to a user collection in Software Center.

.NOTES
- Requires ConfigurationManager module.
- Idempotent: skips apps already deployed to the target collection.
- Shows a summary table at the end.
#>

param(
    [Parameter(Mandatory)]
    [string] $SiteCode,             # e.g. ABC

    [Parameter(Mandatory)]
    [string] $SiteServer,           # e.g. cm01.contoso.com

    [Parameter(Mandatory)]
    [string] $UserCollectionName,   # e.g. "All Marketing Users"

    [Parameter(Mandatory)]
    [string[]] $ApplicationNames,   # e.g. "7-Zip","VLC","Notepad++"

    [switch] $WhatIf
)

# --- Load module & connect to site drive ---
try {
    if (-not (Get-Module -Name ConfigurationManager -ListAvailable)) {
        # fall back to console path if needed
        $cmPath = Join-Path $env:SMS_ADMIN_UI_PATH "..\ConfigurationManager.psd1"
        if (Test-Path $cmPath) { Import-Module $cmPath -ErrorAction Stop }
        else { Import-Module ConfigurationManager -ErrorAction Stop }
    } else {
        Import-Module ConfigurationManager -ErrorAction Stop
    }
}
catch {
    throw "Could not import the ConfigurationManager module. $_"
}

# Create PSDrive if it doesn't exist
if (-not (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $SiteServer -Description "Primary site" | Out-Null
}

# Switch to site drive (avoid writing $var: directly per your style note)
Set-Location -Path ($SiteCode + ":")

# --- Validate collection (user collection recommended) ---
$collection = Get-CMCollection -Name $UserCollectionName -ErrorAction SilentlyContinue
if (-not $collection) { throw "Collection '$UserCollectionName' not found." }

# --- Deploy loop ---
$results = @()
foreach ($appName in $ApplicationNames) {
    $app = Get-CMApplication -Name $appName -ErrorAction SilentlyContinue
    if (-not $app) {
        $results += [pscustomobject]@{Application=$appName; Status="Skipped - app not found"}
        continue
    }

    # Skip if already deployed to this collection
    $existing = Get-CMApplicationDeployment -Name $app.LocalizedDisplayName -ErrorAction SilentlyContinue |
                Where-Object { $_.CollectionName -eq $UserCollectionName }

    if ($existing) {
        $results += [pscustomobject]@{Application=$appName; Status="Skipped - already deployed"}
        continue
    }

    $params = @{
        Name                 = $app.LocalizedDisplayName
        CollectionName       = $UserCollectionName
        DeployAction         = 'Install'                 # Install or Uninstall
        DeployPurpose        = 'Available'               # Available = Software Center
        AvailableDateTime    = (Get-Date)
        TimeBaseOn           = 'LocalTime'
        UserNotification     = 'DisplaySoftwareCenterOnly'
        # DistributeContent  = $true                     # uncomment if you want auto-distribution
        # DistributeCollectionName = $UserCollectionName # optional, see docs
        ErrorAction          = 'Stop'
    }

    try {
        if ($WhatIf) { New-CMApplicationDeployment @params -WhatIf }
        else { New-CMApplicationDeployment @params | Out-Null }
        $results += [pscustomobject]@{Application=$appName; Status=($WhatIf ? "WhatIf - would deploy" : "Deployed")}
    }
    catch {
        $results += [pscustomobject]@{Application=$appName; Status="Failed - $($_.Exception.Message)"}
    }
}

# --- Report ---
$results | Sort-Object Status, Application | Format-Table -AutoSize

<#
example use
$apps = (Import-Csv .\apps.csv).Name
.\Deploy-AppsToUserCollection.ps1 -SiteCode ABC -SiteServer server.domain.local -UserCollectionName "All Marketing Users" -ApplicationNames $apps
#>