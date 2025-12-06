# Revision : 2.7
# Description : Animated Christmas tree with blinking star, alternating green/ornament lights,
#               brown trunk, extended greeting, hide cursor, and optional exit-on-key.
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-12-05

cls

# ===================================
# USER CONFIGURABLE SETTINGS
# ===================================
$RepeatCount   = 10       # Used only when $RunUntilKey = $false
$FrameDelayMS  = 80       # Milliseconds between frames
$RunUntilKey   = $true    # TRUE = keep animating until any key is pressed
$ExitOnKeyPress = $false   # TRUE = close the PowerShell window when key pressed
# ===================================

# Hide cursor during animation
[Console]::CursorVisible = $false

$starCounts = @(
0,
1,3,5,7,9,13,
7,11,15,19,
11,15,19,23,
13,17,19,23,
5,5,5
)

# Updated greeting with your extra lines
$greet = @(
    ""
    "A"
    "VERY"
    "MERRY"
    "CHRISTMAS"
    ""
    "AND"
    ""
    "OUR BEST WISHES"
    "FOR THE"
    "NEW YEAR"
    ""
    "Middough IT Department"
    ""
    ""
    ""
    ""
    "press any key to"
    "end/stop/exit"
)

# Allowed ornament colors (no black)
$ornamentColors = @(
    34,32,36,31,35,33,37,90,
    94,92,96,91,95,93,97
)

$maxStars = ($starCounts | Measure-Object -Maximum).Maximum
$indentBehindTree = 35

# Build tree rows once
$treeRows = foreach ($count in $starCounts) {
    $spaces = " " * [math]::Floor(($maxStars - $count) / 2 + 10)
    $spaces + ("*" * $count)
}

$maxLines = [math]::Max($treeRows.Count, $greet.Count)

# -------- FRAME GENERATION FUNCTION --------
function New-TreeFrame {
    param([int]$FrameIndex)

    $lines = New-Object System.Collections.Generic.List[string]
    $blinkColor = if ($FrameIndex % 2 -eq 0) { 97 } else { 93 }   # white ↔ light yellow

    for ($lineIndex = 0; $lineIndex -lt $maxLines; $lineIndex++) {

        $left  = if ($lineIndex -lt $treeRows.Count) { $treeRows[$lineIndex] } else { "" }
        $right = if ($lineIndex -lt $greet.Count)    { $greet[$lineIndex] }    else { "" }

        $paddedLeft = $left.PadRight($indentBehindTree + $maxStars)
        $out = ""
        $charPos = 0

        foreach ($char in $paddedLeft.ToCharArray()) {

            # Blinking top star
            if ($lineIndex -eq 1 -and $char -eq "*") {
                $out += "`e[${blinkColor}m*`e[0m"
            }
            # Trunk (last 3 lines)
            elseif ($lineIndex -ge ($treeRows.Count - 3) -and $char -eq "*") {
                $out += "`e[33m*`e[0m"   # DarkYellow
            }
            # Tree foliage
            elseif ($char -eq "*") {
                if ($charPos % 2 -eq 0) {
                    $out += "`e[32m*`e[0m"      # dark green
                } else {
                    $rnd = Get-Random $ornamentColors
                    $out += "`e[${rnd}m*`e[0m" # ornament
                }
            }
            else {
                $out += $char
            }

            $charPos++
        }

        # Greeting text (steady bright green)
        if ($right -ne "") {
            $out += "   `e[92m$right`e[0m"
        }

        $lines.Add($out)
    }

    return ,$lines
}

# -------- SHOW FRAME --------
function Show-Frame {
    param($frame)
    cls
    foreach ($line in $frame) {
        Write-Host $line
    }
}

# ===========================
# ANIMATION CONTROL
# ===========================

# --- MODE 1: UNTIL ANY KEY IS PRESSED ---
if ($RunUntilKey) {

    Write-Host "`nPress ANY KEY to stop the animation..." -ForegroundColor Cyan

    $frameIndex = 1

    while ($true) {

        if ([Console]::KeyAvailable) {

            # Clear key buffer
            $null = [Console]::ReadKey($true)

            # Restore cursor before exit
            [Console]::CursorVisible = $true

            if ($ExitOnKeyPress) {
                Stop-Process -Id $PID    # closes the PS window
            }

            break
        }

        $frame = New-TreeFrame -FrameIndex $frameIndex
        Show-Frame $frame

        Start-Sleep -Milliseconds $FrameDelayMS
        $frameIndex++
    }

}
else {

    # --- MODE 2: FIXED FRAME COUNT ---
    for ($i = 1; $i -le $RepeatCount; $i++) {
        $frame = New-TreeFrame -FrameIndex $i
        Show-Frame $frame
        Start-Sleep -Milliseconds $FrameDelayMS
    }

}

# Restore cursor if window did not close
[Console]::CursorVisible = $true
