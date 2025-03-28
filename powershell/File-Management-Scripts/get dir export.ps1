# Install-Module -Name PowerShellGet -Force -AllowClobber
# Install-Module -Name MicrosoftTeams -Force

# Connect-MicrosoftTeams

# Function to Get Team Owners and Members
function Get-TeamOwnersAndMembers {
    param (
        [Parameter(Mandatory = $true)] 
        [string]$TeamId
    )

    # Get the team owners
    $owners = Get-TeamUser -GroupId $TeamId -Role Owner

    # Get the team members
    $members = Get-TeamUser -GroupId $TeamId -Role Member

    # Create a report
    $report = @()

    foreach ($owner in $owners) {
        if ($null -ne $owner.DisplayName -and $owner.DisplayName.Trim() -ne "" -and $null -ne $owner.UserPrincipalName -and $owner.UserPrincipalName.Trim() -ne "") {
            $report += [PSCustomObject]@{
                Role        = "Owner"
                DisplayName = $owner.DisplayName
                Email       = $owner.UserPrincipalName
            }
        }
    }

    foreach ($member in $members) {
        if ($null -ne $member.DisplayName -and $member.DisplayName.Trim() -ne "" -and $null -ne $member.UserPrincipalName -and $member.UserPrincipalName.Trim() -ne "") {
            $report += [PSCustomObject]@{
                Role        = "Member"
                DisplayName = $member.DisplayName
                Email       = $member.UserPrincipalName
            }
        }
    }

    return $report
}

# Example: Get all Teams and retrieve their owners and members
$teams = Get-Team
$allTeamsReport = @()

foreach ($team in $teams) {
    Write-Output "Processing Team: $($team.DisplayName)"
    $teamReport = Get-TeamOwnersAndMembers -TeamId $team.GroupId
    $teamReport | ForEach-Object {
        $_ | Add-Member -MemberType NoteProperty -Name "TeamName" -Value $team.DisplayName
        $_
    }
    $allTeamsReport += $teamReport
}

# Output to a CSV file
$allTeamsReport | Export-Csv -Path "TeamsOwnersAndMembers.csv" -NoTypeInformation

Write-Output "Report saved to TeamsOwnersAndMembers.csv"
