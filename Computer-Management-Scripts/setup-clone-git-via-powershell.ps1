# Revision : 1.2
# Description : Git setup and GitHub repo clone with OneDrive fallback, prompts for user config, updated Git v2.50.0 URL
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-06-19
# Modified Date : 2025-06-19

# Step 1: Download and install Git for Windows
$gitInstaller = "$env:TEMP\Git-Setup.exe"
$gitDownloadUrl = "https://github.com/git-for-windows/git/releases/download/v2.50.0.windows.1/Git-2.50.0-64-bit.exe"

Write-Host "Downloading Git installer from $gitDownloadUrl ..."
Invoke-WebRequest -Uri $gitDownloadUrl -OutFile $gitInstaller

Write-Host "Installing Git silently ..."
Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT", "/NORESTART" -Wait

# Step 2: Add Git to PATH for the current session
$gitPath = "C:\Program Files\Git\cmd"
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    $env:Path += ";$gitPath"
    Write-Host "Temporarily added Git to PATH : $gitPath"
}

# Step 3: Verify Git
git --version

# Step 4: Prompt for Git global config
$userName = Read-Host "Enter your Git global user name"
$userEmail = Read-Host "Enter your Git global user email"

git config --global user.name "$userName"
git config --global user.email "$userEmail"
git config --global credential.helper manager-core
Write-Host "Git global config set for $userName <$userEmail>"

# Step 5: Determine the default GitHub folder
$oneDrivePath = Join-Path $env:USERPROFILE "OneDrive - middough\Documents\GitHub"
$fallbackPath = Join-Path $env:USERPROFILE "Documents\GitHub"

if (Test-Path $oneDrivePath) {
    $targetFolder = $oneDrivePath
    Write-Host "Using OneDrive GitHub folder : $targetFolder"
} else {
    $targetFolder = $fallbackPath
    Write-Host "OneDrive folder not found, falling back to : $targetFolder"
}

if (!(Test-Path $targetFolder)) {
    New-Item -Path $targetFolder -ItemType Directory | Out-Null
    Write-Host "Created target folder : $targetFolder"
}

Set-Location -Path $targetFolder

# Step 6: Clone GitHub repo
$repoUrl = Read-Host "Enter the GitHub repo URL to clone (e.g. https://github.com/youruser/yourrepo.git)"
git clone $repoUrl

# Step 7: Change into cloned repo folder
$repoName = ($repoUrl -split '/' | Select-Object -Last 1) -replace '\.git$'
Set-Location -Path (Join-Path $targetFolder $repoName)

Write-Host "Cloned and navigated to : $targetFolder\$repoName"
