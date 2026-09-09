<#
    Author:      Jason Lamb
    Date:        2026-09-08
    Description: Displays a countdown timer to a given date/time, either as big
                 block-digit ASCII art scaled to fill the current terminal window,
                 or as a full-screen-capable HTML page opened in the default web browser.

    Examples:
        # Terminal countdown to New Year's - fills whatever size the terminal window already is
        .\Show-Countdown.ps1 -TargetDateTime "2027-01-01 00:00:00" -Message "Happy New Year!"

        # Same, but also maximize the terminal window first
        .\Show-Countdown.ps1 -TargetDateTime "2027-01-01 00:00:00" -Message "Happy New Year!" -Maximize

        # Web countdown, opened in the default browser
        .\Show-Countdown.ps1 -TargetDateTime "2026-12-25 08:00" -Message "Christmas Morning" -Mode Web

        # Web countdown saved to a specific file instead of a temp file
        .\Show-Countdown.ps1 -TargetDateTime (Get-Date).AddHours(2) -Mode Web -OutputPath C:\Temp\countdown.html

        # Time only (no date) -> assumes today; if that time already passed today, rolls to tomorrow
        .\Show-Countdown.ps1 -TargetDateTime "17:00" -Message "Quitting Time"

        # Analog clock face (terminal only) instead of big digits
        .\Show-Countdown.ps1 -TargetDateTime "17:00" -Message "Quitting Time" -Style Analog
#>

[CmdletBinding()]
param(
    # Accepts a full date/time (e.g. "2026-12-25 17:00") or just a time (e.g. "17:00", "5:00 PM").
    # A time-only value assumes today's date, rolling to tomorrow if that time has already passed.
    [Parameter(Mandatory = $true)]
    [string]$TargetDateTime,

    [string]$Message = "Countdown",

    [ValidateSet('Terminal', 'Web')]
    [string]$Mode = 'Terminal',

    # Terminal mode only: big block digits, or an analog clock face with sweeping hands.
    [ValidateSet('Digital', 'Analog')]
    [string]$Style = 'Digital',

    # Web mode only: where to write the HTML file. Defaults to a temp file.
    [string]$OutputPath,

    # Terminal mode only: suppress the beep when the countdown reaches zero.
    [switch]$NoBeep,

    # Terminal mode only: maximize the console window on start. Off by default -
    # the countdown just scales to fill whatever size the terminal window already is.
    [switch]$Maximize
)

$parsedTarget = [datetime]::MinValue
if (-not [datetime]::TryParse($TargetDateTime, [ref]$parsedTarget)) {
    throw "Unable to parse -TargetDateTime '$TargetDateTime'. Use a format like '2026-12-25 17:00' or just a time like '17:00'."
}

# If the input has no date component (just a time), .NET already defaults it to today.
# If that resolved moment is already in the past, assume the caller means the next occurrence, i.e. tomorrow.
$hasDateComponent = $TargetDateTime -match '\d{4}|\d{1,2}\s*[/.-]\s*\d{1,2}|\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)|\b(mon|tue|wed|thu|fri|sat|sun)|\btoday\b|\btomorrow\b|\byesterday\b'
if (-not $hasDateComponent -and $parsedTarget -lt (Get-Date)) {
    $parsedTarget = $parsedTarget.AddDays(1)
    Write-Verbose "Time-only target already passed today; rolling forward to tomorrow: $parsedTarget"
}

[datetime]$TargetDateTime = $parsedTarget

#region Big-digit font (5 rows tall) used by the terminal renderer
# Digits are laid out as classic seven-segment displays: top bar, upper-left/upper-right
# verticals, middle bar, lower-left/lower-right verticals, bottom bar - each segment either
# fully on or fully off, so digits read like a real digital clock instead of solid blobs.
$script:BigFont = @{
    '0' = @(' ███ ', '█   █', '     ', '█   █', ' ███ ')
    '1' = @('     ', '    █', '     ', '    █', '     ')
    '2' = @(' ███ ', '    █', ' ███ ', '█    ', ' ███ ')
    '3' = @(' ███ ', '    █', ' ███ ', '    █', ' ███ ')
    '4' = @('     ', '█   █', ' ███ ', '    █', '     ')
    '5' = @(' ███ ', '█    ', ' ███ ', '    █', ' ███ ')
    '6' = @(' ███ ', '█    ', ' ███ ', '█   █', ' ███ ')
    '7' = @(' ███ ', '    █', '     ', '    █', '     ')
    '8' = @(' ███ ', '█   █', ' ███ ', '█   █', ' ███ ')
    '9' = @(' ███ ', '█   █', ' ███ ', '    █', ' ███ ')
    ':' = @('     ', '  █  ', '     ', '  █  ', '     ')
    ' ' = @('     ', '     ', '     ', '     ', '     ')
    '-' = @('     ', '     ', '█████', '     ', '     ')
    '!' = @('  █  ', '  █  ', '  █  ', '     ', '  █  ')
    'D' = @('████ ', '█   █', '█   █', '█   █', '████ ')
    'T' = @('█████', '  █  ', '  █  ', '  █  ', '  █  ')
    'I' = @('█████', '  █  ', '  █  ', '  █  ', '█████')
    'M' = @('█   █', '██ ██', '█ █ █', '█   █', '█   █')
    'E' = @('█████', '█    ', '████ ', '█    ', '█████')
    'S' = @('█████', '█    ', '████ ', '    █', '████ ')
    'U' = @('█   █', '█   █', '█   █', '█   █', ' ███ ')
    'P' = @('████ ', '█   █', '████ ', '█    ', '█    ')
    "'" = @('  █  ', '  █  ', '     ', '     ', '     ')
}
#endregion

function Get-ScaledBigTextLines {
    param(
        [string]$Text,
        [int]$VScale = 1,
        [int]$HScale = 1
    )

    $glyphs = foreach ($ch in $Text.ToCharArray()) {
        $g = $script:BigFont[[string]$ch]
        if (-not $g) { $g = $script:BigFont[' '] }
        , $g
    }

    $lines = New-Object System.Collections.Generic.List[string]
    for ($row = 0; $row -lt 5; $row++) {
        $rowText = ($glyphs | ForEach-Object {
            -join ($_[$row].ToCharArray() | ForEach-Object { [string]$_ * $HScale })
        }) -join (' ' * $HScale)

        for ($v = 0; $v -lt $VScale; $v++) { $lines.Add($rowText) }
    }
    return $lines
}

# Draws a straight line of $Char into $Grid between two [row,col] points (Bresenham).
function Set-GridLine {
    param($Grid, [int]$R0, [int]$C0, [int]$R1, [int]$C1, [char]$Char)

    $dr = [Math]::Abs($R1 - $R0)
    $dc = [Math]::Abs($C1 - $C0)
    $sr = if ($R0 -lt $R1) { 1 } else { -1 }
    $sc = if ($C0 -lt $C1) { 1 } else { -1 }
    $err = $dc - $dr
    $r = $R0; $c = $C0
    $rows = $Grid.GetLength(0); $cols = $Grid.GetLength(1)

    while ($true) {
        if ($r -ge 0 -and $r -lt $rows -and $c -ge 0 -and $c -lt $cols) { $Grid[$r, $c] = $Char }
        if ($r -eq $R1 -and $c -eq $C1) { break }
        $e2 = 2 * $err
        if ($e2 -gt -$dr) { $err -= $dr; $c += $sc }
        if ($e2 -lt $dc) { $err += $dc; $r += $sr }
    }
}

# Renders an analog clock face (circle + hour/minute/second hands) as an array of strings,
# sized to fit within the given character budget. Hands represent the given H:M:S position
# on a 12-hour dial (0 degrees = 12 o'clock, clockwise). Columns are stretched 2x relative to
# rows so the circle reads as round despite terminal character cells being taller than wide.
function Get-AnalogClockLines {
    param(
        [int]$Hours,
        [int]$Minutes,
        [int]$Seconds,
        [int]$AvailableWidth,
        [int]$AvailableHeight
    )

    $rv = [Math]::Max(3, [Math]::Min([int][Math]::Floor($AvailableHeight / 2), [int][Math]::Floor($AvailableWidth / 4)))
    $gh = $rv * 2 + 1
    $gw = $rv * 4 + 1
    $cy = $rv
    $cx = $rv * 2

    $grid = New-Object 'char[,]' $gh, $gw
    for ($r = 0; $r -lt $gh; $r++) { for ($c = 0; $c -lt $gw; $c++) { $grid[$r, $c] = ' ' } }

    for ($deg = 0; $deg -lt 360; $deg += 2) {
        $rad = $deg * [Math]::PI / 180
        $col = $cx + [int][Math]::Round(2 * $rv * [Math]::Sin($rad))
        $row = $cy - [int][Math]::Round($rv * [Math]::Cos($rad))
        if ($row -ge 0 -and $row -lt $gh -and $col -ge 0 -and $col -lt $gw) { $grid[$row, $col] = '·' }
    }

    # Tick marks at 12, 3, 6, 9.
    foreach ($deg in 0, 90, 180, 270) {
        $rad = $deg * [Math]::PI / 180
        $col = $cx + [int][Math]::Round(2 * $rv * [Math]::Sin($rad))
        $row = $cy - [int][Math]::Round($rv * [Math]::Cos($rad))
        if ($row -ge 0 -and $row -lt $gh -and $col -ge 0 -and $col -lt $gw) { $grid[$row, $col] = 'o' }
    }

    function Get-HandEndpoint {
        param([double]$AngleDeg, [double]$LenFrac, [int]$Rv, [int]$Cx, [int]$Cy)
        $rad = $AngleDeg * [Math]::PI / 180
        $col = $Cx + [int][Math]::Round(2 * $Rv * $LenFrac * [Math]::Sin($rad))
        $row = $Cy - [int][Math]::Round($Rv * $LenFrac * [Math]::Cos($rad))
        return , @($row, $col)
    }

    $hourAngle = (($Hours % 12) + $Minutes / 60.0) / 12 * 360
    $minAngle = ($Minutes + $Seconds / 60.0) / 60 * 360
    $secAngle = $Seconds / 60.0 * 360

    $hp = Get-HandEndpoint -AngleDeg $hourAngle -LenFrac 0.5 -Rv $rv -Cx $cx -Cy $cy
    Set-GridLine -Grid $grid -R0 $cy -C0 $cx -R1 $hp[0] -C1 $hp[1] -Char '█'

    $mp = Get-HandEndpoint -AngleDeg $minAngle -LenFrac 0.8 -Rv $rv -Cx $cx -Cy $cy
    Set-GridLine -Grid $grid -R0 $cy -C0 $cx -R1 $mp[0] -C1 $mp[1] -Char '█'

    $sp = Get-HandEndpoint -AngleDeg $secAngle -LenFrac 0.95 -Rv $rv -Cx $cx -Cy $cy
    Set-GridLine -Grid $grid -R0 $cy -C0 $cx -R1 $sp[0] -C1 $sp[1] -Char '.'

    $grid[$cy, $cx] = '#'

    $lines = New-Object System.Collections.Generic.List[string]
    for ($r = 0; $r -lt $gh; $r++) {
        $sb = New-Object System.Text.StringBuilder
        for ($c = 0; $c -lt $gw; $c++) { [void]$sb.Append($grid[$r, $c]) }
        $lines.Add($sb.ToString())
    }
    return $lines
}

# Native helper to maximize whichever window currently has focus (the console/terminal window
# the user launched this script from), used to approximate a "full screen" terminal experience.
if ($IsWindows -and -not ('CountdownNative' -as [type])) {
    Add-Type -Name CountdownNative -Namespace 'Countdown' -MemberDefinition @'
        [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'@ -ErrorAction SilentlyContinue
}

function Set-ConsoleFullScreen {
    if (-not $IsWindows) { return }
    try {
        $hwnd = [Countdown.CountdownNative]::GetForegroundWindow()
        if ($hwnd -ne [IntPtr]::Zero) {
            [Countdown.CountdownNative]::ShowWindow($hwnd, 3) | Out-Null # SW_MAXIMIZE
        }
        Start-Sleep -Milliseconds 150

        $raw = $Host.UI.RawUI
        $max = $raw.MaxWindowSize
        $buffer = $raw.BufferSize
        if ($buffer.Width -lt $max.Width) { $buffer.Width = $max.Width }
        if ($buffer.Height -lt $max.Height) { $buffer.Height = $max.Height }
        $raw.BufferSize = $buffer
        $raw.WindowSize = $max
    }
    catch {
        Write-Verbose "Could not maximize console window: $_"
    }
}

function Show-TerminalCountdown {
    param(
        [datetime]$Target,
        [string]$Msg,
        [ValidateSet('Digital', 'Analog')]
        [string]$Style = 'Digital',
        [switch]$SuppressBeep,
        [switch]$DoMaximize
    )

    $originalCursorVisible = $true
    try { $originalCursorVisible = [Console]::CursorVisible } catch {}

    try {
        if ($DoMaximize) { Set-ConsoleFullScreen }

        [Console]::CursorVisible = $false
        Clear-Host

        $lastRenderedSecond = $null
        $finished = $false

        while ($true) {
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq 'Escape') { break }
            }

            $remaining = $Target - (Get-Date)
            $currentSecond = [math]::Floor($remaining.TotalSeconds)

            if ($currentSecond -ne $lastRenderedSecond) {
                $lastRenderedSecond = $currentSecond
                $width = $Host.UI.RawUI.WindowSize.Width
                $height = $Host.UI.RawUI.WindowSize.Height

                if ($remaining.TotalSeconds -le 0 -and -not $finished) {
                    $finished = $true
                    if (-not $SuppressBeep) { [Console]::Beep(1000, 400) }
                }

                $useAnalog = $false
                if ($finished) {
                    $bigText = "TIME'S UP!"
                } elseif ($remaining.TotalSeconds -gt 0) {
                    $days = [int][math]::Floor($remaining.TotalDays)
                    if ($days -gt 0) {
                        $bigText = "{0}D {1:D2}:{2:D2}:{3:D2}" -f $days, $remaining.Hours, $remaining.Minutes, $remaining.Seconds
                    } else {
                        $bigText = "{0:D2}:{1:D2}:{2:D2}" -f $remaining.Hours, $remaining.Minutes, $remaining.Seconds
                    }
                    $useAnalog = ($Style -eq 'Analog')
                } else {
                    $bigText = "00:00:00"
                }

                # Other (non-big-text) lines: message, target, blank, [analog caption], blank, instructions.
                $chromeLines = if ($useAnalog) { 6 } else { 5 }
                $availableHeight = [math]::Max(5, $height - $chromeLines)
                $availableWidth = [math]::Max(10, $width - 2)

                if ($useAnalog) {
                    $coreLines = Get-AnalogClockLines -Hours $remaining.Hours -Minutes $remaining.Minutes -Seconds $remaining.Seconds -AvailableWidth $availableWidth -AvailableHeight $availableHeight
                } else {
                    # Scale rows and columns by the same factor (a character cell is already
                    # taller than it is wide, so equal counts still read as tall block digits).
                    $scale = 1
                    while ($true) {
                        $next = $scale + 1
                        $neededHeight = 5 * $next
                        $neededWidth = ($bigText.Length * 5 * $next) + (($bigText.Length - 1) * $next)
                        if ($neededHeight -le $availableHeight -and $neededWidth -le $availableWidth) {
                            $scale = $next
                        } else {
                            break
                        }
                    }
                    $coreLines = Get-ScaledBigTextLines -Text $bigText -VScale $scale -HScale $scale
                }

                $frame = New-Object System.Collections.Generic.List[string]
                $blockHeight = $coreLines.Count + $chromeLines
                $topPad = [math]::Max(0, [int](($height - $blockHeight) / 2))

                for ($i = 0; $i -lt $topPad; $i++) { $frame.Add('') }

                $frame.Add($Msg)
                $frame.Add("Target: $($Target.ToString('yyyy-MM-dd HH:mm:ss'))")
                $frame.Add('')

                foreach ($line in $coreLines) { $frame.Add($line) }

                if ($useAnalog) { $frame.Add($bigText) }

                $frame.Add('')
                $frame.Add('Press Esc or Ctrl+C to exit')

                while ($frame.Count -lt $height) { $frame.Add('') }

                for ($row = 0; $row -lt $height -and $row -lt $frame.Count; $row++) {
                    $text = $frame[$row]
                    if ($text.Length -gt $width) { $text = $text.Substring(0, $width) }
                    $padded = $text.PadLeft(([math]::Max($text.Length, [int](($width + $text.Length) / 2))))
                    $padded = $padded.PadRight($width)
                    [Console]::SetCursorPosition(0, $row)
                    [Console]::Out.Write($padded)
                }
            }

            Start-Sleep -Milliseconds 100
        }
    }
    finally {
        [Console]::CursorVisible = $originalCursorVisible
        Write-Host ""
    }
}

function New-WebCountdownFile {
    param(
        [datetime]$Target,
        [string]$Msg,
        [string]$Path
    )

    $encodedMsg = [System.Net.WebUtility]::HtmlEncode($Msg)
    $jsMsg = ($Msg -replace '\\', '\\\\' -replace "'", "\'")
    $targetIso = $Target.ToString("yyyy-MM-ddTHH:mm:ss")

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>$encodedMsg</title>
<style>
  html, body {
    margin: 0; padding: 0; height: 100%; width: 100%;
    background: #000; color: #fff;
    font-family: 'Consolas', 'Courier New', monospace;
    overflow: hidden;
  }
  #wrap {
    height: 100vh; width: 100vw;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    text-align: center;
  }
  #message { font-size: 4vw; margin-bottom: 1vh; }
  #target { font-size: 1.5vw; color: #999; margin-bottom: 3vh; }
  #countdown { font-size: 14vw; font-weight: bold; letter-spacing: 0.05em; }
  #countdown.finished { color: #ff3b3b; }
  #labels { font-size: 1.2vw; color: #999; margin-top: 1vh; letter-spacing: 0.3em; }
  #fsBtn {
    position: absolute; top: 16px; right: 16px;
    background: #222; color: #fff; border: 1px solid #555;
    padding: 8px 14px; font-size: 14px; cursor: pointer; border-radius: 4px;
  }
  #fsBtn:hover { background: #333; }
</style>
</head>
<body>
<button id="fsBtn" onclick="document.documentElement.requestFullscreen()">Fullscreen</button>
<div id="wrap">
  <div id="message">$encodedMsg</div>
  <div id="target">Target: $($Target.ToString('yyyy-MM-dd HH:mm:ss'))</div>
  <div id="countdown">--:--:--:--</div>
  <div id="labels">DAYS&nbsp;&nbsp;&nbsp;&nbsp;HOURS&nbsp;&nbsp;&nbsp;&nbsp;MIN&nbsp;&nbsp;&nbsp;&nbsp;SEC</div>
</div>
<script>
  const target = new Date('$targetIso');
  const el = document.getElementById('countdown');
  const msg = '$jsMsg';

  function update() {
    const now = new Date();
    const diff = target - now;

    if (diff <= 0) {
      el.textContent = "TIME'S UP!";
      el.classList.add('finished');
      clearInterval(timer);
      return;
    }

    const totalSeconds = Math.floor(diff / 1000);
    const days = Math.floor(totalSeconds / 86400);
    const hours = Math.floor((totalSeconds % 86400) / 3600);
    const mins = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;

    const pad = n => String(n).padStart(2, '0');
    el.textContent = pad(days) + ':' + pad(hours) + ':' + pad(mins) + ':' + pad(secs);
  }

  update();
  const timer = setInterval(update, 1000);
</script>
</body>
</html>
"@

    Set-Content -Path $Path -Value $html -Encoding UTF8
}

if ($Mode -eq 'Terminal') {
    Show-TerminalCountdown -Target $TargetDateTime -Msg $Message -Style $Style -SuppressBeep:$NoBeep -DoMaximize:$Maximize
}
else {
    if (-not $OutputPath) {
        $OutputPath = Join-Path ([System.IO.Path]::GetTempPath()) "countdown-$([guid]::NewGuid().ToString('N')).html"
    }

    New-WebCountdownFile -Target $TargetDateTime -Msg $Message -Path $OutputPath
    Write-Host "Countdown page written to: $OutputPath"
    Start-Process $OutputPath
}
