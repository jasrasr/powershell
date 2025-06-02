Get-ADUser -Filter * -Properties CannotChangePassword |
    Where-Object { $_.CannotChangePassword -eq $true } |
    Select-Object Name, SamAccountName, DistinguishedName |
    Sort-Object Name
