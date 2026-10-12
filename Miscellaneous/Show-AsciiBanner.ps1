<#
.SYNOPSIS
    Displays large block-letter ASCII text in a PowerShell console.

.DESCRIPTION
    Renders text using a built-in 5x7 font and Unicode block characters.
    The script has no external dependencies and is useful for banners,
    startup screens, loading screens, and status messages.

.PARAMETER Text
    Text to render. Letters, numbers, spaces, and basic punctuation are
    supported. Unsupported characters are displayed as question marks.

.PARAMETER Scale
    Enlarges the banner horizontally and vertically. Valid values are 1-5.

.PARAMETER ForegroundColor
    Console color used when displaying the banner.

.PARAMETER NoClear
    Keeps existing console output instead of clearing the screen first.

.EXAMPLE
    .\Show-AsciiBanner.ps1 "CODEX"
    Displays CODEX in the default cyan block font.

.EXAMPLE
    .\Show-AsciiBanner.ps1 "LOADING" -Scale 2 -ForegroundColor Green
    Displays a larger green LOADING banner.

.EXAMPLE
    .\Show-AsciiBanner.ps1 "WELCOME" -NoClear
    Displays WELCOME without clearing previous output.

.NOTES
    View this help with:
        Get-Help .\Show-AsciiBanner.ps1 -Detailed
    List examples with:
        Get-Help .\Show-AsciiBanner.ps1 -Examples
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Text = 'CODEX',

    [ValidateRange(1, 5)]
    [int] $Scale = 1,

    [ConsoleColor] $ForegroundColor = [ConsoleColor]::Cyan,

    [switch] $NoClear
)

# A small, dependency-free 5x7 font. Use two characters per pixel so the
# result looks proportionate in a normal PowerShell console.
$Font = @{
    'A' = @('01110','10001','10001','11111','10001','10001','10001')
    'B' = @('11110','10001','10001','11110','10001','10001','11110')
    'C' = @('01111','10000','10000','10000','10000','10000','01111')
    'D' = @('11110','10001','10001','10001','10001','10001','11110')
    'E' = @('11111','10000','10000','11110','10000','10000','11111')
    'F' = @('11111','10000','10000','11110','10000','10000','10000')
    'G' = @('01111','10000','10000','10111','10001','10001','01111')
    'H' = @('10001','10001','10001','11111','10001','10001','10001')
    'I' = @('11111','00100','00100','00100','00100','00100','11111')
    'J' = @('00111','00010','00010','00010','00010','10010','01100')
    'K' = @('10001','10010','10100','11000','10100','10010','10001')
    'L' = @('10000','10000','10000','10000','10000','10000','11111')
    'M' = @('10001','11011','10101','10101','10001','10001','10001')
    'N' = @('10001','11001','10101','10011','10001','10001','10001')
    'O' = @('01110','10001','10001','10001','10001','10001','01110')
    'P' = @('11110','10001','10001','11110','10000','10000','10000')
    'Q' = @('01110','10001','10001','10001','10101','10010','01101')
    'R' = @('11110','10001','10001','11110','10100','10010','10001')
    'S' = @('01111','10000','10000','01110','00001','00001','11110')
    'T' = @('11111','00100','00100','00100','00100','00100','00100')
    'U' = @('10001','10001','10001','10001','10001','10001','01110')
    'V' = @('10001','10001','10001','10001','10001','01010','00100')
    'W' = @('10001','10001','10001','10101','10101','11011','10001')
    'X' = @('10001','10001','01010','00100','01010','10001','10001')
    'Y' = @('10001','10001','01010','00100','00100','00100','00100')
    'Z' = @('11111','00001','00010','00100','01000','10000','11111')
    '0' = @('01110','10001','10011','10101','11001','10001','01110')
    '1' = @('00100','01100','00100','00100','00100','00100','01110')
    '2' = @('01110','10001','00001','00010','00100','01000','11111')
    '3' = @('11110','00001','00001','01110','00001','00001','11110')
    '4' = @('00010','00110','01010','10010','11111','00010','00010')
    '5' = @('11111','10000','10000','11110','00001','00001','11110')
    '6' = @('01110','10000','10000','11110','10001','10001','01110')
    '7' = @('11111','00001','00010','00100','01000','01000','01000')
    '8' = @('01110','10001','10001','01110','10001','10001','01110')
    '9' = @('01110','10001','10001','01111','00001','00001','01110')
    '!' = @('00100','00100','00100','00100','00100','00000','00100')
    '?' = @('01110','10001','00001','00010','00100','00000','00100')
    '-' = @('00000','00000','00000','11111','00000','00000','00000')
    '_' = @('00000','00000','00000','00000','00000','00000','11111')
    '.' = @('00000','00000','00000','00000','00000','00110','00110')
}

if (-not $NoClear) { Clear-Host }

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($row in 0..6) {
    $line = [System.Text.StringBuilder]::new()
    foreach ($character in $Text.ToUpperInvariant().ToCharArray()) {
        $key = [string]$character
        if ($key -eq ' ') {
            $glyph = @('00000','00000','00000','00000','00000','00000','00000')
        } elseif ($Font.ContainsKey($key)) {
            $glyph = $Font[$key]
        } else {
            $glyph = $Font['?']
        }

        [void]$line.Append(' ')
        foreach ($pixel in $glyph[$row].ToCharArray()) {
            $cell = if ($pixel -eq '1') { '██' } else { '  ' }
            1..$Scale | ForEach-Object {
                [void]$line.Append($cell)
            }
        }
        [void]$line.Append(' ')
    }

    1..$Scale | ForEach-Object { [void]$lines.Add($line.ToString()) }
}

foreach ($line in $lines) {
    Write-Host $line -ForegroundColor $ForegroundColor
}
