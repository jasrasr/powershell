# check users in all groups 
# ou example is MIDDOUGH.LOCAL/MIDD/Common/Local Admin
# CN=4QBMKY3,OU=Local Admin,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL

$ou = "OU=Local Admin,OU=Common,OU=MIDD,DC=MIDDOUGH,DC=LOCAL"
Get-ADGroup -Filter * -SearchBase $ou | ForEach-Object {
    $group = $_
    Get-ADGroupMember -Identity $group | ForEach-Object {
        $user = $_
        [PSCustomObject]@{
            GroupName = $group.Name
            UserName  = $user.SamAccountName
        }
    }
} | Format-Table -AutoSize