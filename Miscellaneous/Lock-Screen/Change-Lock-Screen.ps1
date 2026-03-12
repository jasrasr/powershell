<# 
1. save files on a server somewhere accessible
1.1 \\servername\images\
1.2 files: Laptop_16-10.jpg, Portrait.jpg, Standard_16-9.jpg, SuperUltrawide_32-9.jpg, Ultrawide_21-9.jpg
2. copy files to local computer example c:\ProgramData\CompanyBranding
3. powershell to determine proper image
4. powershell to set registry keys and services for notifications and widgets
5. powershell to set registry keys for other lock screen items
6. CMD/BAT to disable lockscreen panning
7. CMD/BAT to lock down changes
#>

# Step 1
Make sure files are on the server and can be accessed via a user's computer

#######

# Step 2
copy \\servername\images\companybranding\* c:\programdata\companybranding\

########

# Step 3
# 1. Define image directory
$ImagePath = "C:\ProgramData\CompanyBranding"

# 2. Get Video Controllers and prioritize the tallest screen (likely the laptop 16:10)
$Displays = Get-WmiObject Win32_VideoController | Where-Object { $_.CurrentHorizontalResolution -gt 0 }
$Display = $Displays | Sort-Object CurrentVerticalResolution -Descending | Select-Object -First 1

if ($null -eq $Display) {
    Write-Output "LOG: No active displays found. Falling back to Standard 16:9"
    $SelectedImage = "$ImagePath\Standard_16-9.jpg"
} else {
    $Width  = $Display.CurrentHorizontalResolution
    $Height = $Display.CurrentVerticalResolution
    $Ratio  = [math]::Round(($Width / $Height), 2)

    Write-Output "LOG: Analyzing Display: $($Display.Name)"
    Write-Output "LOG: Resolution: $Width x $Height (Ratio: $Ratio)"

    if ($Ratio -ge 3.5) { $SelectedImage = "$ImagePath\SuperUltrawide_32-9.jpg" } 
    elseif ($Ratio -ge 2.2) { $SelectedImage = "$ImagePath\Ultrawide_21-9.jpg" } 
    elseif ($Ratio -ge 1.55 -and $Ratio -le 1.65) { $SelectedImage = "$ImagePath\Laptop_16-10.jpg" } 
    elseif ($Ratio -ge 1.7 -and $Ratio -le 1.8) { $SelectedImage = "$ImagePath\Standard_16-9.jpg" } 
    else { $SelectedImage = "$ImagePath\Standard_16-9.jpg" }
}

Write-Output "LOG: Selection: $SelectedImage"

# 3. Apply to Registry (HKLM works as SYSTEM)
$RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
if (!(Test-Path $RegKey)) { New-Item -Path $RegKey -Force | Out-Null }

Set-ItemProperty -Path $RegKey -Name "LockScreenImagePath" -Value $SelectedImage -Force
Set-ItemProperty -Path $RegKey -Name "LockScreenImageStatus" -Value 1 -Type DWord -Force


########

# Step 4

# 1. Define the command that will run for every user
# This command disables 'SubscribedContent' (News/Ads/Widgets) in the user's hive
$UserCommand = 'powershell.exe -Command "Set-ItemProperty -Path ''HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'' -Name ''LockScreenSubscribedContentEnabled'' -Value 0 -Force; Set-ItemProperty -Path ''HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'' -Name ''RotatingLockScreenEnabled'' -Value 0 -Force"'

# 2. Create the Active Setup key in HKLM
# We use a GUID or a unique name like 'DisableLockScreenWidgets'
$ActiveSetupPath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\DisableLockScreenWidgets"

if (!(Test-Path $ActiveSetupPath)) {
    New-Item -Path $ActiveSetupPath -Force
}

# 3. Set the values
# Version can be any string; if you update the command later, increment this number to re-run it
Set-ItemProperty -Path $ActiveSetupPath -Name "Version" -Value "1"
Set-ItemProperty -Path $ActiveSetupPath -Name "StubPath" -Value $UserCommand

Write-Output "LOG: Disabling System-wide Lock Screen Notifications..."

# 1. Disable lock screen app notifications (Policy level)
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
Set-ItemProperty -Path $regPath -Name "DisableLockScreenAppNotifications" -Value 1 -Type DWORD -Force

# 2. Disable Widget Service (Taskbar widgets)
$widgetsService = Get-Service -Name "WidgetService" -ErrorAction SilentlyContinue
if ($widgetsService) {
    Set-Service -Name "WidgetService" -StartupType Disabled
    Stop-Service -Name "WidgetService" -Force -ErrorAction SilentlyContinue
    Write-Output "LOG: WidgetService Disabled."
}


#######

Step 5

# Define the registry path for Content Delivery (Lock Screen Widgets/Ads)
$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

# 1. Disable the 'Detailed Status' (The News/Weather/Calendar tile)
Set-ItemProperty -Path $RegistryPath -Name "LockScreenSubscribedContentEnabled" -Value 0 -Force

# 2. Disable 'Fun Facts, Tips, and Tricks' (The text overlays)
Set-ItemProperty -Path $RegistryPath -Name "RotatingLockScreenEnabled" -Value 0 -Force
Set-ItemProperty -Path $RegistryPath -Name "SubscribedContent-338387Enabled" -Value 0 -Force

# 3. Disable 'Show lock screen background picture on the sign-in screen' 
# (Optional: ensures a clean transition, but usually kept enabled for branding)
# Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLogonBackgroundImage" -Value 0 -Force

Write-Output "Lock screen widgets and fun facts have been disabled for the current user."

Write-Output "LOG: Disabling User-specific Lock Screen Content..."

$spotlightPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
if (Test-Path $spotlightPath) {
    # Disables "Fun Facts" and "Spotlight" text
    Set-ItemProperty -Path $spotlightPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWORD -Force
    # Disables the "Detailed Status" widget (Weather/News)
    Set-ItemProperty -Path $spotlightPath -Name "LockScreenSubscribedContentEnabled" -Value 0 -Type DWORD -Force
    Write-Output "LOG: User-level lock screen widgets disabled."
}

#######

# Step 6 (cmd/bat)

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Lock Screen" /v SlideshowLayout /t REG_DWORD /d 0 /f

#######

# Step 7 (cmd/bat)

# :: 1. Lock down the image so users can't change it
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoChangingLockScreen /t REG_DWORD /d 1 /f

# :: 2. Disable Lock Screen App Notifications (Global)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableLockScreenAppNotifications /t REG_DWORD /d 1 /f

# :: 3. Force the image status to 'Active'
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" /v LockScreenImageStatus /t REG_DWORD /d 1 /f
