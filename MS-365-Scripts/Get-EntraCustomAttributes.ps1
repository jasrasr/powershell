# Filename: Get-EntraCustomAttributes.ps1
# Revision : 1.2
# Description : Retrieve all custom attributes (1-15) for users matching a specified UPN domain from Entra and export to CSV
# Author : Jason Lamb
# Created Date : 2025-04-01
# Modified Date : 2026-04-01
# Changelog :
# 1.0 initial release
# 1.1 added module install/import checks and Graph connection checks, no disconnect on exit
# 1.2 made domain configurable via parameter for public use

param(
    [Parameter(Mandatory = $true)]
    [string]$Domain
)

# Normalize domain — strip leading @ if provided
$Domain = $Domain.TrimStart('@')

# Module setup - install if needed, import if needed
$moduleName = "Microsoft.Graph.Users"
if (-not (Get-Module -Name $moduleName -ErrorAction SilentlyContinue)) {
    Write-Host "Checking if $moduleName is installed..."
    if (-not (Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $moduleName..."
        Install-Module -Name $moduleName -Force -AllowClobber -ErrorAction Stop
    }
    Write-Host "Importing $moduleName..."
    Import-Module $moduleName -Force -ErrorAction Stop
}
Write-Host "✓ $moduleName is ready"

# Connect to Microsoft Graph if not already connected
if (-not (Get-MgContext -ErrorAction SilentlyContinue)) {
    Write-Host "Connecting to Microsoft Graph..."
    Connect-MgGraph -Scopes "User.Read.All" -ErrorAction Stop
    Write-Host "✓ Connected to Microsoft Graph"
}
else {
    Write-Host "✓ Already connected to Microsoft Graph"
}

# Define the output path with timestamp
$psexports = "$env:USERPROFILE\Documents\Exports"
if (-not (Test-Path $psexports)) {
    New-Item -ItemType Directory -Path $psexports -Force | Out-Null
}

$outputFile = "$psexports\Entra-CustomAttributes-$((Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')).csv"

Write-Host "Querying Entra for @$Domain users with custom attributes..."

try {
    $users = Get-MgUser -Filter "endsWith(userPrincipalName,'@$Domain')" `
        -Property "id,userPrincipalName,displayName,mail,onPremisesExtensionAttributes" `
        -All -ConsistencyLevel eventual -CountVariable userCount -ErrorAction Stop

    Write-Host "Found $($users.Count) user(s). Processing custom attributes..."

    # Build results array
    $results = @()

    foreach ($user in $users) {
        $row = @{
            'UserPrincipalName' = $user.UserPrincipalName
            'DisplayName'       = $user.DisplayName
            'Email'             = $user.Mail
            'CustomAttribute1'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute1
            'CustomAttribute2'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute2
            'CustomAttribute3'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute3
            'CustomAttribute4'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute4
            'CustomAttribute5'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute5
            'CustomAttribute6'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute6
            'CustomAttribute7'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute7
            'CustomAttribute8'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute8
            'CustomAttribute9'  = $user.OnPremisesExtensionAttributes.ExtensionAttribute9
            'CustomAttribute10' = $user.OnPremisesExtensionAttributes.ExtensionAttribute10
            'CustomAttribute11' = $user.OnPremisesExtensionAttributes.ExtensionAttribute11
            'CustomAttribute12' = $user.OnPremisesExtensionAttributes.ExtensionAttribute12
            'CustomAttribute13' = $user.OnPremisesExtensionAttributes.ExtensionAttribute13
            'CustomAttribute14' = $user.OnPremisesExtensionAttributes.ExtensionAttribute14
            'CustomAttribute15' = $user.OnPremisesExtensionAttributes.ExtensionAttribute15
        }

        $results += [PSCustomObject]$row
    }

    # Export to CSV
    $results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
    Write-Host "✓ Export completed successfully: $outputFile" -ForegroundColor Green

    # Auto-open the CSV file
    Invoke-Item $outputFile
}
catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}
