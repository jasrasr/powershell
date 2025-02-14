# Import the Active Directory module
Import-Module ActiveDirectory

# Get the current date
$currentDate = Get-Date

# Calculate the date 90 days ago
$cutoffDate = $currentDate.AddDays(-90)

# Get all AD users who haven't logged in in the last 90 days
$staleUsers = Get-ADUser -Filter {LastLogonDate -lt $cutoffDate} -Properties LastLogonDate, Enabled, PasswordLastSet

# Output the results with account status and last password change date
$staleUsers | Select-Object Name, LastLogonDate, PasswordLastSet, @{Name="Status";Expression={if ($_.Enabled) {"Active"} else {"Disabled"}}} | Sort-Object Status, LastLogonDate | Format-Table -AutoSize
