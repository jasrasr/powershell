# Check if the script is running with administrator privileges
function Ensure-RunAsAdministrator {
    # Check if the current user has admin rights
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "This script needs to be run as an administrator. Restarting with elevated permissions..."
        
        # Relaunch the script with elevated privileges
        $newProcess = Start-Process -FilePath "powershell" -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
        $newProcess.WaitForExit()
        
        # Exit the original, non-elevated instance
        Exit
    }
}

# Ensure we are running as Administrator
Ensure-RunAsAdministrator

# If we reach here, the script is running with elevated privileges
Write-Host "Running with administrative privileges."

# Define a list of essential modules and their minimum versions
$essentialModules = @(
    @{ Name = "ExchangeOnlineManagement" ; MinVersion = "3.0.0" }    # Exchange Online module
    @{ Name = "MicrosoftTeams"           ; MinVersion = "4.9.1" }    # Microsoft Teams module
    @{ Name = "ActiveDirectory"          ; MinVersion = "1.0.0.0" }  # On-premises Active Directory module
    @{ Name = "AzureAD"                  ; MinVersion = "2.0.2.138" } # Azure AD module
    @{ Name = "Microsoft.Graph"          ; MinVersion = "1.0.0" }    # Microsoft Graph SDK for Azure AD
    @{ Name = "AzureAD.Standard.Preview" ; MinVersion = "0.0.1" }    # Azure AD Preview module
)

# Function to check if a module meets the minimum version requirement
function Get-ModuleInstalledStatus {
    param (
        [string]$ModuleName,
        [string]$MinVersion
    )

    $module = Get-Module -ListAvailable -Name $ModuleName | Where-Object { $_.Version -ge (New-Object Version $MinVersion) }
    return $null -ne $module
}

# Ensure PSGallery is set as a trusted repository
if (-not (Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue | Where-Object { $_.InstallationPolicy -eq "Trusted" })) {
    Write-Host "Setting PSGallery as a trusted repository..."
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# Install or update each essential module as needed
foreach ($moduleInfo in $essentialModules) {
    $moduleName = $moduleInfo.Name
    $minVersion = $moduleInfo.MinVersion

    # Check if the module meets the minimum version requirement
    if (-not (Get-ModuleInstalledStatus -ModuleName $moduleName -MinVersion $minVersion)) {
        Write-Host "Installing or updating module '$moduleName' (minimum version: $minVersion)..."
        try {
            Install-Module -Name $moduleName -MinimumVersion $minVersion -Scope CurrentUser -Force -AllowClobber
            Write-Host "Module '$moduleName' installed or updated successfully."
        } catch {
            Write-Host "Failed to install or update module '$moduleName'. Error: $_"
        }
    } else {
        Write-Host "Module '$moduleName' (version $minVersion or higher) is already installed."

        # Attempt to update the module to the latest version if possible
        try {
            Update-Module -Name $moduleName -Scope CurrentUser -Force -ErrorAction SilentlyContinue
            Write-Host "Module '$moduleName' updated to the latest version if an update was available."
        } catch {
            Write-Host "No updates available for module '$moduleName' or failed to update."
        }
    }
}

# Function to check and upgrade applications via WinGet
function InstallOrUpdateApplication {
    param (
        [string]$AppName,
        [string]$WingetId
    )

    # Check if the application is already installed
    $appInstalled = winget list --id $WingetId -e 2>&1 | Select-String -Pattern $AppName

    if ($appInstalled) {
        Write-Host "$AppName is already installed. Checking for updates..."

        # Attempt to upgrade the application if an update is available
        try {
            $updateAvailable = winget upgrade --id $WingetId -e --silent 2>&1 | Select-String -Pattern "No applicable update found."
            if ($updateAvailable) {
                Write-Host "No updates available for $AppName."
            } else {
                Write-Host "Updating $AppName..."
                winget upgrade --id $WingetId -e --silent
                Write-Host "$AppName updated successfully."
            }
        } catch {
            Write-Host "Failed to check or apply update for $AppName. Error: $_"
        }
    } else {
        Write-Host "$AppName is not installed. Installing via WinGet..."
        try {
            winget install --id $WingetId --silent
            Write-Host "$AppName installed successfully."
        } catch {
            Write-Host "Failed to install $AppName. Error: $_"
        }
    }
}

# Install or update Git and WinGet (WinGet is usually pre-installed on Windows 10/11)
InstallOrUpdateApplication -AppName "Git" -WingetId "Git.Git"
InstallOrUpdateApplication -AppName "WinGet" -WingetId "Microsoft.WingetSource"

Write-Host "All essential modules and applications are now installed or updated as necessary."
