# ============================================================
# Filename : Add-TeamsBlockedDomain.ps1
# Revision : 1.1
# Description : Prompt for one or more comma-separated domains 
#               and add them to Microsoft Teams BlockedDomains 
#               if not already present. Repeats prompt until user
#               chooses to stop. Includes module install,
#               import, connection check, validation, reporting,
#               and final summary output.
# Author : Jason Lamb (with help from AI)
# Created Date : 2026-02-19
# Modified Date : 2026-02-19
# Changelog :
# 1.0 Initial release - multi-domain support, validation, reporting
# 1.1 Added repeat prompt loop to allow multiple entry cycles
# ============================================================


# ------------------------------------------------------------
# Ensure MicrosoftTeams module is installed
# ------------------------------------------------------------
$moduleName = "MicrosoftTeams"

if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    Write-Host "MicrosoftTeams module not found. Installing..."
    Install-Module $moduleName -Scope CurrentUser -Force -AllowClobber
}
else {
    Write-Host "MicrosoftTeams module already installed."
}


# ------------------------------------------------------------
# Import module
# ------------------------------------------------------------
if (-not (Get-Module -Name $moduleName)) {
    Import-Module $moduleName
    Write-Host "MicrosoftTeams module imported."
}


# ------------------------------------------------------------
# Ensure connection
# ------------------------------------------------------------
try {
    $null = Get-CsTenantFederationConfiguration -ErrorAction Stop
    Write-Host "Already connected to Microsoft Teams."
}
catch {
    Write-Host "Connecting to Microsoft Teams..."
    Connect-MicrosoftTeams
}


# ------------------------------------------------------------
# Main loop
# ------------------------------------------------------------
$continue = $true

while ($continue) {

    $inputDomains = Read-Host "Enter domain(s) to block separated by commas (or press Enter to stop)"

    if ([string]::IsNullOrWhiteSpace($inputDomains)) {
        break
    }

    # Parse
    $newDomains = $inputDomains -split ',' |
                  ForEach-Object { $_.Trim().ToLower() } |
                  Where-Object { $_ -ne '' }

    $domainPattern = '^[a-z0-9.-]+\.[a-z]{2,}$'

    $validDomains = @()
    $invalidDomains = @()

    foreach ($domain in $newDomains) {
        if ($domain -match $domainPattern) {
            $validDomains += $domain
        }
        else {
            $invalidDomains += $domain
        }
    }

    if ($invalidDomains.Count -gt 0) {
        Write-Host ""
        Write-Host "Invalid domain format detected:"
        $invalidDomains | ForEach-Object { Write-Host $_ }
        Write-Host "No changes were made."
        continue
    }

    # Get current list
    $currentConfig = Get-CsTenantFederationConfiguration
    $currentBlocked = $currentConfig.BlockedDomains.Domain

    # Determine additions
    $toAdd = $validDomains | Where-Object { $currentBlocked -notcontains $_ }

    if ($toAdd.Count -eq 0) {
        Write-Host ""
        Write-Host "STATUS : No new domains needed. All entered domains are already blocked."
    }
    else {
        $updatedList = $currentBlocked + $toAdd | Sort-Object -Unique
        Set-CsTenantFederationConfiguration -BlockedDomains $updatedList

        Write-Host ""
        Write-Host "STATUS : Added the following domain(s):"
        $toAdd | ForEach-Object { Write-Host $_ }
    }

    Write-Host ""
    $response = Read-Host "Add another domain? (Y/N)"

    if ($response.ToUpper() -ne "Y") {
        $continue = $false
    }

}


# ------------------------------------------------------------
# Final Report
# ------------------------------------------------------------
Write-Host ""
Write-Host "========== CURRENT BLOCKED DOMAINS =========="

$finalList = (Get-CsTenantFederationConfiguration).BlockedDomains.Domain |
             Sort-Object

$finalList | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "Total Blocked Domains : $($finalList.Count)"
