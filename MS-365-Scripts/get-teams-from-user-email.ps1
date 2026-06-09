# Revision      : 1.0
# Description   : Prompt for a user UPN and export all Microsoft Teams where the
#                 user is either a Member or an Owner. Teams are identified as
#                 Teams-enabled M365 Groups via Microsoft Graph. Results are
#                 exported to a date-stamped CSV file.
# Author        : Jason Lamb (with help from ChatGPT)
# Created Date  : 2026-01-22
# Modified Date : 2026-01-22
#
# Requirements  :
#   - PowerShell 5.1 or PowerShell 7+
#   - Microsoft.Graph.Users
#   - Microsoft.Graph.Groups
#   - Graph permissions:
#       * User.Read.All
#       * Group.Read.All
#
# Output        :
#   C:\temp\powershell-exports\TeamsForUser-<user>_<domain>-<timestamp>.csv
# -----------------------------
# Export Teams for a user
# Member OR Owner (Prompted)
# -----------------------------

$UserUPN = Read-Host "Enter the user's UPN (e.g. user@domain.com)"

if (-not $UserUPN -or $UserUPN -notmatch '@') {
    Write-Host "Invalid UPN provided. Aborting." -ForegroundColor Red
    return
}

$datetime = Get-Date -Format 'yyyyMMdd-HHmmss'
$OutFile  = "C:\temp\powershell-exports\TeamsForUser-$($UserUPN.Replace('@','_'))-$datetime.csv"

Connect-MgGraph -Scopes "Group.Read.All","User.Read.All"

# Get user object
try {
    $user = Get-MgUser -UserId $UserUPN -ErrorAction Stop
}
catch {
    Write-Host "User not found : $UserUPN" -ForegroundColor Red
    return
}

# Get all Teams-enabled M365 groups
$teams = Get-MgGroup -All `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" `
    -Property Id,DisplayName,Mail,Visibility

$results = foreach ($team in $teams) {

    # Check membership
    $isMember = Get-MgGroupMember -GroupId $team.Id -All |
        Where-Object { $_.Id -eq $user.Id }

    # Check ownership
    $isOwner = Get-MgGroupOwner -GroupId $team.Id -All |
        Where-Object { $_.Id -eq $user.Id }

    if ($isMember -or $isOwner) {
        [PSCustomObject]@{
            TeamName   = $team.DisplayName
            TeamEmail  = $team.Mail
            Visibility = $team.Visibility
            Role       = if ($isOwner) { 'Owner' } else { 'Member' }
        }
    }
}

$results |
    Sort-Object TeamName |
    Export-Csv $OutFile -NoTypeInformation -Encoding UTF8

Write-Host "Export complete : $OutFile" -ForegroundColor Green
notepad $outfile

# Example Usage:
& $githubpath\powershell\MS-365-Scripts\get-teams-from-user-email.ps1"
