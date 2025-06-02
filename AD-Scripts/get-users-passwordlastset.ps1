Get-ADUser -Filter * -Properties PasswordLastSet |
    Select-Object Name, SamAccountName, PasswordLastSet |
    Sort-Object PasswordLastSet
