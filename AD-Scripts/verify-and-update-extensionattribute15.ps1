# Get all users with Office attribute equal to "Cleveland"
$users = Get-ADUser -Filter {(Office -eq "Cleveland") -or (Office -eq "Toledo")} -Properties DisplayName, Office, extensionAttribute15
 
# Loop through the results and output only users with extensionAttribute15 as "n/a"
foreach ($user in $users) {
    if (-not $user.extensionAttribute15) {
        Write-Host "User: $($user.DisplayName), Username: $($user.SamAccountName), Office: $($user.Office), ExtensionAttribute15: n/a"
        Write-Host "Setting ExtensionAttribute15 to $($user.Office)"
        Set-ADUser -Identity $($user.SamAccountName) -Replace @{extensionAttribute15=$($user.Office)}
        $extensionAttribute15 = (Get-ADUser -Identity $($user.SamAccountName) -Properties extensionAttribute15).extensionAttribute15
        Write-Host "User: $($user.DisplayName), Username: $($user.SamAccountName), Office: $($user.Office), ExtensionAttribute15: $extensionAttribute15"
    }
}

<# TROUBLESHOOTING
get-aduser -Identity testop -Properties extensionAttribute15 | select extensionAttribute15
Set-ADUser -Identity testop -Clear extensionAttribute15
#>