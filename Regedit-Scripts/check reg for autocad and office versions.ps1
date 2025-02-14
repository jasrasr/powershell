
# Define the version to check
$TargetVersion = "16.0.18227.20162"

# Define registry paths for Office
$OfficePaths = @(
    "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration"
)

# Check each path for Office version
$FoundVersion = $false
foreach ($Path in $OfficePaths) {
    if (Test-Path $Path) {
        $OfficeVersion = Get-ItemProperty -Path $Path | Select-Object -ExpandProperty VersionToReport
        if ($OfficeVersion -eq $TargetVersion) {
            Write-Host "Found Office 365 Version: $OfficeVersion at $Path" -ForegroundColor Green
            $FoundVersion = $true
            break
        } elseif ($OfficeVersion) {
            Write-Host "Office 365 Version: $OfficeVersion found, but does not match the target version." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Path does not exist: $Path" -ForegroundColor Red
    }
}

if (-not $FoundVersion) {
    Write-Host "Target Office 365 version ($TargetVersion) not found in the registry." -ForegroundColor Red
}

# Define registry keys to check for AutoCAD
$RegistryKeys = @(
    "HKLM:\SOFTWARE\Autodesk\AutoCAD\R25.0\ACAD-8107\Variables",
    "HKLM:\SOFTWARE\Autodesk\AutoCAD\R24.3\ACAD-7107\Variables",
    "HKLM:\SOFTWARE\Autodesk\AutoCAD\R24.2\ACAD-6107\Variables",
    "HKLM:\SOFTWARE\Autodesk\AutoCAD\R24.1\ACAD-5107\Variables"
)

# Check each registry key for AutoCAD and output the result
foreach ($Key in $RegistryKeys) {
    Write-Host "Checking: $Key..."
    if (Test-Path $Key) {
        Write-Host "  => Found: $Key" -ForegroundColor Green
    } else {
        Write-Host "  => Not Found: $Key" -ForegroundColor Red
    }
}
