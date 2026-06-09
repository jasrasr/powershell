# Filename: Send-ToastNotification.ps1
# Revision : 1.0.1
# Description : Sends a Windows toast notification to the logged-on user's desktop.
#               Designed to run from PDQ Deploy (which runs as SYSTEM) by using a
#               temporary scheduled task to display the notification in the user's session.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-04-27
# Modified Date : 2026-04-27
# Changelog :
# 1.0.0 initial release
# 1.0.1 removed DeleteExpiredTaskAfter to fix EndBoundary XML error in scheduled task

param (
    [string]$Title   = "Alert",
    [string]$Message = "This is an automated notification.",
    [string]$AppName = "IT Notification",
    [ValidateSet("Short", "Long")]
    [string]$Duration = "Short"
)

# ---------------------------------------------------------------------------
# Build the toast notification XML payload
# ---------------------------------------------------------------------------
$toastXml = @"
<toast duration="$Duration">
  <visual>
    <binding template="ToastGeneric">
      <text>$Title</text>
      <text>$Message</text>
    </binding>
  </visual>
</toast>
"@

# Escape quotes so the XML survives being passed inside a scheduled task action
$escapedXml = $toastXml -replace '"', '\"'

# ---------------------------------------------------------------------------
# PowerShell code block that will run inside the user's session
# ---------------------------------------------------------------------------
$notifyScript = @"
`$xml = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType=WindowsRuntime]::new()
`$xml.LoadXml('$($toastXml -replace "'", "''")')
[void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime]
[void][Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType=WindowsRuntime]
`$toast = [Windows.UI.Notifications.ToastNotification]::new(`$xml)
`$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('$AppName')
`$notifier.Show(`$toast)
Start-Sleep -Seconds 5
"@

$encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($notifyScript))

# ---------------------------------------------------------------------------
# Detect the currently logged-on interactive user
# ---------------------------------------------------------------------------
$loggedOnUser = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName

if (-not $loggedOnUser) {
    Write-Host "No user is currently logged on. Toast notification not sent." -ForegroundColor Yellow
    exit 0
}

# Strip domain prefix if present (DOMAIN\username -> username)
$username = $loggedOnUser -replace '^.*\\', ''

Write-Host "Sending toast notification to: $loggedOnUser" -ForegroundColor Cyan
Write-Host "Title   : $Title"
Write-Host "Message : $Message"

# ---------------------------------------------------------------------------
# Create a temporary scheduled task that runs as the logged-on user
# This is required because PDQ runs scripts as SYSTEM, which has no desktop session
# ---------------------------------------------------------------------------
$taskName = "PDQ_ToastNotification_$(Get-Random)"

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -EncodedCommand $encodedScript"

$principal = New-ScheduledTaskPrincipal `
    -UserId $loggedOnUser `
    -LogonType Interactive `
    -RunLevel Limited

$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 1)

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(3)

try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Principal $principal `
        -Settings $settings `
        -Trigger $trigger `
        -Force | Out-Null

    Write-Host "Scheduled task '$taskName' registered. Notification will appear shortly." -ForegroundColor Green

    # Wait for the task to run, then clean it up
    Start-Sleep -Seconds 15

    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($task) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "Scheduled task cleaned up." -ForegroundColor Gray
    }
}
catch {
    Write-Host "ERROR: Failed to register scheduled task. $_" -ForegroundColor Red
    exit 1
}

# Example Usage:
#   .\Send-ToastNotification.ps1
#   .\Send-ToastNotification.ps1 -Title "Maintenance Window" -Message "Your computer will restart in 15 minutes."
#   .\Send-ToastNotification.ps1 -Title "IT Alert" -Message "Please save your work now." -Duration "Long"
#   .\Send-ToastNotification.ps1 -Title "Update Complete" -Message "Software installation finished." -AppName "PDQ Deploy"
