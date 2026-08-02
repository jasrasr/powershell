# Paths
$coreConsolePath = "C:\Program Files\Autodesk\AutoCAD 2026\accoreconsole.exe"
$scriptFile     = "C:\folder\autopurge.scr"
$dwgFull        = "C:\folder\file.dwg"

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
