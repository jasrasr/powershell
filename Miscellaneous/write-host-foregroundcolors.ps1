# Demonstrate Write-Host with various ForegroundColor options
write-host 'White' -foregroundcolor White
write-host 'Gray' -foregroundcolor Gray
write-host 'DarkGray' -foregroundcolor DarkGray
write-host 'Black' -foregroundcolor Black
write-host 'Green' -foregroundcolor Green
write-host 'Green' -foregroundcolor Green
write-host 'DarkGreen' -foregroundcolor DarkGreen
write-host 'Cyan' -foregroundcolor Cyan
write-host 'DarkCyan' -foregroundcolor DarkCyan
write-host 'Red' -foregroundcolor Red
write-host 'DarkRed' -foregroundcolor DarkRed
write-host 'Magenta' -foregroundcolor Magenta
write-host 'DarkMagenta' -foregroundcolor DarkMagenta
write-host 'Yellow' -foregroundcolor Yellow
write-host 'DarkYellow' -foregroundcolor DarkYellow
write-host 'Blue' -foregroundcolor Blue
write-host 'DarkBlue' -foregroundcolor DarkBlue


# Define an array of color names (must match valid console color names)
$colors = @(
'White',
'Gray',
'DarkGray',
'Black',
'Green',
'Green',
'DarkGreen',
'Cyan',
'DarkCyan',
'Red',
'DarkRed',
'Magenta',
'DarkMagenta',
'Yellow',
'DarkYellow',
'Blue',
'DarkBlue'
)

# Pick one at random
$randomColor = Get-Random -InputObject $colors

# Use it
Write-Host "Hello in a random color" -ForegroundColor $randomColor

