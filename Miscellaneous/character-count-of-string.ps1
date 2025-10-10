# Revision : 1.0
# Description : String statistics script — counts chars, words, vowels, etc. with random color output. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-10
# Modified Date : 2025-10-10

# Define an array of color names (must match valid console color names)
$colors = @('White','Gray','DarkGray','Black','Green','DarkGreen','Cyan','DarkCyan','Red','DarkRed','Magenta','DarkMagenta','Yellow','DarkYellow','Blue','DarkBlue')

# Pick one at random
function Get-RandomColor {
    param (
        [string[]]$ColorArray = $colors
    )
    return Get-Random -InputObject $ColorArray
}

# this genarates a random color each time it is called, for the whole script
# $randomColor = get-random -InputObject $colors

# random script to count characters in a string
$randomtext = "The quick brown fox jumps over the lazy dog."
$string = $randomtext
# $string = "Hello, World!"

write-host "Analyzing the string: `"$string`"" -ForegroundColor $(Get-RandomColor) # calls the function to get a random color for each line

# count how many characters are in the string
$stringLength = $string.Length
Write-Host "The string has $stringLength characters." -ForegroundColor $(Get-RandomColor) 

# count how many specific characters are in the string (e.g., count 'e')
$specificChar = 'e'
$specificCharCount = ($string -split "[^$specificChar]").Where({$_ -ne ''}).Count
Write-Host "The string has $specificCharCount occurrences of '$specificChar'." -ForegroundColor $(Get-RandomColor)

# count how many words are in the string
$wordCount = ($string -split '\s+').Count
Write-Host "The string has $wordCount words." -ForegroundColor $(Get-RandomColor)

# count how many special characters are in the string (non-alphanumeric)
$specialCharCount = ($string -split '[^a-zA-Z0-9\s]').Where({$_ -ne ''}).Count
Write-Host "The string has $specialCharCount special characters." -ForegroundColor $(Get-RandomColor)

# count how many vowels are in the string
$vowelCount = ($string -split '[^aeiouAEIOU]').Where({$_ -ne ''}).Count
Write-Host "The string has $vowelCount vowels." -ForegroundColor $(Get-RandomColor)

# count how many consonants are in the string
$consonantCount = ($string -split '[^bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]').Where({$_ -ne ''}).Count
Write-Host "The string has $consonantCount consonants." -ForegroundColor $(Get-RandomColor)

# count how many spaces are in the string
$spaceCount = ($string -split '[^\s]').Where({$_ -ne ''}).Count
Write-Host "The string has $spaceCount spaces." -ForegroundColor $(Get-RandomColor)

# count how many digits are in the string
$digitCount = ($string -split '[^0-9]').Where({$_ -ne ''}).Count
Write-Host "The string has $digitCount digits." -ForegroundColor $(Get-RandomColor)

# count how many uppercase letters are in the string
$uppercaseCount = ($string | Where-Object { $_ -match '[A-Z]' }).Count
Write-Host "The string has $uppercaseCount uppercase letters." -ForegroundColor $(Get-RandomColor)

# count how many lowercase letters are in the string
$lowercaseCount = ($string -split '[^a-z]').Where({$_ -ne ''}).Count
Write-Host "The string has $lowercaseCount lowercase letters." -ForegroundColor $(Get-RandomColor)

<#
# count how many punctuation characters are in the string
$punctuationCount = ($string -split '[^.,!?;:\`'"`~@#$%^&*()-_=+[\]{}|<>/\\]'`).Where({$_ -ne ''}).Count
Write-Host "The string has $punctuationCount punctuation characters." -ForegroundColor $(Get-RandomColor)
#>

# count how many lines are in the string (if multiline)
$lineCount = ($string -split "`r?`n").Count
Write-Host "The string has $lineCount lines." -ForegroundColor $(Get-RandomColor)

# count how many unique characters are in the string
$uniqueCharCount = ($string.ToCharArray() | Select-Object -Unique).Count
Write-Host "The string has $uniqueCharCount unique characters." -ForegroundColor $(Get-RandomColor)

# count how many alphanumeric characters are in the string
# Alphanumeric characters: letters (A–Z, a–z) and digits (0–9).
$alphanumericCount = ($string -split '[^a-zA-Z0-9]').Where({$_ -ne ''}).Count
Write-Host "The string has $alphanumericCount alphanumeric characters." -ForegroundColor $(Get-RandomColor)

# count how many non-alphanumeric characters are in the string
# Non-alphanumeric characters: anything that is not a letter or digit. That includes punctuation (.,!?;), symbols (#, @, $, %, &), whitespace (space, tab, newline), etc
$nonAlphanumericCount = ($string | Where-Object { $_ -notmatch '[A-Za-z0-9]' }).Count
Write-Host "The string has $nonAlphanumericCount non-alphanumeric characters." -ForegroundColor $(Get-RandomColor)

# count how many whitespace characters are in the string
$whitespaceCount = ($string -split '[^\s]').Where({$_ -ne ''}).Count
Write-Host "The string has $whitespaceCount whitespace characters." -ForegroundColor $(Get-RandomColor)

# count how many printable characters are in the string
$printableCount = ($string -split '[^\x20-\x7E]').Where({$_ -ne ''}).Count
Write-Host "The string has $printableCount printable characters." -ForegroundColor $(Get-RandomColor)

# count how many non-printable characters are in the string
$nonPrintableCount = ($string -split '[\x20-\x7E]').Where({$_ -ne ''}).Count
Write-Host "The string has $nonPrintableCount non-printable characters." -ForegroundColor $(Get-RandomColor)

# count how many characters are in the string excluding spaces
$charCountExcludingSpaces = ($string -split '\s+').Where({$_ -ne ''}) -join '' | ForEach-Object { $_.Length } | Measure-Object -Sum
Write-Host "The string has $($charCountExcludingSpaces.Sum) characters excluding spaces." -ForegroundColor $(Get-RandomColor)

<#
# count how many characters are in the string excluding punctuation
$charCountExcludingPunctuation = ($string -split '[.,!?;:\`'"`~@#$%^&*()-_=+[\]{}|<>/\\]').Where({$_ -ne ''}) -join '' | ForEach-Object { $_.Length } | Measure-Object -Sum
Write-Host "The string has $($charCountExcludingPunctuation.Sum) characters excluding punctuation." -ForegroundColor $(Get-RandomColor)
#>

# count how many sentences are in the string (simple split by ., !, ?)
$sentenceCount = ($string -split '[.!?]+').Where({$_ -ne ''}).Count
Write-Host "The string has $sentenceCount sentences." -ForegroundColor $(Get-RandomColor)

# another way
# $colors = @('White','Gray','DarkGray','Black','Green','DarkGreen','Cyan','DarkCyan','Red','DarkRed','Magenta','DarkMagenta','Yellow','DarkYellow','Blue','DarkBlue')
# Write-Host "Some random colored text" -ForegroundColor (Get-Random -InputObject $colors)
