<#
.SYNOPSIS
    Animates a large ASCII banner with a loading spinner.

.EXAMPLE
    .\Show-AnimatedBanner.ps1 "CODEX" -Scale 2 -Cycles 30

.EXAMPLE
    .\Show-AnimatedBanner.ps1 "LOADING" -ForegroundColor Green
    Runs continuously until Ctrl+C is pressed.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Text = 'CODEX',

    [ValidateRange(1, 5)]
    [int] $Scale = 1,

    [ConsoleColor] $ForegroundColor = [ConsoleColor]::Cyan,

    [ValidateRange(25, 2000)]
    [int] $DelayMilliseconds = 120,

    [ValidateRange(0, 1000000)]
    [int] $Cycles = 0
)

$bannerScript = Join-Path $PSScriptRoot 'Show-AsciiBanner.ps1'
$spinner = @('|', '/', '-', '\')
$frame = 0

try {
    while (($Cycles -eq 0) -or ($frame -lt $Cycles)) {
        Clear-Host
        & $bannerScript $Text -Scale $Scale -ForegroundColor $ForegroundColor -NoClear
        Write-Host "`n  $($spinner[$frame % $spinner.Count])  Loading..." -ForegroundColor DarkGray
        $frame++
        Start-Sleep -Milliseconds $DelayMilliseconds
    }
}
finally {
    Clear-Host
}
