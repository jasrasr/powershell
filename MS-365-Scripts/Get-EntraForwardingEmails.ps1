# Filename: Get-EntraForwardingEmails.ps1
# Revision : 1.2
# Description : Retrieve all forwarding email addresses for users matching a specified UPN domain from Entra and export to CSV
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
$moduleNames = @("Microsoft.Graph.Users", "Microsoft.Graph.Mail")
foreach ($moduleName in $moduleNames) {
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
}

# Connect to Microsoft Graph if not already connected
if (-not (Get-MgContext -ErrorAction SilentlyContinue)) {
    Write-Host "Connecting to Microsoft Graph..."
    Connect-MgGraph -Scopes "User.Read.All", "Mail.Read" -ErrorAction Stop
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

$outputFile = "$psexports\Entra-ForwardingEmails-$((Get-Date -Format 'yyyy-MM-dd-HH-mm-ss')).csv"

Write-Host "Querying Entra for @$Domain users with forwarding email settings..."

try {
    $users = Get-MgUser -Filter "endsWith(userPrincipalName,'@$Domain')" `
        -Property "id,userPrincipalName,displayName,mail" `
        -All -ConsistencyLevel eventual -CountVariable userCount -ErrorAction Stop

    Write-Host "Found $($users.Count) user(s). Processing forwarding settings..."

    # Build results array
    $results = @()

    foreach ($user in $users) {
        try {
            # Get mailbox settings which include forwarding
            $mailboxSettings = Get-MgUserMailboxSetting -UserId $user.Id -ErrorAction SilentlyContinue

            # Extract forwarding addresses
            $forwardingAddresses = @()
            if ($mailboxSettings.ForwardingRules) {
                $forwardingAddresses = $mailboxSettings.ForwardingRules | Select-Object -ExpandProperty ForwardTo
            }

            $row = @{
                'UserPrincipalName'  = $user.UserPrincipalName
                'DisplayName'        = $user.DisplayName
                'Email'              = $user.Mail
                'ForwardingAddresses' = if ($forwardingAddresses) { $forwardingAddresses -join "; " } else { $null }
                'ForwardingCount'    = $forwardingAddresses.Count
            }

            $results += [PSCustomObject]$row
        }
        catch {
            Write-Warning "Failed to retrieve forwarding settings for $($user.UserPrincipalName): $_"
            $row = @{
                'UserPrincipalName'  = $user.UserPrincipalName
                'DisplayName'        = $user.DisplayName
                'Email'              = $user.Mail
                'ForwardingAddresses' = "ERROR"
                'ForwardingCount'    = 0
            }
            $results += [PSCustomObject]$row
        }
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
