# Filename: get-entra-group-members.ps1
# Revision : 1.0.0
# Description : Retrieves members of an Entra ID group and exports to CSV
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-12
# Modified Date : 2026-05-12
# Changelog :
# 1.0.0 initial release

param(
    [Parameter(Mandatory=$true, HelpMessage="Display name of the Entra group")]
    [string]$GroupName
)

# Ensure module is installed
foreach ($module in @("Microsoft.Graph.Groups", "Microsoft.Graph.Users")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..." -ForegroundColor Cyan
        Install-Module $module -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name $module)) {
        Write-Host "Importing $module..." -ForegroundColor Cyan
        Import-Module $module
    }
}

# Connect to Microsoft Graph if not already connected
$graphContext = Get-MgContext
if (-not $graphContext) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All" -NoWelcome
    $graphContext = Get-MgContext
} else {
    Write-Host "Already connected to Microsoft Graph as $($graphContext.Account)" -ForegroundColor Green
}

# Get the group
Write-Host "Searching for group: $GroupName" -ForegroundColor Cyan
try {
    $group = Get-MgGroup -Filter "displayName eq '$GroupName'" -ErrorAction Stop
    if (-not $group) {
        Write-Host "Group '$GroupName' not found" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error retrieving group: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Found group: $($group.DisplayName) (ID: $($group.Id))" -ForegroundColor Green

# Get group members
Write-Host "Retrieving members..." -ForegroundColor Cyan
try {
    $members = Get-MgGroupMember -GroupId $group.Id -All -ErrorAction Stop
} catch {
    Write-Host "Error retrieving members: $_" -ForegroundColor Red
    exit 1
}

if (-not $members) {
    Write-Host "No members found in group" -ForegroundColor Yellow
    exit 0
}

# Get member details (DisplayName and Email)
$memberDetails = @()
foreach ($member in $members) {
    try {
        $user = Get-MgUser -UserId $member.Id -ErrorAction SilentlyContinue
        if ($user) {
            $memberDetails += [PSCustomObject]@{
                DisplayName = $user.DisplayName
                Email       = $user.Mail
            }
        }
    } catch {
        Write-Host "Warning: Could not retrieve details for member $($member.Id)" -ForegroundColor Yellow
    }
}

# Display on screen
Write-Host "`n========== GROUP MEMBERS ==========" -ForegroundColor Cyan
$memberDetails | Format-Table -AutoSize

Write-Host "Total members: $($memberDetails.Count)" -ForegroundColor Green

# Export to CSV
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$exportPath = "C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports"

if (-not (Test-Path $exportPath)) {
    Write-Host "Creating export folder: $exportPath" -ForegroundColor Cyan
    New-Item -Path $exportPath -ItemType Directory -Force | Out-Null
}

$csvFile = "$exportPath\entra-group-members-$($GroupName -replace '\s', '-')-$timestamp.csv"

try {
    $memberDetails | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8 -ErrorAction Stop
    Write-Host "Exported to: $csvFile" -ForegroundColor Green
} catch {
    Write-Host "Error exporting CSV: $_" -ForegroundColor Red
    exit 1
}

# Example Usage:
#   .\get-entra-group-members.ps1 -GroupName "Sales Team"
#   .\get-entra-group-members.ps1 -GroupName "Engineering"
