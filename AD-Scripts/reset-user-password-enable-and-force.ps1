<#
#New-ADUser -Name “Doug Thornberry" -GivenName "Doug" -Surname "Thornberry" -displayname "Doug Thornberry" -SamAccountName "doug.thornberry" -path "OU=125,OU=NWI,OU=MIDD,DC=$domain,DC=LOCAL" -UserPrincipalName "doug.thornberry@$domain.com" -department "125.08 NWI Asset Integrity" -office "Indiana" -state "IN" -initials "DT" -StreetAddress "1433 E 83rd Ave, Ste 100" -City "Merrillville" -PostalCode "46410" -title "Inspector" -company "$domainup" -manager "Keith.Luttell" -AccountPassword(convertto-securestring "${domainup}0303!" -AsPlainText -force) -Enabled $true; set-aduser "doug.thornberry" -Replace @{c="US";co="United States";countrycode=840}; Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members doug.thornberry;  Add-ADGroupMember -identity "CAD Applications" -members doug.thornberry; Add-ADGroupMember -identity "Project Level 4 Access - CAD User" -members doug.thornberry; Add-ADGroupMember -identity NWI_125 -members doug.thornberry; <# no longer used #>;  Add-ADGroupMember -identity "SSO" -members doug.thornberry;  Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members doug.thornberry; ; set-aduser "doug.thornberry" -officephone " 219 706 6987";; 


# Define a character set for the password
#$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?"
$chars = "abcdefghijkmnopqrstuvwxyz" #removed lower-case lima "l"

# Create a random password generator
$random = New-Object System.Random

# Generate a random password with 12 characters
$randomPassword = -join (1..12 | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
$randomPasswordz = -join ("A",$randomPassword,"2!")


# Convert the random password to a secure string
$securePassword = ConvertTo-SecureString $randomPasswordz -AsPlainText -Force



# Output the generated password
Write-Host "The generated password is: $randomPasswordz"
#>
###
function resetpassword {
$username = ""
# Prompt for AD username
$username = Read-Host "Enter AD username"

# Generate the password

# Define a character set for the password
#$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?"
$chars = "abcdefghijkmnopqrstuvwxyz" #removed lower-case lima "l"

# Create a random password generator
$random = New-Object System.Random

# Generate a random password with 7 characters
$randomPassword = -join (1..7 | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })

#add prefix A and suffix 2! to a 7 character lowercase password
$randomPasswordz = "A" + $randomPassword + "2!"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString -String $randomPasswordz -AsPlainText -Force

# Ask if the force password reset should happen
$forceReset = Read-Host "Do you want to force the user to change their password at next logon? (Yes/No)"

# Check if force reset should happen
if ($forceReset -eq "Yes") {
    # Force the user to change the password at next logon
    # Enable the user account
    Set-ADAccountPassword -Identity $username -NewPassword $securePassword -Reset  -Enabled $true  -ChangePasswordAtLogon $true 
    Write-Host "Password for user $username has been set to $randompasswordz, account is enabled, and user is required to change password at next logon."
} else {
    Set-ADAccountPassword -Identity $username -NewPassword $securePassword -Reset  -Enabled $true 
   
    Write-Host "Password for user $username has been set  to $randompasswordz and account is enabled without forcing password change at next logon."
}
}
resetpassword