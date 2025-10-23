# Paths
$coreConsolePath = "C:\Program Files\Autodesk\AutoCAD 2026\accoreconsole.exe"
$scriptFile     = "C:\Temp\193-Scrubber-Oil\autopurge.scr"
$dwgFull        = "C:\Temp\193-Scrubber-Oil\193-P-1908.dwg"

Write-Host "Purging file: $dwgFull" -ForegroundColor Cyan

# Construct the argument list with quoted paths for spaces
$args = @(
    "/i",  "`"$dwgFull`"",
    "/s",  "`"$scriptFile`""
)   

# Run CoreConsole
$proc = Start-Process -FilePath $coreConsolePath -ArgumentList $args -Wait -NoNewWindow -PassThru

if ($proc.ExitCode -ne 0) {
    Write-Host "❌ Error purging $dwgFull (ExitCode: $($proc.ExitCode))" -ForegroundColor Red
} else {
    Write-Host "✅ OK: $dwgFull" -ForegroundColor Green
}
