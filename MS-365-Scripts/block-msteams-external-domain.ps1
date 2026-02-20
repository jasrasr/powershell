# ============================================================
# Filename : Add-TeamsBlockedDomain.ps1
# Revision : 1.2
# Description : Prompt for one or more comma-separated domains 
#               and add them to Microsoft Teams BlockedDomains 
#               if not already present. Repeats prompt until user
#               stops. Provides per-domain status reporting and
#               final summary output.
# Author : Jason Lamb (with help from AI)
# Created Date : 2026-02-19
# Modified Date : 2026-02-19
# Changelog :
# 1.0 Initial release
# 1.1 Added repeat prompt loop
# 1.2 Restored explicit per-domain STATUS and DOMAIN output
# ============================================================


# ------------------------------------------------------------
# Ensure MicrosoftTeams module is installed
# ------------------------------------------------------------
$moduleName = "MicrosoftTeams"

if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    Write-Host "MicrosoftTeams module not found. Installing..."
    Install-Module $moduleName -Scope CurrentUser -Force -AllowClobber
}

if (-not (Get-Module -Name $moduleName)) {
    Import-Module $moduleName
}


# ------------------------------------------------------------
# Ensure connection
# ------------------------------------------------------------
try {
    $null = Get-CsTenantFederationConfiguration -ErrorAction Stop
}
catch {
    Connect-MicrosoftTeams
}


# ------------------------------------------------------------
# Main loop
# ------------------------------------------------------------
while ($true) {

    $inputDomains = Read-Host "Enter domain(s) to block separated by commas (or press Enter to stop)"

    if ([string]::IsNullOrWhiteSpace($inputDomains)) {
        break
    }

    $newDomains = $inputDomains -split ',' |
                  ForEach-Object { $_.Trim().ToLower() } |
                  Where-Object { $_ -ne '' }

    $domainPattern = '^[a-z0-9.-]+\.[a-z]{2,}$'

    foreach ($domain in $newDomains) {

        if ($domain -notmatch $domainPattern) {
            Write-Host ""
            Write-Host "STATUS : Skipped"
            Write-Host "REASON : Invalid domain format -> $domain"
            continue
        }

        $currentBlocked = (Get-CsTenantFederationConfiguration).BlockedDomains.Domain

        if ($currentBlocked -contains $domain) {

            Write-Host ""
            Write-Host "STATUS : Skipped"
            Write-Host "DOMAIN : $domain already exists in BlockedDomains"

        }
        else {

            $updatedList = $currentBlocked + $domain | Sort-Object -Unique
            Set-CsTenantFederationConfiguration -BlockedDomains $updatedList

            Write-Host ""
            Write-Host "STATUS : Added"
            Write-Host "DOMAIN : $domain successfully added to BlockedDomains"

        }

    }

    Write-Host ""
    $response = Read-Host "Add another domain? (Y/N)"

    if ($response.ToUpper() -ne "Y") {
        break
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

Write-Host "Total Blocked Domains : $($finalList.Count)"
