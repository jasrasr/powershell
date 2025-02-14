# Requires the ActiveDirectory module
# Make sure you have RSAT or the AD PowerShell module installed.

Import-Module ActiveDirectory

$users = @(
    "Adam Walters",
    "Alan Chihak",
    "Alexander Faulkner",
    "Andrew Makinson",
    "Arek Torosian",
    "Benjamin Trout",
    "Cathy Sullivan",
    "Charles Bridge",
    "Chip Hoppel",
    "David Hurst",
    "George Rowe",
    "James Adams",
    "James Sebek",
    "Jeff Sanders",
    "Jeff Zunich",
    "Jeffery Kuzma",
    "Jeffrey Walton",
    "John Ross",
    "John Sweeney",
    "Jonathan Atkinson",
    "Joseph Grelewicz",
    "Josh Palyo",
    "Justin Bettino",
    "Justin Walters",
    "Kenneth Putnam",
    "Kenneth Sefcik",
    "Kyle Cussen",
    "Mark Sulzbach",
    "Matt Bedee",
    "Matthew Althouse",
    "Michael Roberts",
    "Michael Sarver",
    "Michael Smith",
    "Michael Wheat",
    "Nathan Ingram",
    "Richard Johnson",
    "Richard Yoerger",
    "Robert Bordon",
    "Robert Davidson",
    "Satish Munje",
    "TLynn Ho-DePeder",
    "Tracey Key",
    "Tyler Baird",
    "Tyler Brown",
    "Victor Sibiga",
    "William Zato"
)

foreach ($user in $users) {
    # Try to find a user in AD by display name
    $adUser = Get-ADUser -Filter "DisplayName -eq '$user'" -Properties SamAccountName -ErrorAction SilentlyContinue

    if ($adUser) {
        [pscustomobject]@{
            DisplayName   = $user
            SAMAccountName = $adUser.SamAccountName
        }
    }
    else {
        Write-Warning "User '$user' not found in AD or multiple matches returned."
    }
}

Import-Module ActiveDirectory

### as array

foreach ($user in $users) {
    $adUser = Get-ADUser -Filter "DisplayName -eq '$user'" -Properties SamAccountName -ErrorAction SilentlyContinue
    
    if ($adUser) {
        # Add the sAMAccountName to the array
        $samArray += $adUser.SamAccountName
    }
    else {
        Write-Warning "User '$user' not found in AD or multiple matches returned."
    }
}

# The array of sAMAccountNames is now contained in $samArray
return $samArray
$samArray[5]

### as better array

Import-Module ActiveDirectory


# Initialize an empty array to store sAMAccountNames
$samArray = @()

foreach ($user in $users) {
    # Retrieve the AD user by display name
    $adUser = Get-ADUser -Filter "DisplayName -eq '$user'" -Properties SamAccountName -ErrorAction SilentlyContinue
    
    # If we find exactly one matching user, add their sAMAccountName to the array
    if ($adUser) {
        $samArray += $adUser.SamAccountName
    }
    else {
        Write-Warning "User '$user' not found or multiple matches returned."
    }
}

# Return the array, each entry is a separate sAMAccountName
return $samArray

### create new AD group
#Import-Module ActiveDirectory

# Define group properties
$groupName        = "Egnyte-POC"
$groupSamAccount  = "Egnyte-POC"   # Pre-Windows 2000 name
$groupDescription = "Users in Egnyte POC, member of Egnyte SSO"
$groupOU          = "OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"

# Create the new AD group
New-ADGroup `
    -Name $groupName `
    -SamAccountName $groupSamAccount `
    -GroupScope Global `
    -GroupCategory Security `
    -DisplayName $groupName `
    -Description $groupDescription `
    -Path $groupOU

### add members to group
#Import-Module ActiveDirectory

# The group name we created previously
$groupName = "Egnyte-POC"

# $samArray should already be populated from the previous script
# For example:
# $samArray = @("user1", "user2", "user3", ...)

# Add all users in $samArray to the Egnyte-POC group
Add-ADGroupMember -Identity $groupName -Members $samArray

### get/show users in group
Import-Module ActiveDirectory

# Group name
$groupName = "Egnyte-POC"

# Get group members and display their name and sAMAccountName
Get-ADGroupMember -Identity $groupName | Select-Object Name, SamAccountName
