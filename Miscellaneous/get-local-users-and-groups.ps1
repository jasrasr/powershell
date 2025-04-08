$ComputerName = "CHIW10H36D1J3"
$GroupName = "Administrators"
$userName = "${domain}\jason.lamb"

ping $ComputerName
#Get-CimInstance -ClassName Win32_Group -ComputerName $ComputerName | Select-Object Name, Description


# Add the $username to the $groupname group
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    param ($UserName, $GroupName)
    Add-LocalGroupMember -Group $GroupName -Member $UserName
} -ArgumentList $UserName, $GroupName

Write-Host "User '$UserName' has been added to the Administrators group on '$ComputerName'."

###
# Get local users and groups
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    param ($GroupName)
    get-localgroupmember -Group $GroupName
} -ArgumentList $GroupName