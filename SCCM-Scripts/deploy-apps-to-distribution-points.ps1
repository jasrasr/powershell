# Revision : 1.3
# Description : Distribute multiple applications to a list of Distribution Points only (no deployment). Fix Set-Location to CMSite drive and trim SiteCode. Rev 1.3
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-14
# Modified Date : 2025-10-17

param(
    [Parameter(Mandatory)]
    [string] $SiteCode,             # e.g. MTS

    [Parameter(Mandatory)]
    [string] $SiteServer,           # e.g. clesccm.middough.local

    [Parameter(Mandatory)]
    [string[]] $ApplicationNames,   # e.g. "7-Zip","VLC","Notepad++"

    [Parameter(Mandatory)]
    [string[]] $DistributionPoints, # e.g. "ASHUT01.middough.local","BUFUT01.middough.local"

    [switch] $WhatIf
)

# --- Normalize inputs ---
$SiteCode = $SiteCode.Trim()

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

# Switch to site drive (NO SPACE before the colon in a drive path)
Set-Location -Path ("${SiteCode}:")

# --- Distribute content ---
$results = @()

foreach ($appName in $ApplicationNames) {
    $app = Get-CMApplication -Name $appName -ErrorAction SilentlyContinue
    if (-not $app) {
        $results += [pscustomobject]@{ Application = $appName; DistributionPoint = ""; Status = "Skipped - app not found" }
        continue
    }

    foreach ($dp in $DistributionPoints) {
        try {
            if ($WhatIf) {
                Start-CMContentDistribution -ApplicationName $app.LocalizedDisplayName -DistributionPointName $dp -WhatIf
                $results += [pscustomobject]@{ Application = $app.LocalizedDisplayName; DistributionPoint = $dp; Status = "WhatIf - would distribute" }
            }
            else {
                Start-CMContentDistribution -ApplicationName $app.LocalizedDisplayName -DistributionPointName $dp | Out-Null
                $results += [pscustomobject]@{ Application = $app.LocalizedDisplayName; DistributionPoint = $dp; Status = "Distributed" }
            }
        }
        catch {
            $results += [pscustomobject]@{ Application = $app.LocalizedDisplayName; DistributionPoint = $dp; Status = "Failed - $($_.Exception.Message)" }
        }
    }
}

# --- Report ---
Write-Host "`nContent Distribution Summary :" -ForegroundColor Cyan
$results | Sort-Object Application, DistributionPoint | Format-Table -AutoSize

# --- Example usage ---
<#
$apps = (Import-Csv .\apps.csv).Name
$dpList = @(
    "ASHUT01.middough.local",
    "BUFUT01.middough.local",
    "CHIPT01.middough.local"
)

# Distribute directly
.\deploy-apps-to-distribution-points.ps1 -SiteCode MTS -SiteServer clesccm.middough.local -ApplicationNames $apps -DistributionPoints $dpList

# WhatIf example
.\deploy-apps-to-distribution-points.ps1 -SiteCode MTS -SiteServer clesccm.middough.local -ApplicationNames $apps -DistributionPoints $dpList -WhatIf
#>
