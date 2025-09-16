# Revision : 1.0
# Description : Generate 10 random passwords with complexity (uppercase, lowercase, digits, special chars). Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-29
# Modified Date : 2025-08-29

function New-RandomPassword {
    param(
        [int]$Length = 12
    )

    $upper   = [char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $lower   = [char[]]'abcdefghijklmnopqrstuvwxyz'
    $digits  = [char[]]'0123456789'
    $special = [char[]]'!@#$%^&*()-_=+[]{};:,.<>?'

    $allChars = $upper + $lower + $digits + $special
    $password = -join (Get-Random -InputObject $upper -Count 1) +
                (Get-Random -InputObject $lower -Count 1) +
                (Get-Random -InputObject $digits -Count 1) +
                (Get-Random -InputObject $special -Count 1)

    $remaining = $Length - 4
    if ($remaining -gt 0) {
        $password += -join (Get-Random -InputObject $allChars -Count $remaining)
    }

    # Shuffle the characters
    -join ($password.ToCharArray() | Get-Random -Count $password.Length)
}

1..10 | ForEach-Object {
    $pwd = New-RandomPassword -Length 16
    Write-Host "Password $_ : $pwd"
}
