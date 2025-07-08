# Notification System Demo
# Author: Jason Lamb (jasrasr)
# Created: 2024-07-08
# Description: Demonstrates the notification system with read/unread status

# Import the notification manager
. "$PSScriptRoot\NotificationManager.ps1"

# Clear the screen for better demo presentation
Clear-Host

Write-Host "=== NOTIFICATION SYSTEM DEMO ===" -ForegroundColor Cyan
Write-Host "This demo shows how to use the notification system with read/unread status.`n" -ForegroundColor White

# Demo 1: Create some sample notifications
Write-Host "1. Creating sample notifications..." -ForegroundColor Green
$notification1 = New-Notification -Title "System Update Available" -Message "A new system update is available for installation" -Type "Info" -Category "System"
$notification2 = New-Notification -Title "Low Disk Space" -Message "Your C: drive is running low on space (less than 5GB remaining)" -Type "Warning" -Category "System"
$notification3 = New-Notification -Title "Backup Failed" -Message "The scheduled backup to external drive failed at 2:00 AM" -Type "Error" -Category "Backup"
$notification4 = New-Notification -Title "Script Execution Complete" -Message "The data processing script has completed successfully" -Type "Success" -Category "Automation"

Start-Sleep -Seconds 2

# Demo 2: Show all notifications
Write-Host "`n2. Showing all notifications..." -ForegroundColor Green
Show-Notifications

# Demo 3: Mark some notifications as read
Write-Host "`n3. Marking first notification as read..." -ForegroundColor Green
Set-NotificationRead -Id $notification1.Id

# Demo 4: Show unread notifications only
Write-Host "`n4. Showing unread notifications only..." -ForegroundColor Green
Show-Notifications -UnreadOnly

# Demo 5: Get notification statistics
Write-Host "`n5. Getting notification statistics..." -ForegroundColor Green
$stats = Get-NotificationStatistics
Write-Host "Statistics:" -ForegroundColor Cyan
Write-Host "  Total: $($stats.Total)" -ForegroundColor White
Write-Host "  Unread: $($stats.Unread)" -ForegroundColor Yellow
Write-Host "  Read: $($stats.Read)" -ForegroundColor Green
Write-Host "  By Type:" -ForegroundColor White
foreach ($type in $stats.ByType.Keys) {
    Write-Host "    $type : $($stats.ByType[$type])" -ForegroundColor Gray
}
Write-Host "  By Category:" -ForegroundColor White
foreach ($category in $stats.ByCategory.Keys) {
    Write-Host "    $category : $($stats.ByCategory[$category])" -ForegroundColor Gray
}

# Demo 6: Mark a notification as unread
Write-Host "`n6. Marking first notification as unread again..." -ForegroundColor Green
Set-NotificationUnread -Id $notification1.Id

# Demo 7: Show notifications filtered by type
Write-Host "`n7. Showing only Error notifications..." -ForegroundColor Green
Show-Notifications -Type "Error"

# Demo 8: Show notifications filtered by category
Write-Host "`n8. Showing only System notifications..." -ForegroundColor Green
Show-Notifications -Category "System"

Write-Host "`n=== DEMO COMPLETE ===" -ForegroundColor Cyan
Write-Host "You can now use the notification system with the following commands:" -ForegroundColor White
Write-Host "  • New-Notification        - Create a new notification" -ForegroundColor Gray
Write-Host "  • Get-Notifications       - Retrieve notifications with filters" -ForegroundColor Gray
Write-Host "  • Show-Notifications      - Display notifications in formatted output" -ForegroundColor Gray
Write-Host "  • Set-NotificationRead    - Mark notification as read" -ForegroundColor Gray
Write-Host "  • Set-NotificationUnread  - Mark notification as unread" -ForegroundColor Gray
Write-Host "  • Get-NotificationStatistics - Get summary statistics" -ForegroundColor Gray
Write-Host "  • Remove-Notification     - Remove a specific notification" -ForegroundColor Gray
Write-Host "  • Clear-Notifications     - Clear all or read-only notifications" -ForegroundColor Gray

Write-Host "`nNotifications are stored in: $env:APPDATA\PowerShell\Notifications\notifications.json" -ForegroundColor Yellow