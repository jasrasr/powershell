# Import the Active Directory module
Import-Module ActiveDirectory

# Get computer name from the hostname
$computerName = $env:COMPUTERNAME

# Get the computer model using WMI
$computerModel = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Model


# Get the display name of the user
$userName = $env:USERNAME
$userDisplayName = (Get-ADUser -Identity $userName -Properties DisplayName).DisplayName

# Get the computer object
$computer = Get-ADComputer -Identity $computerName

# Parameters
$newDescription = "$userDisplayName - $computerModel - test" # Replace with the new description

if ($computer) {
    # Set the new description
    Set-ADComputer -Identity $computerName -Description $newDescription
    Write-Output "Description for $computerName has been updated to '$newDescription'."
} else {
    Write-Output "Computer $computerName not found."
}

