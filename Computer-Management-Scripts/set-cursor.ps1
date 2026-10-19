<#
.SYNOPSIS
  Applies a built-in Windows cursor scheme for the current user.
.EXAMPLE
  .\Set-Cursor.ps1                      # Windows Inverted (extra large)
  .\Set-Cursor.ps1 -Revert              # Windows Default
#>
param(
    [string]$Scheme = 'Windows Inverted (extra large)',
    [switch]$Revert
)

if ($Revert) { $Scheme = 'Windows Aero' }   # registry name for "Windows Default"

$schemes = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors\Schemes'
$name = (Get-Item $schemes).Property |
    Where-Object { $_ -eq $Scheme } |
    Select-Object -First 1
if (-not $name) { throw "Scheme '$Scheme' not found under $schemes" }

$paths = ((Get-ItemProperty $schemes).$name -split ',') |
    ForEach-Object { [Environment]::ExpandEnvironmentVariables($_) }
$keys = 'Arrow','Help','AppStarting','Wait','Crosshair','IBeam','NWPen','No',
        'SizeNS','SizeWE','SizeNWSE','SizeNESW','SizeAll','UpArrow','Hand','Pin','Person'

$cur = 'HKCU:\Control Panel\Cursors'

# Skip if the scheme name and every cursor file already match
$current = Get-ItemProperty $cur
$match = $current.'(default)' -eq $name
for ($i = 0; $match -and $i -lt $paths.Count -and $i -lt $keys.Count; $i++) {
    if ($current.($keys[$i]) -ne $paths[$i]) { $match = $false }
}
if ($match) { Write-Host "Already set: $name - no change"; return }

for ($i = 0; $i -lt $paths.Count -and $i -lt $keys.Count; $i++) {
    Set-ItemProperty $cur -Name $keys[$i] -Value $paths[$i]
}
Set-ItemProperty $cur -Name '(default)' -Value $name
Set-ItemProperty $cur -Name 'Scheme Source' -Value 2 -Type DWord   # 2 = system scheme

Add-Type -Namespace Win32 -Name Native -MemberDefinition '[DllImport("user32.dll",SetLastError=true)] public static extern bool SystemParametersInfo(uint a,uint b,IntPtr c,uint d);'
[Win32.Native]::SystemParametersInfo(0x57, 0, [IntPtr]::Zero, 0x1F) | Out-Null  # SPI_SETCURSORS

Write-Host "Applied: $name"
