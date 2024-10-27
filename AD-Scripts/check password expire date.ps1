# Import Active Directory module
Import-Module ActiveDirectory

# Define the username you want to check
$username = "jason.lamb"

# Get the user's account details
$user = Get-ADUser -Identity $username -Properties "msDS-UserPasswordExpiryTimeComputed"

# Convert the expiration time from Windows FileTime to a readable format
$passwordExpiry = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")

# Output the result
Write-Host "Password Expiry Date for $username: $passwordExpiry"
