# Basic Tests for Notification System
# Author: Jason Lamb (jasrasr)
# Created: 2024-07-08
# Description: Basic tests to verify notification system functionality

# Import the notification manager
. "$PSScriptRoot\NotificationManager.ps1"

# Test counter
$script:TestCount = 0
$script:PassedTests = 0
$script:FailedTests = 0

function Test-Assert {
    param(
        [string]$TestName,
        [bool]$Condition,
        [string]$ExpectedResult = "",
        [string]$ActualResult = ""
    )
    
    $script:TestCount++
    
    if ($Condition) {
        Write-Host "✓ PASS: $TestName" -ForegroundColor Green
        $script:PassedTests++
    } else {
        Write-Host "✗ FAIL: $TestName" -ForegroundColor Red
        if ($ExpectedResult -and $ActualResult) {
            Write-Host "  Expected: $ExpectedResult" -ForegroundColor Yellow
            Write-Host "  Actual: $ActualResult" -ForegroundColor Yellow
        }
        $script:FailedTests++
    }
}

# Clear any existing notifications for clean testing
Clear-Notifications -Force

Write-Host "=== NOTIFICATION SYSTEM TESTS ===" -ForegroundColor Cyan
Write-Host "Running basic functionality tests...`n" -ForegroundColor White

# Test 1: Create a notification
Write-Host "Test 1: Create notification" -ForegroundColor Yellow
$notification = New-Notification -Title "Test Notification" -Message "This is a test message" -Type "Info" -Category "Test"
Test-Assert -TestName "Create notification returns object" -Condition ($null -ne $notification)
Test-Assert -TestName "Notification has correct title" -Condition ($notification.Title -eq "Test Notification")
Test-Assert -TestName "Notification has correct message" -Condition ($notification.Message -eq "This is a test message")
Test-Assert -TestName "Notification has correct type" -Condition ($notification.Type -eq "Info")
Test-Assert -TestName "Notification has correct category" -Condition ($notification.Category -eq "Test")
Test-Assert -TestName "Notification is unread by default" -Condition ($notification.IsRead -eq $false)
Test-Assert -TestName "Notification has valid ID" -Condition ($notification.Id -match "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")

# Test 2: Get notifications
Write-Host "`nTest 2: Get notifications" -ForegroundColor Yellow
$notifications = Get-Notifications
Test-Assert -TestName "Get notifications returns array" -Condition ($notifications -is [array] -or $notifications.Count -gt 0)
Test-Assert -TestName "Get notifications contains our test notification" -Condition ($notifications.Count -eq 1)
Test-Assert -TestName "Retrieved notification matches created notification" -Condition ($notifications[0].Id -eq $notification.Id)

# Test 3: Mark notification as read
Write-Host "`nTest 3: Mark notification as read" -ForegroundColor Yellow
$readResult = Set-NotificationRead -Id $notification.Id
Test-Assert -TestName "Set-NotificationRead returns true" -Condition ($readResult -eq $true)

$updatedNotifications = Get-Notifications
Test-Assert -TestName "Notification is marked as read" -Condition ($updatedNotifications[0].IsRead -eq $true)

# Test 4: Get unread notifications
Write-Host "`nTest 4: Get unread notifications" -ForegroundColor Yellow
$unreadNotifications = Get-Notifications -UnreadOnly
Test-Assert -TestName "No unread notifications after marking as read" -Condition ($unreadNotifications.Count -eq 0)

# Test 5: Get read notifications
Write-Host "`nTest 5: Get read notifications" -ForegroundColor Yellow
$readNotifications = Get-Notifications -ReadOnly
Test-Assert -TestName "One read notification exists" -Condition ($readNotifications.Count -eq 1)

# Test 6: Mark notification as unread
Write-Host "`nTest 6: Mark notification as unread" -ForegroundColor Yellow
$unreadResult = Set-NotificationUnread -Id $notification.Id
Test-Assert -TestName "Set-NotificationUnread returns true" -Condition ($unreadResult -eq $true)

$againUpdatedNotifications = Get-Notifications
Test-Assert -TestName "Notification is marked as unread" -Condition ($againUpdatedNotifications[0].IsRead -eq $false)

# Mark first notification as read again for statistics test
Set-NotificationRead -Id $notification.Id

# Test 7: Create multiple notifications for filtering tests
Write-Host "`nTest 7: Create multiple notifications for filtering" -ForegroundColor Yellow
$notification2 = New-Notification -Title "Warning Test" -Message "Warning message" -Type "Warning" -Category "System"
$notification3 = New-Notification -Title "Error Test" -Message "Error message" -Type "Error" -Category "Application"

$allNotifications = Get-Notifications
Test-Assert -TestName "Three notifications exist" -Condition ($allNotifications.Count -eq 3)

# Test 8: Filter by type
Write-Host "`nTest 8: Filter notifications by type" -ForegroundColor Yellow
$infoNotifications = Get-Notifications -Type "Info"
Test-Assert -TestName "Filter by Info type returns 1 notification" -Condition ($infoNotifications.Count -eq 1)

$warningNotifications = Get-Notifications -Type "Warning"
Test-Assert -TestName "Filter by Warning type returns 1 notification" -Condition ($warningNotifications.Count -eq 1)

# Test 9: Filter by category
Write-Host "`nTest 9: Filter notifications by category" -ForegroundColor Yellow
$testCategoryNotifications = Get-Notifications -Category "Test"
Test-Assert -TestName "Filter by Test category returns 1 notification" -Condition ($testCategoryNotifications.Count -eq 1)

$systemCategoryNotifications = Get-Notifications -Category "System"
Test-Assert -TestName "Filter by System category returns 1 notification" -Condition ($systemCategoryNotifications.Count -eq 1)

# Test 10: Get statistics
Write-Host "`nTest 10: Get notification statistics" -ForegroundColor Yellow
$stats = Get-NotificationStatistics
Write-Host "Debug - Total: $($stats.Total), Unread: $($stats.Unread), Read: $($stats.Read)" -ForegroundColor Magenta
Test-Assert -TestName "Statistics show correct total" -Condition ($stats.Total -eq 3)
Test-Assert -TestName "Statistics show correct unread count" -Condition ($stats.Unread -eq 2) -ExpectedResult "2" -ActualResult $stats.Unread
Test-Assert -TestName "Statistics show correct read count" -Condition ($stats.Read -eq 1) -ExpectedResult "1" -ActualResult $stats.Read
Test-Assert -TestName "Statistics include type breakdown" -Condition ($stats.ByType.Keys.Count -eq 3)
Test-Assert -TestName "Statistics include category breakdown" -Condition ($stats.ByCategory.Keys.Count -eq 3)

# Test 11: Remove notification
Write-Host "`nTest 11: Remove notification" -ForegroundColor Yellow
$removeResult = Remove-Notification -Id $notification2.Id
Test-Assert -TestName "Remove-Notification returns true" -Condition ($removeResult -eq $true)

$remainingNotifications = Get-Notifications
Test-Assert -TestName "Two notifications remain after removal" -Condition ($remainingNotifications.Count -eq 2)

# Test 12: Test invalid ID operations
Write-Host "`nTest 12: Test invalid ID operations" -ForegroundColor Yellow
$invalidReadResult = Set-NotificationRead -Id "invalid-id"
Test-Assert -TestName "Set-NotificationRead with invalid ID returns false" -Condition ($invalidReadResult -eq $false)

$invalidUnreadResult = Set-NotificationUnread -Id "invalid-id"
Test-Assert -TestName "Set-NotificationUnread with invalid ID returns false" -Condition ($invalidUnreadResult -eq $false)

$invalidRemoveResult = Remove-Notification -Id "invalid-id"
Test-Assert -TestName "Remove-Notification with invalid ID returns false" -Condition ($invalidRemoveResult -eq $false)

# Test Summary
Write-Host "`n=== TEST SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total Tests: $script:TestCount" -ForegroundColor White
Write-Host "Passed: $script:PassedTests" -ForegroundColor Green
Write-Host "Failed: $script:FailedTests" -ForegroundColor Red

if ($script:FailedTests -eq 0) {
    Write-Host "`nAll tests passed! ✅" -ForegroundColor Green
} else {
    Write-Host "`nSome tests failed! ❌" -ForegroundColor Red
}

# Clean up test notifications
Clear-Notifications -Force