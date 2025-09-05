# Revision : 1.6
# Description : Query and optionally add a domain user to a local group on a remote computer
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2024-11-12
# Modified Date : 2025-09-04

# Prompt for computer name (default to current hostname if Enter is pressed)
$ComputerName = Read-Host "Enter Computer Name (default : $env:COMPUTERNAME)"
if ([string]::IsNullOrWhiteSpace($ComputerName)) {
    $ComputerName = $env:COMPUTERNAME
}

# Prompt for group name (default to Administrators if Enter is pressed)
$GroupName = Read-Host "Enter Group Name (default : Administrators)"
if ([string]::IsNullOrWhiteSpace($GroupName)) {
    $GroupName = "Administrators"
}

$UserName = "$env:USERDOMAIN\$env:USERNAME"

# Test connectivity
Write-Host "Pinging $ComputerName ..."
if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
    Write-Host "$ComputerName is reachable."
} else {
    Write-Host "Error : $ComputerName is not reachable."
    return
}

<# 
# Uncomment this section to add user to group
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    param ($UserName, $GroupName)
    try {
        Add-LocalGroupMember -Group $GroupName -Member $UserName -ErrorAction Stop
        Write-Host "User $UserName has been added to $GroupName on $env:COMPUTERNAME."
    }
    catch {
        Write-Host "Error on $env:COMPUTERNAME : $_"
    }
} -ArgumentList $UserName, $GroupName
#>

# Get current local group members
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    param ($GroupName)
    try {
        Write-Host "Members of $GroupName on $env:COMPUTERNAME :"
        Get-LocalGroupMember -Group $GroupName
    }
    catch {
        Write-Host "Error retrieving $GroupName members on $env:COMPUTERNAME : $_"
    }
} -ArgumentList $GroupName
