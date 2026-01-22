# Revision : 1.0.0
# Description : Get owners and members from a Microsoft Teams team and export to console and CSV
# Author : Jason Lamb
# Created Date : 2026-01-22
# Modified Date : 2026-01-22
# Changlog
## Rev 1.0.0 - Initial release with auto-install module, smart import, and C:\temp\powershell-exports output

param(
    [Parameter(Mandatory = $true)]
    [string]$TeamName
)

# Check if Microsoft Teams module is installed, if not install it
if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
    Write-Host "Microsoft Teams module not found.  Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name MicrosoftTeams -Force -AllowClobber -ErrorAction Stop
        Write-Host "Microsoft Teams module installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install Microsoft Teams module: $_"
        exit
    }
}

# Check if module is already imported, if not import it
if (-not (Get-Module -Name MicrosoftTeams)) {
    Write-Host "Importing Microsoft Teams module..." -ForegroundColor Cyan
    try {
        Import-Module MicrosoftTeams -ErrorAction Stop
        Write-Host "Microsoft Teams module imported successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to import Microsoft Teams module:  $_"
        exit
    }
}
else {
    Write-Host "Microsoft Teams module already imported." -ForegroundColor Green
}

# Connect to Microsoft Teams
Write-Host "Connecting to Microsoft Teams..." -ForegroundColor Cyan
try {
    Connect-MicrosoftTeams -ErrorAction Stop
}
catch {
    Write-Error "Failed to connect to Microsoft Teams:  $_"
    exit
}

# Get the team by name
Write-Host "Searching for team:  $TeamName" -ForegroundColor Cyan
$team = Get-Team -DisplayName $TeamName -ErrorAction SilentlyContinue

if (-not $team) {
    Write-Error "Team '$TeamName' not found."
    Disconnect-MicrosoftTeams
    exit
}

Write-Host "Team found:  $($team.DisplayName) (GroupId: $($team.GroupId))" -ForegroundColor Green

# Get all team users (owners and members)
Write-Host "`nRetrieving team members..." -ForegroundColor Cyan
$teamUsers = Get-TeamUser -GroupId $team.GroupId

# Separate owners and members
$owners = $teamUsers | Where-Object { $_.Role -eq "Owner" }
$members = $teamUsers | Where-Object { $_.Role -eq "Member" }

# Display results on screen
Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "OWNERS ($($owners.Count))" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
foreach ($owner in $owners) {
    Write-Host "  Name: $($owner.Name)" -ForegroundColor White
    Write-Host "  Email: $($owner.User)" -ForegroundColor Gray
    Write-Host "  Role: $($owner.Role)" -ForegroundColor Green
    Write-Host "  ---"
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "MEMBERS ($($members.Count))" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
foreach ($member in $members) {
    Write-Host "  Name: $($member.Name)" -ForegroundColor White
    Write-Host "  Email: $($member.User)" -ForegroundColor Gray
    Write-Host "  Role:  $($member.Role)" -ForegroundColor Cyan
    Write-Host "  ---"
}

# Prepare data for CSV export
$csvData = @()
foreach ($user in $teamUsers) {
    $csvData += [PSCustomObject]@{
        TeamName    = $team.DisplayName
        TeamId      = $team.GroupId
        Name        = $user.Name
        Email       = $user.User
        Role        = $user.Role
        UserId      = $user.UserId
    }
}

# Define export folder and create if it doesn't exist
$exportFolder = "C:\temp\powershell-exports"
if (-not (Test-Path -Path $exportFolder)) {
    Write-Host "`nExport folder not found. Creating: $exportFolder" -ForegroundColor Yellow
    try {
        New-Item -Path $exportFolder -ItemType Directory -Force | Out-Null
        Write-Host "Export folder created successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create export folder: $_"
        Disconnect-MicrosoftTeams
        exit
    }
}

# Export to CSV
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$csvFileName = "TeamMembers_$($team.DisplayName.Replace(' ','_'))_$timestamp.csv"
$csvPath = Join-Path -Path $exportFolder -ChildPath $csvFileName

try {
    $csvData | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "SUCCESS: Data exported to CSV" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "File location:  $csvPath" -ForegroundColor White
    Write-Host "Total records: $($csvData.Count)" -ForegroundColor White
}
catch {
    Write-Error "Failed to export CSV:  $_"
}

# Summary
Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "SUMMARY" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "Team:  $($team.DisplayName)" -ForegroundColor White
Write-Host "Total Owners:  $($owners.Count)" -ForegroundColor White
Write-Host "Total Members: $($members.Count)" -ForegroundColor White
Write-Host "Total Users:  $($teamUsers.Count)" -ForegroundColor White

# Disconnect
# Disconnect-MicrosoftTeams
# Write-Host "`nDisconnected from Microsoft Teams." -ForegroundColor Cyan

<#
EXAMPLE USAGE:
# Run the script with a team name
.\get-members-owners-from-team.ps1 -TeamName "Sales Team"
#>