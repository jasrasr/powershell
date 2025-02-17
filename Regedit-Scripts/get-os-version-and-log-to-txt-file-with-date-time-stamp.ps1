# This script retrieves and logs the Windows version, build number, and relevant registry values related to Windows Update and upgrade notifications.
# The results are saved to a timestamped text file in the C:\Temp\Automox-Exports\OS-Version directory.
# The script also checks for the existence of specific registry keys and properties and logs their values if present.
#author: Jason Lamb
#updated date: 2024-11-15
#version: 2.0

# move any old OS-Version*.txt files to a subdirectory
$sourceDir = 'C:\Temp\Automox-Exports'
$destinationDir = 'C:\Temp\Automox-Exports\OS-Version'

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir
}

# Get all files matching the pattern
$filesToMove = Get-ChildItem -Path $sourceDir -Filter '*OS-Version-*.txt'

# Check if any files were found and move them
if ($filesToMove) {
    foreach ($file in $filesToMove) {
        Move-Item -Path $file.FullName -Destination $destinationDir -force
        Write-Host "Moved: $($file.FullName) to $destinationDir"
    }
} else {
    Write-Host "No files matching the pattern were found."
}


# Define Registry Paths
$windowsUpdateRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$windowsStoreRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
$upgradeNotificationRegPath = "HKLM:\SYSTEM\Setup\UpgradeNotification"

# Create timestamp for the filename and define log file path
$timestamp = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")
$logpath = "C:\Temp\Automox-Exports\OS-Version"
$logfile = "$logpath\OS-Version-$timestamp.txt"

# Create or ensure the $logpath directory exists
if (-not (Test-Path $logpath)) {
    New-Item -Path $logpath -ItemType Directory
}

# Function to output to screen and file
function Output-Log {
    param (
        [string]$text
    )
    Write-Host $text
    Add-Content -Path $logfile -Value $text
}

# Function to check if a registry key exists
function Check-RegistryKey {
    param (
        [string]$path
    )
    try {
        if (Test-Path $path) {
            return $true
        } else {
            return $false
        }
    } catch {
        return $false
    }
}

# Function to check and log registry properties
function Check-RegistryValue {
    param (
        [string]$path,
        [string]$propertyName
    )
    if (Check-RegistryKey -path $path) {
        try {
            $value = (Get-ItemProperty -Path $path -ErrorAction Stop).$propertyName
            if ($null -ne $value) {
                Output-Log "$propertyName : $value"
            } else {
                Output-Log "$propertyName exists but contains no data (null)."
            }
        } catch {
            Output-Log "$propertyName does not exist in $path."
        }
    } else {
        Output-Log "Registry path $path does not exist or cannot be accessed."
    }
}

# Function to get the Windows version and build number
function Get-WindowsVersion {
    # Retrieve the operating system caption (e.g., Windows 10, Windows 11)
    $osCaption = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption

    # Retrieve the build number
    $buildNumber = (Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber

    # Retrieve the release version (e.g., 22H2, 24H2) from the registry
    $releaseIdPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    try {
        $releaseId = (Get-ItemProperty -Path $releaseIdPath -ErrorAction Stop).DisplayVersion
        if ($null -eq $releaseId) { $releaseId = "Unknown" }
    } catch {
        $releaseId = "Unknown"
    }

    # Format the result
    $versionInfo = "$osCaption $releaseId (Build $buildNumber)"
    return $versionInfo
}

# Get and log the Windows version and build number
Output-Log "Fetching Windows version and build information..."
$windowsVersion = Get-WindowsVersion
Output-Log "Current Windows Version: $windowsVersion"

# Check each registry value
Output-Log "`nChecking registry values..."
Check-RegistryValue -path $windowsUpdateRegPath -propertyName "ProductVersion"
Check-RegistryValue -path $windowsUpdateRegPath -propertyName "TargetReleaseVersionInfo"
Check-RegistryValue -path $windowsUpdateRegPath -propertyName "TargetReleaseVersion"
Check-RegistryValue -path $windowsUpdateRegPath -propertyName "DisableOSUpgrade"
Check-RegistryValue -path $windowsStoreRegPath -propertyName "DisableOSUpgrade"
Check-RegistryValue -path $upgradeNotificationRegPath -propertyName "UpgradeAvailable"

# Log summary of missing paths
Output-Log "`nSummary of missing or null entries:"
if (-not (Check-RegistryKey -path $windowsStoreRegPath)) {
    Output-Log "- Registry path $windowsStoreRegPath does not exist."
}
if (-not (Check-RegistryKey -path $upgradeNotificationRegPath)) {
    Output-Log "- Registry path $upgradeNotificationRegPath does not exist."
}

# Inform user of log file creation
Output-Log "`nResults logged to file: $logfile"
