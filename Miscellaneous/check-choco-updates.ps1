# check-choco-updates.ps1
# Monitors Chocolatey package updates and shows Windows notification
# Revision 1.0 | Author: Jason Lamb with help from Claude

param(
    [string]$LogPath = "$psexports\choco-updates.log"
)

# Ensure log directory exists
if (-not (Test-Path (Split-Path $LogPath))) {
    New-Item -ItemType Directory -Path (Split-Path $LogPath) -Force | Out-Null
}

# Get outdated packages
$outdated = choco outdated --limit-output 2>&1 | Where-Object { $_ -match '\|' }
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($outdated) {
    # Log the update
    Add-Content -Path $LogPath -Value "$timestamp - OUTDATED PACKAGES FOUND:`n$($outdated -join "`n")`n"
    
    # Create notification message
    $packages = $outdated | ConvertFrom-Csv -Delimiter '|' -Header 'Package','CurrentVersion','AvailableVersion','Pinned'
    $title = "Chocolatey Updates Available"
    $message = ($packages | ForEach-Object { "$($_.Package): $($_.CurrentVersion) → $($_.AvailableVersion)" }) -join "`n"
    
    # Show Windows notification popup
    $action = { Start-Process pwsh -ArgumentList "-NoExit -Command `"choco upgrade all`"" }
    New-BurntToastNotification -Text $title, $message -SnoozeAndDismiss -ExpirationTime (Get-Date).AddHours(1) -ActivatedAction $action
    
} else {
    Add-Content -Path $LogPath -Value "$timestamp - No outdated packages`n"
}