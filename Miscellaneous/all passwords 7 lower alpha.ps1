start-Job -Name "PasswordGeneration100k" -ScriptBlock {

    # Generate a dynamic file name with the current time in HHmmss format
    $timeSuffix = (Get-Date -Format "HHmmss")
    $filename = "password$timeSuffix.txt"

# PowerShell script to generate all 7-character lowercase passwords

# Define lowercase alphabet and calculate number of combinations
$alphabet = 'abcdefghijklmnopqrstuvwxyz'
$total = [long][math]::Pow(26, 7)  # 26^7

Get-Date

# Remove the output file if it exists (to start fresh)
if (Test-Path 'passwords.txt') {
    Remove-Item 'passwords.txt'
}

Write-Host "Generating all 7-letter passwords (this may take a very long time)..."
Write-Host "Total combinations: $total"

# for ($i = 0; $i -lt $total; $i++) { #ALL OF THEM
for ($i = 0; $i -lt 100000; $i++) {
    # Convert the current number ($i) to a base-26 string
    $n = $i
    $pw = ''

    for ($j = 0; $j -lt 7; $j++) {
        $pw = $alphabet[$n % 26] + $pw
        $n = [math]::Floor($n / 26)
    }

    # Append the password to the file
    $pw | Out-File -FilePath 'passwords100k.txt' -Append
}

Write-Host "Finished generating all passwords."
}
Wait-Job -Name "PasswordGeneration100k"