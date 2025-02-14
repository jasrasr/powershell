New-ADUser -Name “Brian Stewart" -GivenName "Brian" -Surname "Stewart" -displayname "Brian Stewart" -SamAccountName "brian.stewart" -path "OU=820,OU=CLE,OU=MIDD,DC=MIDDOUGH,DC=LOCAL" 
-UserPrincipalName "brian.stewart@middough.com" -department "820.01 CLE Project Controls" -office "Cleveland" -state "OH" -initials "BS" -StreetAddress "1901 E 13th St, Ste 400" -City "Cleveland" 
-PostalCode "44114" -title "Sr. Project Controls Specialist" -company "Middough" -manager "Khaterjm" -AccountPassword(convertto-securestring "Middough0120!" -AsPlainText -force) -Enabled $true; 
set-aduser "brian.stewart" -Replace @{c="US";co="United States";countrycode=840}; 
Add-ADGroupMember -identity "O365 partial M365 E3 & Audio Conf" -Members brian.stewart;  
Add-ADGroupMember -identity "CAD Applications" -members brian.stewart; 
Add-ADGroupMember -identity "Project Level 4 Access (CAD User)" -members brian.stewart; 
Add-ADGroupMember -identity CLE_820 -members brian.stewart; <# no longer used #>;  
Add-ADGroupMember -identity "SSO" -members brian.stewart;  
Add-ADGroupMember -identity "O365 Microsoft Teams Phone Standard" -members brian.stewart; ; 
set-aduser "brian.stewart" -officephone "216-367-6325";
Set-ADUser -Identity brian.stewart -Replace @{extensionAttribute15="Cleveland"}; 


# Copy user adm.jlamb
$sourceUserJLamb = Get-ADUser -Identity "adm.jlamb"
$targetUserJLamb = New-ADUser -Name "Admin Mike Vargas" -GivenName $sourceUserJLamb.GivenName -Surname $sourceUserJLamb.Surname -DisplayName "$($sourceUserJLamb.DisplayName) Copy" -SamAccountName "adm.jlamb.copy" -Path $sourceUserJLamb.DistinguishedName -UserPrincipalName "adm.jlamb.copy@middough.com" -Department $sourceUserJLamb.Department -Office $sourceUserJLamb.Office -State $sourceUserJLamb.State -Initials $sourceUserJLamb.Initials -StreetAddress $sourceUserJLamb.StreetAddress -City $sourceUserJLamb.City -PostalCode $sourceUserJLamb.PostalCode -Title $sourceUserJLamb.Title -Company $sourceUserJLamb.Company -Manager $sourceUserJLamb.Manager -AccountPassword (ConvertTo-SecureString "Middough0120!" -AsPlainText -Force) -Enabled $true

# Copy group memberships
$groupsJLamb = Get-ADUser -Identity "adm.jlamb" -Property MemberOf | Select-Object -ExpandProperty MemberOf
foreach ($group in $groupsJLamb) {
    Add-ADGroupMember -Identity $group -Members "adm.jlamb.copy"
}

# Copy additional attributes
Set-ADUser -Identity "adm.jlamb.copy" -Replace @{
    c = $sourceUserJLamb.c
    co = $sourceUserJLamb.co
    countrycode = $sourceUserJLamb.countrycode
    officephone = $sourceUserJLamb.officephone
    extensionAttribute15 = $sourceUserJLamb.extensionAttribute15
}

###

# Define original user
$originaluser = "adm.jlamb" # Replace with the actual original user's username

# Get original user details
$originalUserDetails = Get-ADUser -Identity $originaluser -Properties *

# Prompt for new user details
$newuser = Read-Host "Enter the new username"
$displayname = Read-Host "Enter the display name"
$firstname = Read-Host "Enter the first name"
$lastname = Read-Host "Enter the last name"
$username = $newuser

# Get the user details and retrieve the DistinguishedName (DN)
#$originaluser = Get-ADUser -Identity $originaluser -Properties DistinguishedName

# Extract the OU path from the DistinguishedName
$ouPath = ($originaluser.DistinguishedName -split ',', 2)[1]

# Output the OU path
$ouPath

# Create new user using original user's settings, including custom properties
New-ADUser -SamAccountName $username `
           -UserPrincipalName "$username@middough.com" `
           -Name $displayname `
           -GivenName $firstname `
           -Surname $lastname `
           -DisplayName $displayname `
           -Description $originalUserDetails.Description `
           -Title $originalUserDetails.Title `
           -Department $originalUserDetails.Department `
           -Manager $originalUserDetails.Manager `
           -Office $originalUserDetails.Office `
           -MobilePhone $originalUserDetails.MobilePhone `
           -EmailAddress $originalUserDetails.EmailAddress `
           -StreetAddress $originalUserDetails.StreetAddress `
           -City $originalUserDetails.City `
           -State $originalUserDetails.State `
           -PostalCode $originalUserDetails.PostalCode `
           -Country $originalUserDetails.Country `
           -Enabled $true `
           -AccountPassword (ConvertTo-SecureString "Middough0204!" -AsPlainText -Force) `
           -PassThru

# Set the password to never expire, if needed
Set-ADUser -Identity $username -PasswordNeverExpires $false


$adminusers =@(
    'adm.mvargas',
    'adm.rschmidt',
    'adm.rpodhor',
    'adm.bdaugarthy',
    'adm.jwisz',
    'adm.jlamb',
    'adm.tblair'
    'adm.mszalkowski'
)


# Get groups for each user and output them
foreach ($pre2000username in $pre2000usernames) {
    $userGroups = Get-ADUser -Identity $pre2000username -Property MemberOf | Select-Object -ExpandProperty MemberOf
    Write-Output "Groups for $pre2000username :" | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append
    
    # Output to console and write to file using Tee-Object
    $userGroups | Format-Table | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append

    Write-Output "---" | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append
}

# Get groups for each ADMIN user and output them
foreach ($adminuser in $adminusers) {
    $userGroups = Get-ADUser -Identity $adminuser -Property MemberOf | Select-Object -ExpandProperty MemberOf
    Write-Output "Groups for $adminuser :" | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append
    
    # Output to console and write to file using Tee-Object
    $userGroups | Format-Table | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append

    Write-Output "---" | Tee-Object -FilePath c:\temp\ad-it-user-groups.txt -Append
}

$admingroups = @(
'ADSyncAdmins',
'Workstation_Admins',
'Administrators',
'Domain Admins',
'Exchange Organization Administrators',
'SMS_Admins',
'Workstation_Deployment',
'CLE_740_WS_Domain_Import',
'CLE Room Admin',
'SCadmins'
)
# ADD TO ADMIN USERS
foreach ($admingroup in $admingroups) {
    Add-ADGroupMember -Identity $admingroup -Members $adminusers
}

# Define pre-2000 usernames
$pre2000usernames = @(
    'Michael.Vargas',
    'Schmidrc',
    'Podhorrl',
    'Wiszjl',
    'jason.lamb',
    'Blairtg'
    'brad.daugharthy',
    'Szalkomg'
)

# REMOVE FROM REGULAR USERS
foreach ($admingroup in $admingroups) {
    remove-ADGroupMember -Identity $admingroup -Members $pre2000usernames -Confirm:$false
}

Add-ADGroupMember -identity "Domain Admins" -members $users
remove-adgroupmember -identity "O365 Microsoft Teams Phone Standard" -members brian.stewart;

#get pre-2000 username from display name
$displaynames = @(
    #"Michael Vargas",
    #"Robert Schmidt",
    #"Robert Podhor",
    "Brad Daugharthy"
    #"Jerry Wisz",
    #"Jason Lamb",
    #"Thomas Blair",
    #"Mike Szalkowski"
)
foreach ($displayname in $displaynames) {
get-aduser -filter {DisplayName -eq $displayname} | select samaccountname
}

