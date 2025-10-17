# Revision : 1.1
# Description : Deploy multiple applications as "Available" to a user collection in Software Center and distribute content to a list of Distribution Points. Rev 1.1
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-14
# Modified Date : 2025-10-14

<#
.SYNOPSIS
Deploy multiple applications as "Available" to a user collection in Software Center and distribute content to specified Distribution Points.

.NOTES
- Requires ConfigurationManager module.
- Idempotent deployment: skips apps already deployed to the target collection.
- Distributes content for each app to each DP provided.
- Shows a summary table at the end.
#>

param(
    [Parameter(Mandatory)]
    [string] $SiteCode,               # e.g. ABC

    [Parameter(Mandatory)]
    [string] $SiteServer,             # e.g. cm01.contoso.com

    [Parameter(Mandatory)]
    [string] $UserCollectionName,     # e.g. "All Marketing Users"

    [Parameter(Mandatory)]
    [string[]] $ApplicationNames,     # e.g. "7-Zip","VLC","Notepad++"

    [Parameter(Mandatory)]
    [string[]] $DistributionPoints,   # e.g. "DP01.contoso.com","DP02.contoso.com"

    [switch] $WhatIf
)

# --- Load module & connect to site drive ---
try {
    if (-not (Get-Module -Name ConfigurationManager -ListAvailable)) {
        $cmPath = Join-Path $env:SMS_ADMIN_UI_PATH "..\ConfigurationManager.psd1"
        if (Test-Path $cmPath) { Import-Module $cmPath -ErrorAction Stop }
        else { Import-Module ConfigurationManager -ErrorAction Stop }
    }
    else {
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

# Switch to site drive
Set-Location -Path ("$SiteCode :")

# --- Validate collection ---
$collection = Get-CMCollection -Name $UserCollectionName -ErrorAction SilentlyContinue
if (-not $collection) { throw "Collection '$UserCollectionName' not found." }

# --- Helper : Distribute content for one app to all DPs ---
function Invoke-ContentDistribution {
    param(
        [Parameter(Mandatory)][Microsoft.ConfigurationManagement.ApplicationManagement.Application] $App,
        [Parameter(Mandatory)][string[]] $DPs,
        [switch] $WhatIf
    )
    $distResults = @()
    foreach ($dp in $DPs) {
        try {
            if ($WhatIf) {
                Start-CMContentDistribution -ApplicationName $App.LocalizedDisplayName -DistributionPointName $dp -WhatIf
                $distResults += [pscustomobject]@{ Application = $App.LocalizedDisplayName; DistributionPoint = $dp; DistributionStatus = "WhatIf - would distribute" }
            }
            else {
                Start-CMContentDistribution -ApplicationName $App.LocalizedDisplayName -DistributionPointName $dp | Out-Null
                $distResults += [pscustomobject]@{ Application = $App.LocalizedDisplayName; DistributionPoint = $dp; DistributionStatus = "Distributed" }
            }
        }
        catch {
            $distResults += [pscustomobject]@{ Application = $App.LocalizedDisplayName; DistributionPoint = $dp; DistributionStatus = "Failed - $($_.Exception.Message)" }
        }
    }
    return $distResults
}

# --- Deploy loop ---
$results = @()
$distSummary = @()

foreach ($appName in $ApplicationNames) {
    $app = Get-CMApplication -Name $appName -ErrorAction SilentlyContinue
    if (-not $app) {
        $results += [pscustomobject]@{ Application = $appName; Status = "Skipped - app not found" }
        continue
    }

    # Distribute content to each specified DP for this app (using the same $app variable)
    $distSummary += Invoke-ContentDistribution -App $app -DPs $DistributionPoints -WhatIf:$WhatIf

    # Skip deployment if already deployed to this collection
    $existing = Get-CMApplicationDeployment -Name $app.LocalizedDisplayName -ErrorAction SilentlyContinue |
                Where-Object { $_.CollectionName -eq $UserCollectionName }

    if ($existing) {
        $results += [pscustomobject]@{ Application = $appName; Status = "Skipped - already deployed" }
        continue
    }

    $params = @{
        Name               = $app.LocalizedDisplayName
        CollectionName     = $UserCollectionName
        DeployAction       = 'Install'
        DeployPurpose      = 'Available'
        AvailableDateTime  = (Get-Date)
        TimeBaseOn         = 'LocalTime'
        UserNotification   = 'DisplaySoftwareCenterOnly'
        ErrorAction        = 'Stop'
        # Note : We explicitly distribute via Start-CMContentDistribution above for per-DP control
        # -DistributeContent is intentionally not used here
    }

    try {
        if ($WhatIf) {
            New-CMApplicationDeployment @params -WhatIf
            $results += [pscustomobject]@{ Application = $appName; Status = "WhatIf - would deploy" }
        }
        else {
            New-CMApplicationDeployment @params | Out-Null
            $results += [pscustomobject]@{ Application = $appName; Status = "Deployed" }
        }
    }
    catch {
        $results += [pscustomobject]@{ Application = $appName; Status = "Failed - $($_.Exception.Message)" }
    }
}

# --- Report ---
Write-Host "`nDeployment Summary for $UserCollectionName :" -ForegroundColor Cyan
$results | Sort-Object Status, Application | Format-Table -AutoSize

Write-Host "`nContent Distribution Summary :" -ForegroundColor Cyan
$distSummary | Sort-Object Application, DistributionPoint | Format-Table -AutoSize

# --- Example usage ---
<#
$apps = (Import-Csv .\apps.csv).Name
$dpList = @(
    "ashut01.middough.local",
    "bufut01.middough.local",
    "chiut01.middough.local",
    "nwiut01.middough.local",
    "pitut01.middough.local",
    "tolut01.middough.local",
    "clesccm.middough.local"
)
.\Deploy-AppsToUserCollection.ps1 -SiteCode MTS -SiteServer clesccm.middough.local -UserCollectionName "view all apps" -ApplicationNames $apps -DistributionPoints $dpList

# WhatIf example
.\Deploy-AppsToUserCollection.ps1 -SiteCode ABC -SiteServer cm01.contoso.com -UserCollectionName "All Marketing Users" -ApplicationNames $apps -DistributionPoints $dpList -WhatIf
#>
