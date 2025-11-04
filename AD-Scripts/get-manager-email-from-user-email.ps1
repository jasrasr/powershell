$users = @(
    "user1@domain.com",
    "user2@domain.com"
)

foreach ($user in $users) {
    # Do something with $item
    Write-Host "Processing : $user"
     # get username from email in ad
    $username = (Get-ADUser -Filter {EmailAddress -eq $user} -Properties SamAccountName | Select-Object -ExpandProperty SamAccountName)
 
    #check if user exists
    if ($username) {
        Write-Host "Found user: $username"
    } else {
        Write-Host "User not found for email: $user"
    }

    
# get ad user manager email
   
    $managerEmail = (Get-ADUser -Identity $username -Properties Manager | Select-Object -ExpandProperty Manager)
    # get email of manager
    $managerEmail = (Get-ADUser -Identity $managerEmail -Properties EmailAddress | Select-Object -ExpandProperty EmailAddress)

    # add to new array
    $managerEmails += $managerEmail
}
# get unique manager emails
$managerEmails = $managerEmails | Select-Object -Unique
$managerEmails
