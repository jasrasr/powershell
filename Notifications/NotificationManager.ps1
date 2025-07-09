# Notification Manager Module
# Author: Jason Lamb (@jasrasr) (with help from GitHub Copilot)
# Created: 7/8/25
# Description: PowerShell module for managing notifications with read/unread status

# Define the notifications data file path
$script:NotificationsPath = if ($IsLinux -or $IsMacOS) {
    "$env:HOME/.local/share/powershell/notifications"
} else {
    "$env:APPDATA\PowerShell\Notifications"
}
$script:NotificationsFile = if ($IsLinux -or $IsMacOS) {
    "$script:NotificationsPath/notifications.json"
} else {
    "$script:NotificationsPath\notifications.json"
}

# Ensure the notifications directory exists
if (-not (Test-Path -Path $script:NotificationsPath)) {
    New-Item -Path $script:NotificationsPath -ItemType Directory -Force | Out-Null
}

# Initialize notifications file if it doesn't exist
if (-not (Test-Path -Path $script:NotificationsFile)) {
    @() | ConvertTo-Json | Out-File -FilePath $script:NotificationsFile -Encoding UTF8
}

# Helper function to load notifications from JSON file
function Get-NotificationsFromFile {
    try {
        $content = Get-Content -Path $script:NotificationsFile -Raw -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($content)) {
            return @()
        }
        $notifications = $content | ConvertFrom-Json
        # Ensure we always return an array
        if ($notifications -eq $null) {
            return @()
        }
        return @($notifications)
    }
    catch {
        Write-Warning "Failed to load notifications: $_"
        return @()
    }
}

# Helper function to save notifications to JSON file
function Save-NotificationsToFile {
    param([Array]$Notifications)
    
    try {
        $Notifications | ConvertTo-Json -Depth 3 | Out-File -FilePath $script:NotificationsFile -Encoding UTF8
        return $true
    }
    catch {
        Write-Warning "Failed to save notifications: $_"
        return $false
    }
}

# Function to create a new notification
function New-Notification {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Type = "Info",
        
        [Parameter(Mandatory = $false)]
        [string]$Category = "General"
    )
    
    $notifications = Get-NotificationsFromFile
    
    # Ensure we have an array
    if ($notifications -eq $null) {
        $notifications = @()
    }
    
    # Create new notification object
    $notification = [PSCustomObject]@{
        Id = [System.Guid]::NewGuid().ToString()
        Title = $Title
        Message = $Message
        Type = $Type
        Category = $Category
        CreatedDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        IsRead = $false
    }
    
    # Add to notifications array
    $notifications = @($notifications) + @($notification)
    
    # Save to file
    if (Save-NotificationsToFile -Notifications $notifications) {
        Write-Host "Notification created successfully: $Title" -ForegroundColor Green
        return $notification
    }
    else {
        Write-Error "Failed to create notification"
        return $null
    }
}

# Function to get all notifications
function Get-Notifications {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [switch]$UnreadOnly,
        
        [Parameter(Mandatory = $false)]
        [switch]$ReadOnly,
        
        [Parameter(Mandatory = $false)]
        [string]$Category,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Type
    )
    
    $notifications = Get-NotificationsFromFile
    
    # Ensure we have an array
    if ($notifications -eq $null) {
        $notifications = @()
    }
    
    # Apply filters
    if ($UnreadOnly) {
        $notifications = @($notifications | Where-Object { -not $_.IsRead })
    }
    
    if ($ReadOnly) {
        $notifications = @($notifications | Where-Object { $_.IsRead })
    }
    
    if ($Category -and $Category -ne "") {
        $notifications = @($notifications | Where-Object { $_.Category -eq $Category })
    }
    
    if ($Type -and $Type -ne "") {
        $notifications = @($notifications | Where-Object { $_.Type -eq $Type })
    }
    
    return @($notifications | Sort-Object CreatedDate -Descending)
}

# Function to mark a notification as read
function Set-NotificationRead {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id
    )
    
    $notifications = Get-NotificationsFromFile
    $notification = $notifications | Where-Object { $_.Id -eq $Id }
    
    if ($notification) {
        $notification.IsRead = $true
        if (Save-NotificationsToFile -Notifications $notifications) {
            Write-Host "Notification marked as read" -ForegroundColor Green
            return $true
        }
        else {
            Write-Error "Failed to update notification"
            return $false
        }
    }
    else {
        Write-Warning "Notification with ID '$Id' not found"
        return $false
    }
}

# Function to mark a notification as unread
function Set-NotificationUnread {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id
    )
    
    $notifications = Get-NotificationsFromFile
    $notification = $notifications | Where-Object { $_.Id -eq $Id }
    
    if ($notification) {
        $notification.IsRead = $false
        if (Save-NotificationsToFile -Notifications $notifications) {
            Write-Host "Notification marked as unread" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Error "Failed to update notification"
            return $false
        }
    }
    else {
        Write-Warning "Notification with ID '$Id' not found"
        return $false
    }
}

# Function to display notifications in a formatted way
function Show-Notifications {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [switch]$UnreadOnly,
        
        [Parameter(Mandatory = $false)]
        [switch]$ReadOnly,
        
        [Parameter(Mandatory = $false)]
        [string]$Category,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Type
    )
    
    $params = @{}
    if ($UnreadOnly) { $params.UnreadOnly = $true }
    if ($ReadOnly) { $params.ReadOnly = $true }
    if ($Category -and $Category -ne "") { $params.Category = $Category }
    if ($Type -and $Type -ne "") { $params.Type = $Type }
    
    $notifications = Get-Notifications @params
    
    if ($notifications.Count -eq 0) {
        Write-Host "No notifications found." -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n=== NOTIFICATIONS ===" -ForegroundColor Cyan
    Write-Host "Total: $($notifications.Count)" -ForegroundColor Cyan
    
    foreach ($notification in $notifications) {
        $statusIcon = if ($notification.IsRead) { "✓" } else { "●" }
        $statusColor = if ($notification.IsRead) { "Green" } else { "Yellow" }
        
        $typeColor = switch ($notification.Type) {
            "Info" { "Cyan" }
            "Warning" { "Yellow" }
            "Error" { "Red" }
            "Success" { "Green" }
            default { "White" }
        }
        
        Write-Host "`n$statusIcon [$($notification.Type)] $($notification.Title)" -ForegroundColor $typeColor
        Write-Host "  ID: $($notification.Id)" -ForegroundColor Gray
        Write-Host "  Category: $($notification.Category)" -ForegroundColor Gray
        Write-Host "  Created: $($notification.CreatedDate)" -ForegroundColor Gray
        Write-Host "  Status: $( if ($notification.IsRead) { 'Read' } else { 'Unread' } )" -ForegroundColor $statusColor
        Write-Host "  Message: $($notification.Message)" -ForegroundColor White
    }
    
    Write-Host "`n=== END NOTIFICATIONS ===" -ForegroundColor Cyan
}

# Function to get notification statistics
function Get-NotificationStatistics {
    [CmdletBinding()]
    param()
    
    $notifications = Get-NotificationsFromFile
    
    # Ensure we have an array
    if ($notifications -eq $null) {
        $notifications = @()
    }
    
    $stats = [PSCustomObject]@{
        Total = $notifications.Count
        Unread = @($notifications | Where-Object { -not $_.IsRead }).Count
        Read = @($notifications | Where-Object { $_.IsRead }).Count
        ByType = @{}
        ByCategory = @{}
    }
    
    # Group by type
    $typeGroups = $notifications | Group-Object -Property Type
    foreach ($group in $typeGroups) {
        $stats.ByType[$group.Name] = $group.Count
    }
    
    # Group by category
    $categoryGroups = $notifications | Group-Object -Property Category
    foreach ($group in $categoryGroups) {
        $stats.ByCategory[$group.Name] = $group.Count
    }
    
    return $stats
}

# Function to remove a notification
function Remove-Notification {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id
    )
    
    $notifications = Get-NotificationsFromFile
    
    # Ensure we have an array
    if ($notifications -eq $null) {
        $notifications = @()
    }
    
    $originalCount = $notifications.Count
    
    $notifications = @($notifications | Where-Object { $_.Id -ne $Id })
    
    if ($notifications.Count -lt $originalCount) {
        if (Save-NotificationsToFile -Notifications $notifications) {
            Write-Host "Notification removed successfully" -ForegroundColor Green
            return $true
        }
        else {
            Write-Error "Failed to remove notification"
            return $false
        }
    }
    else {
        Write-Warning "Notification with ID '$Id' not found"
        return $false
    }
}

# Function to clear all notifications
function Clear-Notifications {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [switch]$ReadOnly,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    if (-not $Force) {
        $confirmation = Read-Host "Are you sure you want to clear notifications? (y/N)"
        if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
            Write-Host "Operation cancelled" -ForegroundColor Yellow
            return
        }
    }
    
    if ($ReadOnly) {
        $notifications = Get-NotificationsFromFile
        $notifications = $notifications | Where-Object { -not $_.IsRead }
    }
    else {
        $notifications = @()
    }
    
    if (Save-NotificationsToFile -Notifications $notifications) {
        Write-Host "Notifications cleared successfully" -ForegroundColor Green
        return $true
    }
    else {
        Write-Error "Failed to clear notifications"
        return $false
    }
}

# Export functions for module use
if ($MyInvocation.MyCommand.Name -eq "NotificationManager.ps1") {
    # Running as script, not module - don't export
} else {
    Export-ModuleMember -Function @(
        'New-Notification',
        'Get-Notifications',
        'Set-NotificationRead',
        'Set-NotificationUnread',
        'Show-Notifications',
        'Get-NotificationStatistics',
        'Remove-Notification',
        'Clear-Notifications'
    )
}