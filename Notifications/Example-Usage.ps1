# Usage Example for Notification System
# Author: Jason Lamb (jasrasr)
# Created: 2024-07-08
# Description: Shows common usage patterns for the notification system

# Import the notification manager
. "$PSScriptRoot\NotificationManager.ps1"

# Clear any existing notifications for clean demo
Clear-Notifications -Force | Out-Null

Write-Host "=== NOTIFICATION SYSTEM USAGE EXAMPLE ===" -ForegroundColor Cyan

# Example 1: Create different types of notifications
Write-Host "`nExample 1: Creating notifications with different types" -ForegroundColor Green
New-Notification -Title "System Maintenance" -Message "System will be down for maintenance tonight" -Type "Warning" -Category "System"
New-Notification -Title "Deployment Complete" -Message "Application v2.1 has been deployed successfully" -Type "Success" -Category "Deployment"
New-Notification -Title "Security Alert" -Message "Unauthorized access attempt detected" -Type "Error" -Category "Security"

# Example 2: View all notifications
Write-Host "`nExample 2: Viewing all notifications" -ForegroundColor Green
Show-Notifications

# Example 3: Mark notifications as read
Write-Host "`nExample 3: Marking the first notification as read" -ForegroundColor Green
$notifications = Get-Notifications
if ($notifications.Count -gt 0) {
    Set-NotificationRead -Id $notifications[0].Id
}

# Example 4: View only unread notifications
Write-Host "`nExample 4: Viewing only unread notifications" -ForegroundColor Green
Show-Notifications -UnreadOnly

# Example 5: Filter notifications by type
Write-Host "`nExample 5: Viewing only Error notifications" -ForegroundColor Green
Show-Notifications -Type "Error"

# Example 6: Filter notifications by category
Write-Host "`nExample 6: Viewing only System notifications" -ForegroundColor Green
Show-Notifications -Category "System"

# Example 7: Get notification statistics
Write-Host "`nExample 7: Getting notification statistics" -ForegroundColor Green
$stats = Get-NotificationStatistics
Write-Host "Total notifications: $($stats.Total)" -ForegroundColor Cyan
Write-Host "Unread: $($stats.Unread)" -ForegroundColor Yellow
Write-Host "Read: $($stats.Read)" -ForegroundColor Green

# Example 8: Batch operations - mark all security notifications as read
Write-Host "`nExample 8: Batch operation - marking all Security notifications as read" -ForegroundColor Green
$securityNotifications = Get-Notifications -Category "Security"
$securityNotifications | ForEach-Object {
    Set-NotificationRead -Id $_.Id
}

# Example 9: Final status
Write-Host "`nExample 9: Final notification status" -ForegroundColor Green
Show-Notifications

Write-Host "`n=== EXAMPLE COMPLETE ===" -ForegroundColor Cyan
Write-Host "The notification system provides a complete solution for managing notifications with read/unread status tracking." -ForegroundColor White