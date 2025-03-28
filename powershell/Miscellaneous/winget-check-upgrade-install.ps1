# FUTURE 
# TO INSTALL UPDATES
# winget upgrade --all -h --include-unknown --accept-package-agreements --accept-source-agreements

#check for latest version of winget via github
$apiUrl = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$headers = @{
    Accept        = "application/vnd.github.v3+json"
    "User-Agent"  = "PowerShell"
}
$response = Invoke-RestMethod -Uri $apiUrl -Headers $headers
$latestVersion = $response.tag_name
$latestVersionfix = $latestVersion -replace '^v', ''
Write-Output "The latest version of WinGet is $latestVersionfix"


# Set the folder path and create it if necessary
$folderPath = "C:\Temp\Automox-Exports\Winget-Updates"
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory -Force
}

# Generate the timestamp
$timestamp = (Get-Date).ToString("yyMMdd-HHmmss")
$outputPath = "$folderPath\winget-version-upgrades-$timestamp.txt"

# Check if winget is installed
if (Get-Command winget -ErrorAction SilentlyContinue) {
    # Get the current winget version and remove the 'v' prefix
    $wingetVersionOutput = winget --version
    $wingetVersion = $wingetVersionOutput -replace '^v', ''
    "winget is installed. Version: $wingetVersionOutput" | Tee-Object -FilePath $outputPath

    # Check if version is 1.9.25180 or later
    if ([version]$wingetVersion -ge [version]"$latestVersionfix") {
        "winget version is $latestVersionfix or later. Checking for available upgrades (no installations)..." | Tee-Object -FilePath $outputPath -Append
        # Check available upgrades without installing
        winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements   | Tee-Object -FilePath $outputPath -Append
    } else {
        "winget version is older than $latestVersionfix. Updating winget..." | Tee-Object -FilePath $outputPath -Append
        # Update winget (App Installer)
        winget upgrade --id Microsoft.DesktopAppInstaller -e --source winget | Tee-Object -FilePath $outputPath -Append
        
        # Confirm the update and check the new version
        "Checking new winget version after update..." | Tee-Object -FilePath $outputPath -Append
        $newWingetVersionOutput = winget --version
        $newWingetVersion = $newWingetVersionOutput -replace '^v', ''
        "Updated winget version: $newWingetVersion" | Tee-Object -FilePath $outputPath -Append

        # Check for other available upgrades after updating
        "Checking for other available upgrades..." | Tee-Object -FilePath $outputPath -Append
        # Suppress progress indicators and spinners for a single session
        winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements  | Tee-Object -FilePath $outputPath -Append

    }
} else {
    "winget is not installed. Attempting install now via github." | Tee-Object -FilePath $outputPath
<#    # Define the URL for the latest release
$wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

# Define the path to save the installer
$installerPath = "$env:TEMP\winget.msixbundle"

# Download the installer
Invoke-WebRequest -Uri $wingetUrl -OutFile $installerPath

# Install the package
Add-AppxPackage -Path $installerPath

if (Get-Command winget -ErrorAction SilentlyContinue) {
    # Get the current winget version and remove the 'v' prefix
    $wingetVersionOutput = winget --version
    $wingetVersion = $wingetVersionOutput -replace '^v', ''
    "winget is installed. Version: $wingetVersionOutput" | Tee-Object -FilePath $outputPath -Append

    else {
        "winget is not installed. Please install manually." | Tee-Object -FilePath $outputPath -Append
    }

    }
    #>
}