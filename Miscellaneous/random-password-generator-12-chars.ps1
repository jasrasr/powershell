# Filename: random-password-generator-12-chars.ps1
# Revision : 1.0.0
# Description : Generates a random 12-character password and copies it to clipboard
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-04-30
# Modified Date : 2026-04-30
# Changelog :
# 1.0.0 initial release (updated from 10-char version; increased random chars from 7 to 9)

function genrandpw {
    # Define a character set for the password
    $chars = "abcdefghijkmnopqrstuvwxyz" # removed lowercase 'l' (lima); no uppercase, numbers, or symbols in random segment

    # Create a random password generator
    $random = New-Object System.Random

    # Generate 9 random characters; combined with "A" prefix and "2!" suffix = 12 characters total
    $randomPassword = -join (1..9 | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
    $randomPasswordz = -join ("A", $randomPassword, "2!")

    # Output the generated password
    Write-Host "The generated password is: $randomPasswordz"

    # Copy the generated password to the clipboard (PowerShell 5.0+)
    Set-Clipboard -Value $randomPasswordz
    Write-Host "Password copied to clipboard."
}

# Example Usage:
#   . .\random-password-generator-12-chars.ps1
#   genrandpw
