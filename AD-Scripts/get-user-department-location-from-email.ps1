# Revision : 1.1
# Description : Get Department from AD by matching full email address (mail attribute)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-31
# Modified Date : 2025-10-31

$users = @(
    "user1@domain.com",
    "user2@domain.com",
    "user3@domain.com"
)


$userInfos = @()

foreach ($user in $users) {
    Write-Host "Processing : $user"

    # Query AD by full email address using -Filter
    $adUser = Get-ADUser -Filter { mail -eq $user } -Properties mail, Department, SamAccountName -ErrorAction SilentlyContinue

    if ($adUser) {
        $userInfo = [PSCustomObject]@{
            Username   = $adUser.SamAccountName
            Email      = $adUser.mail
            Department = $adUser.Department
        }
    }
    else {
        $userInfo = [PSCustomObject]@{
            Username   = "Not Found"
            Email      = $user
            Department = "N/A"
        }
    }

    $userInfos += $userInfo
}

# Output neatly
$userInfos | Format-Table -AutoSize


<#

Username           Email                           Department
--------           -----                           ----------
username           user1@domain.com                Dept A
#>