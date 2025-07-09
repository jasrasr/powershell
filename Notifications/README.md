# PowerShell Notification System

A comprehensive PowerShell module for managing notifications with read/unread status tracking.

## Overview

The Notification System provides a complete solution for creating, managing, and tracking notifications within PowerShell scripts and applications. It includes persistent storage, read/unread status tracking, filtering capabilities, and comprehensive management functions.

## Features

- ✅ **Create notifications** with title, message, type, and category
- ✅ **Read/Unread status tracking** for all notifications
- ✅ **Persistent storage** using JSON files
- ✅ **Filtering capabilities** by type, category, and read status
- ✅ **Rich display formatting** with color coding
- ✅ **Statistics and reporting** functionality
- ✅ **Bulk operations** for managing multiple notifications

## Installation

1. Copy the `NotificationManager.ps1` file to your PowerShell modules directory or project folder
2. Import the module in your PowerShell session:

```powershell
. .\NotificationManager.ps1
```

## Quick Start

### Creating Notifications

```powershell
# Create a basic notification
New-Notification -Title "System Update" -Message "A new update is available"

# Create a notification with specific type and category
New-Notification -Title "Low Disk Space" -Message "C: drive is running low on space" -Type "Warning" -Category "System"

# Create an error notification
New-Notification -Title "Backup Failed" -Message "The backup process encountered an error" -Type "Error" -Category "Backup"
```

### Viewing Notifications

```powershell
# Show all notifications
Show-Notifications

# Show only unread notifications
Show-Notifications -UnreadOnly

# Show notifications by type
Show-Notifications -Type "Warning"

# Show notifications by category
Show-Notifications -Category "System"
```

### Managing Read/Unread Status

```powershell
# Get all notifications and mark the first one as read
$notifications = Get-Notifications
Set-NotificationRead -Id $notifications[0].Id

# Mark a notification as unread
Set-NotificationUnread -Id $notifications[0].Id
```

### Getting Statistics

```powershell
# Get notification statistics
$stats = Get-NotificationStatistics
Write-Host "Total: $($stats.Total), Unread: $($stats.Unread), Read: $($stats.Read)"
```

## Available Functions

### Core Functions

- **`New-Notification`** - Create a new notification
- **`Get-Notifications`** - Retrieve notifications with optional filtering
- **`Show-Notifications`** - Display notifications in formatted output
- **`Set-NotificationRead`** - Mark a notification as read
- **`Set-NotificationUnread`** - Mark a notification as unread
- **`Get-NotificationStatistics`** - Get summary statistics
- **`Remove-Notification`** - Remove a specific notification
- **`Clear-Notifications`** - Clear all or read-only notifications

### Function Parameters

#### New-Notification
- `Title` (Required): The notification title
- `Message` (Required): The notification message
- `Type` (Optional): Info, Warning, Error, Success (default: Info)
- `Category` (Optional): Custom category (default: General)

#### Get-Notifications / Show-Notifications
- `UnreadOnly`: Show only unread notifications
- `ReadOnly`: Show only read notifications
- `Category`: Filter by specific category
- `Type`: Filter by specific type

#### Set-NotificationRead / Set-NotificationUnread
- `Id` (Required): The notification ID

#### Remove-Notification
- `Id` (Required): The notification ID

#### Clear-Notifications
- `ReadOnly`: Clear only read notifications (keeps unread)
- `Force`: Skip confirmation prompt

## Data Storage

Notifications are stored in a JSON file located at:
```
$env:APPDATA\PowerShell\Notifications\notifications.json
```

Each notification contains:
- `Id`: Unique identifier (GUID)
- `Title`: Notification title
- `Message`: Notification message
- `Type`: Notification type (Info, Warning, Error, Success)
- `Category`: Notification category
- `CreatedDate`: Creation timestamp
- `IsRead`: Read status (true/false)

## Examples

### Example 1: Basic Usage
```powershell
# Import the module
. .\NotificationManager.ps1

# Create some notifications
New-Notification -Title "Welcome" -Message "Welcome to the notification system" -Type "Success"
New-Notification -Title "Reminder" -Message "Don't forget to check the logs" -Type "Info"

# View all notifications
Show-Notifications
```

### Example 2: Managing Read Status
```powershell
# Get unread notifications
$unreadNotifications = Get-Notifications -UnreadOnly
Write-Host "You have $($unreadNotifications.Count) unread notifications"

# Mark all notifications as read
$unreadNotifications | ForEach-Object { Set-NotificationRead -Id $_.Id }

# Verify no unread notifications remain
$stillUnread = Get-Notifications -UnreadOnly
Write-Host "Unread notifications remaining: $($stillUnread.Count)"
```

### Example 3: Filtering and Statistics
```powershell
# Show only error notifications
Show-Notifications -Type "Error"

# Get statistics
$stats = Get-NotificationStatistics
Write-Host "Notification Summary:"
Write-Host "  Total: $($stats.Total)"
Write-Host "  Unread: $($stats.Unread)"
Write-Host "  Read: $($stats.Read)"
```

## Testing

Run the included test script to verify functionality:

```powershell
. .\Test-Notifications.ps1
```

## Demo

Run the demo script to see the notification system in action:

```powershell
. .\Demo.ps1
```

## License

This project is part of the jasrasr/powershell repository and follows the same license terms.

## Author

Jason Lamb (jasrasr) - https://jasr.me/ps1

## Contributing

Contributions are welcome! Please follow the repository's contribution guidelines when submitting changes or improvements.