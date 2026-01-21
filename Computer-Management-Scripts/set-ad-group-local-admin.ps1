# Get the current computer's hostname
$ComputerName = $env:COMPUTERNAME

# Define the AD group name (assumes group name matches computer name)
$ADGroup = "$ComputerName"

# Define the local Administrators group
$LocalGroup = "Administrators"

# Report current members before change
Write-Host "Current members of local Administrators group:" -ForegroundColor Yellow
Get-LocalGroupMember -Group $LocalGroup | Select-Object -ExpandProperty Name

# Check if the AD group exists
try {
    Get-ADGroup -Identity $ADGroup -ErrorAction Stop
    # Add the AD group to the local Administrators group
    Add-LocalGroupMember -Group $LocalGroup -Member ("$env:USERDOMAIN\$ADGroup")
    Write-Host "Added $env:USERDOMAIN\$ADGroup to local Administrators group." -ForegroundColor Green
} catch {
    Write-Host "AD group '$ADGroup' does not exist or failed to add: $_" -ForegroundColor Red
}

# Report current members after change
Write-Host "Members of local Administrators group after change:" -ForegroundColor Yellow
Get-LocalGroupMember -Group $LocalGroup | Select-Object -ExpandProperty Name
