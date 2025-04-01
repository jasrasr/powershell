function genrandpw {
# Define a character set for the password
#$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?"
$chars = "abcdefghijkmnopqrstuvwxyz" #rmeoved lowercase 'l' lima and upper, num, symbols

# Create a random password generator
$random = New-Object System.Random

# Generate a random password with 7 characters
$randomPassword = -join (1..7 | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
$randomPasswordz = -join ("A",$randomPassword,"2!") #add A prefix and 2! suffix so final password length is 10 characters

# Output the generated password
Write-Host "The generated password is: $randomPasswordz"

# Copy the generated password to the clipboard (PowerShell 5.0+)
Set-Clipboard -Value $randomPasswordz
Write-Host "Password copied to clipboard."
}
# Auwmpyan2! example