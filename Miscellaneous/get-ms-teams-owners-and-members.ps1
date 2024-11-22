#get date/time YYMMDD_HHMMSS
$datetime = Get-Date -Format "yyMMddHHmmss"

# Install Required Modules
Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name MicrosoftTeams -Force

# Connect to Microsoft Teams
Connect-MicrosoftTeams

# Disconnect from Microsoft Teams after the script completes
try {
    # Your existing code here
} finally {
    Disconnect-MicrosoftTeams
}



# Path to save the report
$reportfile = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\out-file\TeamsOwnersAndMembers-$datetime.csv"

# Function to Get Team Owners and Members
function Get-TeamOwnersAndMembers {
    param (
        [Parameter(Mandatory = $true)] 
        [string]$TeamId
    )

    # Get the team owners and members
    $owners = Get-TeamUser -GroupId $TeamId -Role Owner
    $members = Get-TeamUser -GroupId $TeamId -Role Member

    # Create a report array
    $report = @()

    # Process owners
    foreach ($owner in $owners) {
        if ($owner.DisplayName -and $owner.UserPrincipalName) {
            $report += [PSCustomObject]@{
                Role        = "Owner"
                DisplayName = $owner.DisplayName
                Email       = $owner.UserPrincipalName
            }
        }
    }

    # Process members
    foreach ($member in $members) {
        if ($member.DisplayName -and $member.UserPrincipalName) {
            $report += [PSCustomObject]@{
                Role        = "Member"
                DisplayName = $member.DisplayName
                Email       = $member.UserPrincipalName
            }
        }
    }

    return $report
}

# Get all Teams
$teams = Get-Team
$allTeamsReport = @()

# Process each team
foreach ($team in $teams) {
    Write-Output "Processing Team: $($team.DisplayName)"
    $teamReport = Get-TeamOwnersAndMembers -TeamId $team.GroupId
    foreach ($entry in $teamReport) {
        $entry | Add-Member -MemberType NoteProperty -Name "TeamName" -Value $team.DisplayName
    }
    $allTeamsReport += $teamReport
}

# Select and format the output
$formattedReport = $allTeamsReport | Select-Object TeamName, Role, DisplayName, Email

# Export report to CSV
$formattedReport | Export-Csv -Path $reportfile -NoTypeInformation -Force

Write-Output "Report saved to $reportfile"
