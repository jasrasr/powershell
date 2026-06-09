Get-ADUser -Filter * -Properties pwdLastSet |
    Where-Object { $_.pwdLastSet -eq 0 } |
    Select-Object Name, SamAccountName
