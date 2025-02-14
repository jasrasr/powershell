#RENAME COMPUTER BASED ON OFFICE LOCATION, OS, SERVICE TAG

# Define a mapping for office locations
$officeLocations = @{
    "Cleveland" = "CLE"
    "Chicago" = "CHI"
    "Indiana" = "NWI"
    "Toledo" = "TOL"
    "Buffalo" = "BUF"
    "Madison" = "MAD"
    "Dallas" = "DAL"
    "Ashland" = "ASH"
    "Pittsburgh" = "PIT"
}

# Retrieve the user's office location from an environment variable or registry key
# Assuming we have an environment variable "OfficeLocation" containing the location name
$userOffice = $env:OfficeLocation  # Replace with registry query if needed

# Map to the office code, defaulting to "UNK" if unknown
$officeLocation = $officeLocations[$userOffice] -or "UNK"

# Get the OS version
$osVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
if ($osVersion -like "*10*") {
    $osCode = "W10"
} elseif ($osVersion -like "*11*") {
    $osCode = "W11"
} else {
    $osCode = "W" + ($osVersion -replace '\D')  # Default to W + OS version number
}

# Get Dell service tag
$serviceTag = (Get-WmiObject -Namespace root\wmi -Class MS_SystemInformation).SerialNumber

# Combine values to create the new computer name
$newComputerName = "{0}{1}{2}" -f $officeLocation, $osCode, $serviceTag.Substring(0, 7)

# Rename the computer
#Rename-Computer -NewName $newComputerName -Force

Write-Output "Computer renamed to: $newComputerName"


###

# Set up the computer name
$computerName = "CLEW11DZ93HW3"  # Replace with the target computer name

# Define the LDAP search filter to find the computer
$searcher = New-Object DirectoryServices.DirectorySearcher
$searcher.Filter = "(&(objectCategory=computer)(name=$computerName))"

# Perform the search
$result = $searcher.FindOne()

if ($result) {
    # Get the distinguished name, which includes the OU path
    $distinguishedName = $result.Properties["distinguishedname"][0]
    Write-Output "Computer OU Location: $distinguishedName"
} else {
    Write-Output "Computer not found in Active Directory."
}
