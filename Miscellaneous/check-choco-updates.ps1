# check-choco-updates.ps1
# Monitors Chocolatey package updates and shows Windows notification
# Revision 1.0.1 (removed -ActivatedAction, toast failure no longer throws) | Author: Jason Lamb with help from Claude

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
    # -ActivatedAction removed: BurntToast 1.1.0 throws "Failed to register notification activator" with it.
    # A notification failure must never break the caller (profile scheduler), so fall back to console output.
    try {
        New-BurntToastNotification -Text $title, "$message`nRun: choco upgrade all" -SnoozeAndDismiss -ExpirationTime (Get-Date).AddHours(1) -ErrorAction Stop
    } catch {
        Write-Warning "Toast notification failed: $($_.Exception.Message)"
        Write-Host "$title`n$message`nRun: choco upgrade all" -ForegroundColor Yellow
    }

} else {
    Add-Content -Path $LogPath -Value "$timestamp - No outdated packages`n"
}