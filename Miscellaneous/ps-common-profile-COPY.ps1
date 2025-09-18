# backup @ $GitHubpath\PowerShell\Miscellaneous\ps-common-profile-COPY.ps1'

function Start-CustomTranscript {
    $username = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $transcriptDir = "$onedrivepath\Documents\GitHub\PowerShell Transcript"
    $transcriptPath = "$transcriptDir\PStranscript-$hostname-$username-$timestamp.txt"
    
    if (!(Test-Path $transcriptDir)) {
        New-Item -ItemType Directory -Path $transcriptDir | Out-Null
    }
    
    Start-Transcript -Path $transcriptPath -Append
}
    Start-CustomTranscript

####################

Write-host "Script Updated 8:20 AM 9/8/2025" -foregroundcolor darkyellow 
#& '.\script-update-date-time.ps1'

####################
<#
# https://www.hanselman.com/blog/how-to-make-a-pretty-prompt-in-windows-terminal-with-powerline-nerd-fonts-cascadia-code-wsl-and-ohmyposh
Import-Module -Name Terminal-Icons
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme Paradox
#>

# Add Import-Module line if not already present
$profileContent = Get-Content -Path $PROFILE -ErrorAction SilentlyContinue
if ($profileContent -notmatch 'Import-Module\s+Terminal-Icons') {
    Add-Content -Path $PROFILE -Value "`n# Load Terminal-Icons for fancy directory/file icons`nImport-Module -Name Terminal-Icons -ErrorAction SilentlyContinue"
    Write-Host "Updated profile to auto-load Terminal-Icons."
} else {
    Write-Host "Profile already includes Terminal-Icons import."
}

####################

# Load credentials from the file for each computer
# Construct the path to the credential file based on the computer name
$credPath = Join-Path -Path "$onedrivepath\Documents\GitHub" -ChildPath "admincred-$env:COMPUTERNAME.xml"

# Check if the credential file exists
if (Test-Path $credPath) {
    try {
        # Import the credential
        $Global:AdminCred = Import-Clixml -Path $credPath
        Write-Host "Credential loaded for $env:COMPUTERNAME" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to import credential file: $_"
    }
} else {
    Write-Warning "Credential file not found: $credPath"
Write-Warning "ENTER ADM CREDENTIALS"
#. "$onedrivepath\Documents\GitHub\set-save-admincred-per-computer.ps1"
}

# $admincred = Import-Clixml -Path "$onedrivepath\Documents\GitHub\admincred.xml"

####################

# Generate a TOC of functions and aliases used in the $CommonProfilePath
# . $githubpath\PowerShell-TableOfContents-TOC.ps1
# show-scripttoc


####################


function Git-PowerShell-Private-Sync {

    $repoPath = "$onedrivepath\Documents\GitHub\PowerShell-Private"

#START RENAME FILES WITH SPACES TO DASHES - PRIVATE

# Define the root folder to search
$rootFolder = $repoPath

Get-ChildItem -Path $rootFolder -Recurse -Force | ForEach-Object {
    if ($_.Name -match '\s') {
        $baseName = $_.Name -replace '\s', '-'
        $directory = $_.DirectoryName
        $targetPath = Join-Path $directory $baseName

        # If it's a file, split name and extension
        if (-not $_.PSIsContainer) {
            $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
            $ext = [System.IO.Path]::GetExtension($baseName)

            # Add -dup until it's unique
            while (Test-Path $targetPath) {
                $nameNoExt += "-dup"
                $baseName = "$nameNoExt$ext"
                $targetPath = Join-Path $directory $baseName
            }
        }
        else {
            # It's a folder
            while (Test-Path $targetPath) {
                $baseName += "-dup"
                $targetPath = Join-Path $directory $baseName
            }
        }

        try {
            Rename-Item -Path $_.FullName -NewName $baseName -Force
            Write-Host "Renamed: '$($_.FullName)' → '$targetPath'"
        }
        catch {
            Write-Warning "Failed to rename: '$($_.FullName)' → '$targetPath' - $($_.Exception.Message)"
        }
    }
}

#START GIT PRIVATE
    if (Test-Path $repoPath) {
        Set-Location $repoPath
        Write-Host "Switched to $repoPath" -ForegroundColor Yellow
    } else {
        Write-Host "Repository path does not exist: $repoPath" -ForegroundColor Red
        return
    }

    Write-Host "Pulling latest changes from private repository..." -ForegroundColor Green
    git pull private main --quiet

### - modified for empty commit 071025
# Fetch status in a machine-friendly format (porcelain)
$status = git status --porcelain

# Filter out untracked files (lines starting with '??')
$trackedChanges = $status | Where-Object { $_ -notmatch '^\?\?' }

if ($trackedChanges) {
    # Changes exist in tracked files
    Write-Host "Staging all changes..." -ForegroundColor Green
    git add .
    Write-Host "Committing changes..." -ForegroundColor Green
    git commit -m "git commit powershell private function $datetime"
} else {
    # No tracked changes — create an empty commit
    Write-Host "No tracked changes - committing " -ForegroundColor Magenta
    git commit --allow-empty -m "$datetime committed even if no tracked changes for this repo"
}
###    

    Write-Host "Pushing to private repository..." -ForegroundColor Green
    git push private main --quiet

    Write-Host "Git sync completed!" -ForegroundColor Cyan
}

####################

# Revision : 1.0
# Description : Fixes Git staging logic so untracked/renamed/deleted files are added before commit; adds safe rename step, proper datetime, empty-commit fallback  (Rev 1.0)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-16
# Modified Date : 2025-09-16

function Git-PowerShell-Sync {
    param()

    $repoPath = "$onedrivepath\Documents\GitHub\PowerShell"
    $datetime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    if (-not (Test-Path -LiteralPath $repoPath)) {
        Write-Host "Repository path does not exist : $repoPath" -ForegroundColor Red
        return
    }

    Set-Location -LiteralPath $repoPath
    Write-Host "Switched to $repoPath" -ForegroundColor Yellow

    # --- SAFETY: never touch the .git folder during renames ---
    $rootFolder = $repoPath
    Get-ChildItem -Path $rootFolder -Recurse -Force -File,Directory |
        Where-Object {
            $_.FullName -notmatch [regex]::Escape("\.git\") -and
            $_.Name -match '\s'
        } | ForEach-Object {
            $originalFull = $_.FullName
            $baseName = $_.Name -replace '\s','-'
            $directory = $_.DirectoryName
            $targetPath = Join-Path $directory $baseName

            if (-not $_.PSIsContainer) {
                $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
                $ext = [System.IO.Path]::GetExtension($baseName)
                while (Test-Path -LiteralPath $targetPath) {
                    $nameNoExt += "-dup"
                    $baseName = "$nameNoExt$ext"
                    $targetPath = Join-Path $directory $baseName
                }
            }
            else {
                while (Test-Path -LiteralPath $targetPath) {
                    $baseName += "-dup"
                    $targetPath = Join-Path $directory $baseName
                }
            }

            try {
                Rename-Item -LiteralPath $originalFull -NewName $baseName -Force
                Write-Host "Renamed : '$originalFull' -> '$targetPath'"
            }
            catch {
                Write-Host "Failed to rename : '$originalFull' -> '$targetPath'  Error : $($_.Exception.Message)" -ForegroundColor Red
            }
        }

    Write-Host "Pulling latest changes..." -ForegroundColor Green
    git pull origin main --quiet

    # --- CRITICAL FIX: stage everything (adds, deletes, renames) BEFORE checking status ---
    # -A will stage new files (untracked), deletions, and renames in one pass
    Write-Host "Staging all changes (git add -A)..." -ForegroundColor Green
    git add -A

    # Determine if anything is staged
    # git diff --cached --quiet returns exit code 1 when there ARE staged changes
    git diff --cached --quiet
    $hasStagedChanges = ($LASTEXITCODE -ne 0)

    if ($hasStagedChanges) {
        Write-Host "Committing staged changes..." -ForegroundColor Green
        git commit -m "Git sync : $datetime"
    }
    else {
        # Nothing staged; also check if working tree still has unstaged changes and try once more
        $statusPorcelain = git status --porcelain
        if ($statusPorcelain) {
            Write-Host "Detected unstaged changes after first pass, staging again..." -ForegroundColor Yellow
            git add -A
            git diff --cached --quiet
            $hasStagedChanges = ($LASTEXITCODE -ne 0)
        }

        if ($hasStagedChanges) {
            Write-Host "Committing staged changes..." -ForegroundColor Green
            git commit -m "Git sync (second pass) : $datetime"
        }
        else {
            Write-Host "No changes to commit - creating empty commit for traceability..." -ForegroundColor Magenta
            git commit --allow-empty -m "Empty sync commit : $datetime"
        }
    }

    Write-Host "Pushing to origin/main..." -ForegroundColor Green
    git push origin main --quiet

    Write-Host "Git sync completed!" -ForegroundColor Cyan
}

##################

# Revision : 1.0
# Description : PowerShell-Private repo commit helper with safe rename, stage-everything (git add -A), staged-change detection, and empty-commit fallback (Rev 1.0)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-16
# Modified Date : 2025-09-16

function Git-Commit-PowerShell-Private {

    $repoPath  = "$onedrivepath\Documents\GitHub\PowerShell-Private"
    $datetime  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    if (-not (Test-Path -LiteralPath $repoPath)) {
        Write-Host "Repository path does not exist : $repoPath" -ForegroundColor Red
        return
    }

    Set-Location -LiteralPath $repoPath
    Write-Host "Switched to $repoPath" -ForegroundColor Yellow

    # --- SAFETY: never touch .git during renames; use -LiteralPath everywhere ---
    $rootFolder = $repoPath

    Get-ChildItem -Path $rootFolder -Recurse -Force -File,Directory |
        Where-Object {
            $_.FullName -notmatch [regex]::Escape("\.git\") -and
            $_.Name -match '\s'
        } | ForEach-Object {

            $originalFull = $_.FullName
            $baseName     = $_.Name -replace '\s','-'
            $directory    = $_.DirectoryName
            $targetPath   = Join-Path $directory $baseName

            if (-not $_.PSIsContainer) {
                $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
                $ext       = [System.IO.Path]::GetExtension($baseName)

                while (Test-Path -LiteralPath $targetPath) {
                    $nameNoExt += "-dup"
                    $baseName   = "$nameNoExt$ext"
                    $targetPath = Join-Path $directory $baseName
                }
            }
            else {
                while (Test-Path -LiteralPath $targetPath) {
                    $baseName   += "-dup"
                    $targetPath  = Join-Path $directory $baseName
                }
            }

            try {
                Rename-Item -LiteralPath $originalFull -NewName $baseName -Force
                Write-Host "Renamed : '$originalFull' -> '$targetPath'"
            }
            catch {
                Write-Host "Failed to rename : '$originalFull' -> '$targetPath'  Error : $($_.Exception.Message)" -ForegroundColor Red
            }
        }

    # --- CRITICAL FIX: Stage everything (adds, deletes, renames) BEFORE checking status ---
    Write-Host "Staging all changes (git add -A)..." -ForegroundColor Green
    git add -A

    # Check if anything is staged now
    git diff --cached --quiet
    $hasStagedChanges = ($LASTEXITCODE -ne 0)

    if (-not $hasStagedChanges) {
        # If working tree still reports changes, try staging once more (edge cases)
        $statusPorcelain = git status --porcelain
        if ($statusPorcelain) {
            Write-Host "Detected unstaged changes after first pass, staging again..." -ForegroundColor Yellow
            git add -A
            git diff --cached --quiet
            $hasStagedChanges = ($LASTEXITCODE -ne 0)
        }
    }

    if ($hasStagedChanges) {
        Write-Host "Committing staged changes..." -ForegroundColor Green
        git commit -m "Git sync (private) : $datetime"
    }
    else {
        Write-Host "No changes to commit - creating empty commit for traceability..." -ForegroundColor Magenta
        git commit --allow-empty -m "Empty sync commit (private) : $datetime"
    }

    Write-Host "Git PowerShell-Private COMMIT completed!" -ForegroundColor Cyan
}


####################

function Git-Commit-PowerShell {
    $repoPath = "$onedrivepath\Documents\GitHub\PowerShell"

#START RENAME FILES WITH SPACES TO DASHES

# Define the root folder to search
$rootFolder = $repoPath

Get-ChildItem -Path $rootFolder -Recurse -Force | ForEach-Object {
    if ($_.Name -match '\s') {
        $baseName = $_.Name -replace '\s', '-'
        $directory = $_.DirectoryName
        $targetPath = Join-Path $directory $baseName

        # If it's a file, split name and extension
        if (-not $_.PSIsContainer) {
            $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
            $ext = [System.IO.Path]::GetExtension($baseName)

            # Add -dup until it's unique
            while (Test-Path $targetPath) {
                $nameNoExt += "-dup"
                $baseName = "$nameNoExt$ext"
                $targetPath = Join-Path $directory $baseName
            }
        }
        else {
            # It's a folder
            while (Test-Path $targetPath) {
                $baseName += "-dup"
                $targetPath = Join-Path $directory $baseName
            }
        }

        try {
            Rename-Item -Path $_.FullName -NewName $baseName -Force
            Write-Host "Renamed: '$($_.FullName)' → '$targetPath'"
        }
        catch {
            Write-Warning "Failed to rename: '$($_.FullName)' → '$targetPath' - $($_.Exception.Message)"
        }
    }
}


#START GIT PUBLIC POWERSHELL
    if (Test-Path $repoPath) {
        Set-Location $repoPath
        Write-Host "Switched to $repoPath" -ForegroundColor Yellow
    } else {
        Write-Host "Repository path does not exist: $repoPath" -ForegroundColor Red
        return
    }


### - modified for empty commit 071025
# Fetch status in a machine-friendly format (porcelain)
$status = git status --porcelain

# Filter out untracked files (lines starting with '??')
$trackedChanges = $status | Where-Object { $_ -notmatch '^\?\?' }

if ($trackedChanges) {
    # Changes exist in tracked files
    Write-Host "Staging all changes..." -ForegroundColor Green
    git add .
    Write-Host "Committing changes..." -ForegroundColor Green
    git commit -m "git commit powershell private function $datetime"
} else {
    # No tracked changes — create an empty commit
    Write-Host "No tracked changes - committing " -ForegroundColor Magenta
    git commit --allow-empty -m "$datetime committed even if no tracked changes for this repo"
}
###

    Write-Host "Git PowerShell sync completed!" -ForegroundColor Cyan
}


###################

function Git-jasrasr-Sync {
    $repoPath = "$onedrivepath\Documents\GitHub\jasrasr.github.io"

#START RENAME FILES WITH SPACES TO DASHES

# Define the root folder to search
$rootFolder = $repoPath

Get-ChildItem -Path $rootFolder -Recurse -Force | ForEach-Object {
    if ($_.Name -match '\s') {
        $baseName = $_.Name -replace '\s', '-'
        $directory = $_.DirectoryName
        $targetPath = Join-Path $directory $baseName

        # If it's a file, split name and extension
        if (-not $_.PSIsContainer) {
            $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
            $ext = [System.IO.Path]::GetExtension($baseName)

            # Add -dup until it's unique
            while (Test-Path $targetPath) {
                $nameNoExt += "-dup"
                $baseName = "$nameNoExt$ext"
                $targetPath = Join-Path $directory $baseName
            }
        }
        else {
            # It's a folder
            while (Test-Path $targetPath) {
                $baseName += "-dup"
                $targetPath = Join-Path $directory $baseName
            }
        }

        try {
            Rename-Item -Path $_.FullName -NewName $baseName -Force
            Write-Host "Renamed: '$($_.FullName)' → '$targetPath'"
        }
        catch {
            Write-Warning "Failed to rename: '$($_.FullName)' → '$targetPath' - $($_.Exception.Message)"
        }
    }
}


#START GIT JASRASR GITHUB PAGES
    if (Test-Path $repoPath) {
        Set-Location $repoPath
        Write-Host "Switched to $repoPath" -ForegroundColor Yellow
    } else {
        Write-Host "Repository path does not exist: $repoPath" -ForegroundColor Red
        return
    }

    Write-Host "Pulling latest changes from PowerShell repository..." -ForegroundColor Green
    git pull origin main --quiet

    Write-Host "Staging all changes..." -ForegroundColor Green
    git add .

    Write-Host "Committing changes..." -ForegroundColor Green
    git commit -m "git commit PowerShell function $datetime"

    Write-Host "Pushing to PowerShell repository..." -ForegroundColor Green
    git push origin main --quiet

    Write-Host "Git sync completed!" -ForegroundColor Cyan
}

####################

Set-Alias jlgpps Git-PowerShell-Private-Sync
Set-Alias jlgps Git-PowerShell-Sync
Set-Alias jlgjs Git-jasrasr-Sync

####################

import-module '$onedrivepath\Documents\GitHub\PowerShell-Private\MyCustomModule\mycustommodule.psm1'


####################

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
Import-Module "$ChocolateyProfile"
}

####################

# Detect PowerShell Version
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $psVersion = "PowerShell 7+ (pwsh.exe)"
    $color = "Cyan"
} else {
    $psVersion = "PowerShell 5.1 (powershell.exe)"
    $color = "Yellow"
}
 
# Detect Running Environment
if ($Host.Name -eq "Windows PowerShell ISE Host") {
    $envType = "Running in PowerShell ISE"
    $envColor = "Magenta"
} elseif ($env:TERM_PROGRAM -eq "vscode") {
    $envType = "Running in Visual Studio Code"
    $envColor = "Blue"
} else {
    $envType = "Running in Standard PowerShell Console"
    $envColor = "Gray"
}
 
# Display Information
Write-Host "Detected Environment: $envType" -ForegroundColor $envColor
$psvernum = $PSVersionTable.PSVersion.ToString() # PowerShell Version Number like 7.4.6 or 7.5
Write-Host "PowerShell Version: $psVersion - $psvernum" -ForegroundColor $color
write-host "$env:COMPUTERNAME \ $env:USERNAME" -ForegroundColor red

# Create a hash table of computers
$Computers = @(
#    @{ ComputerName = "CLEW10BGZ32G2"; Model = "5510"; Location = "Home" }
#    @{ ComputerName = "CLEW103LMHFH2"; Model = "5520"; Location = "Office" }
#    @{ ComputerName = "CLEW11DZ93HW3"; Model = "7320"; Location = "Main Old" }
#    @{ ComputerName = "CLEW1067LLFH2"; Model = "5285"; Location = "Office" }
    @{ ComputerName = "CLEW112GFF814"; Model = "5680"; Location = "Office" }
    @{ ComputerName = "CLE3RF6G94"; Model = "7350"; Location = "Main" }
    )

# Get current computer name
$CurrentComputer = $env:COMPUTERNAME

# Output the results
foreach ($Computer in $Computers) {
    if ($Computer.ComputerName -eq $CurrentComputer) {
        Write-Host ("ComputerName: " + $Computer.ComputerName + " | Model: " + $Computer.Model + " | Location: " + $Computer.Location) -ForegroundColor Green
    } else {
        Write-Host ("ComputerName: " + $Computer.ComputerName + " | Model: " + $Computer.Model + " | Location: " + $Computer.Location)
    }
}

####################

function CopyPastePendingApp {
    param (
        [string]$FolderDate = (Read-Host 'Folder date (e.g., 20250320)'),
        [string]$Source = (Read-Host 'Source folder'),
        [string]$Destination = "\\clesccm\e$\application source\cad applications\! Pending Creation\$FolderDate"
    )

#    Write-Host "This assumes Source is 'C:\temp\autodesk\..' and Destination is '\\clesccm\e$\application source\cad applications\! Pending Creation\..'"
#    Write-Host "This assumes Destination is '\\clesccm\e$\application source\cad applications\! Pending Creation\..'"

    # Ensure the destination exists
    if (-not (Test-Path -Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $Destination"
    }

    # Define the Robocopy command
    $robocopyCommand = "robocopy `"$Source`" `"$Destination`" /E /Z /J /MT:16 /R:2 /W:2 /NFL /NDL /LOG+:C:\temp\autodesk\robocopy-log.txt"

    # Start the job in the background
    $job = Start-Job -ScriptBlock {
        param ($cmd)
        Invoke-Expression $cmd
    } -ArgumentList $robocopyCommand

    Write-Host "Copy job started with Job ID : $($job.Id). Use 'Get-Job' to check status or 'Receive-Job -Id $($job.Id)' to view output."
}

###############

function RoboCopyMir {  
    param (
        [string]$Source = (Read-Host 'Source folder (FULL)').Trim('"'),
        [string]$Destination = (Read-Host 'Destination folder (FULL)').Trim('"'),
        [string]$LogDir = "C:\temp\robocopy_jobs",
        [switch]$RunAsJob,
        [string]$JobName = (Read-Host 'Job Name').Trim('"')

    )

    # Ensure the source exists
    if (-not (Test-Path -Path $Source)) {
        Write-Host "Error: Source folder does not exist. Exiting." -ForegroundColor Red
        return
    }

    # Ensure the destination exists
    if (-not (Test-Path -Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $Destination"
    }

    # Ensure the log file directory exists
    if (-not (Test-Path -Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
        Write-Host "Created log directory: $LogDir"
    }

    # Define the Robocopy command
    $logFile = Join-Path -Path $LogDir -ChildPath "robocopy-mir-log.txt"
    $robocopyCommand = "robocopy `"$Source`" `"$Destination`" /MIR /Z /J /MT:64 /R:2 /W:2 /NFL /NDL /LOG+:`"$logFile`""

    # Run as a background job if specified
    if ($RunAsJob) {
        $job = Start-Job -Name $JobName -ScriptBlock {
            param ($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $robocopyCommand

        Write-Host "Started Robocopy as background job with Job ID : $($job.Id)."
        Write-Host "Use 'Get-Job -Name $JobName' to check status or 'Receive-Job -Name $JobName' to view output."
        return
    }

    # Run in foreground
    Write-Host "Running Robocopy in foreground..."
    Invoke-Expression $robocopyCommand
}


#################

function rudun {
    param (
        [string]$largerfolderPath1 = (Read-Host "Enter the path of the larger folder").Trim(),
        [string]$smallerfolderPath2 = (Read-Host "Enter the path of the smaller folder").Trim(),
        [string]$jobname = (Read-Host "Enter the job name").Trim()
    )

    # Ask user if they want to run the function as a background job
    $runAsJob = Read-Host "Do you want to run this in the background? (Y/N)"
    
    if ($runAsJob -match "^[Yy]") {
        # Start as a background job
        $job = Start-Job -Name $jobname -ScriptBlock {
            param ($largerfolderPath1, $smallerfolderPath2)

            # Validate larger folder path once
            if (-not (Test-Path -Path $largerfolderPath1)) {
                Write-Host "Error: The larger folder does not exist." -ForegroundColor Red
                return
            }

            # Get total size of the larger folder (won't change)
            $largerSize = (Get-ChildItem -Path $largerfolderPath1 -File -Recurse | Measure-Object -Property Length -Sum).Sum
            if (-not $largerSize) { 
                Write-Host "Error: Larger folder size is 0, cannot calculate percentage." -ForegroundColor Red
                return
            }

            Write-Host "Monitoring $smallerfolderPath2 until it reaches 100% of $largerfolderPath1..."
            Write-Host "Total size of $largerfolderPath1 : $([math]::Round(($largerSize / 1GB), 2)) GB"

            # Loop until $smallerSize matches $largerSize
            do {
                # Ensure the smaller folder still exists
                if (-not (Test-Path -Path $smallerfolderPath2)) {
                    Write-Host "Error: The smaller folder is no longer accessible. Exiting." -ForegroundColor Red
                    return
                }

                # Get total size of the smaller folder
                $smallerSize = (Get-ChildItem -Path $smallerfolderPath2 -File -Recurse | Measure-Object -Property Length -Sum).Sum
                if (-not $smallerSize) { $smallerSize = 0 }  # Handle empty folder scenario

                # Calculate percentage completion
                $percentComplete = ($smallerSize / $largerSize) * 100
                Write-Host "Current size of $smallerfolderPath2 : $([math]::Round(($smallerSize / 1GB), 2)) GB"
                Write-Host "Percent complete: $([math]::Round($percentComplete, 2))%"

                # Exit loop when 100% is reached
                if ($percentComplete -ge 100) {
                    Write-Host "✅ Synchronization Complete: $smallerfolderPath2 has reached 100% of $largerfolderPath1!"
                    break
                }

                # Short delay to avoid excessive network usage
                Start-Sleep -Seconds 2

            } while ($true)

        } -ArgumentList $largerfolderPath1, $smallerfolderPath2

        Write-Host "Started rudun as background job with Job Name: $jobname"
        Write-Host "Use 'Get-Job -Name $jobname' to check status or 'Receive-Job -Name $jobname' to view output."
        Get-Job  # Display running jobs
        return
    }

    # RUN IN FOREGROUND IF NOT A JOB
    # Validate larger folder path once
    if (-not (Test-Path -Path $largerfolderPath1)) {
        Write-Host "Error: The larger folder does not exist." -ForegroundColor Red
        return
    }

    # Get total size of the larger folder (won't change)
    $largerSize = (Get-ChildItem -Path $largerfolderPath1 -File -Recurse | Measure-Object -Property Length -Sum).Sum
    if (-not $largerSize) { 
        Write-Host "Error: Larger folder size is 0, cannot calculate percentage." -ForegroundColor Red
        return
    }

    Write-Host "Monitoring $smallerfolderPath2 until it reaches 100% of $largerfolderPath1..."
    Write-Host "Total size of $largerfolderPath1 : $([math]::Round(($largerSize / 1GB), 2)) GB"

    # Loop until $smallerSize matches $largerSize
    do {
        # Ensure the smaller folder still exists
        if (-not (Test-Path -Path $smallerfolderPath2)) {
            Write-Host "Error: The smaller folder is no longer accessible. Exiting." -ForegroundColor Red
            return
        }

        # Get total size of the smaller folder
        $smallerSize = (Get-ChildItem -Path $smallerfolderPath2 -File -Recurse | Measure-Object -Property Length -Sum).Sum
        if (-not $smallerSize) { $smallerSize = 0 }  # Handle empty folder scenario

        # Calculate percentage completion
        $percentComplete = ($smallerSize / $largerSize) * 100
        Write-Host "Current size of $smallerfolderPath2 : $([math]::Round(($smallerSize / 1GB), 2)) GB"
        Write-Host "Percent complete: $([math]::Round($percentComplete, 2))%"

        # Exit loop when 100% is reached
        if ($percentComplete -ge 100) {
            Write-Host "✅ Synchronization Complete: $smallerfolderPath2 has reached 100% of $largerfolderPath1!"
            break
        }

        # Short delay to avoid excessive network usage
        Start-Sleep -Seconds 2

    } while ($true)
}


###############

#function notepadnew {
#C:\Windows\System32\notepad.exe
#}

#Set-Alias -Name notepadnew -Value "C:\Windows\System32\notepad.exe"


###############

#Set-Alias -Name notepad++ -Value "C:\Program Files\Notepad++\notepad++.exe"


###############

function move-autodesk-nojob {
    $sourceroot = 'C:\Temp\Autodesk'
    $sourcename = Read-Host "Source folder name"
    $source = Join-Path $sourceroot $sourcename

    $destinationroot = '\\clesccm\Application Source\Cad Applications\! Pending Creation'
    $destfolderdate = Get-Date -Format "yyyyMMdd"
    $destination = Join-Path $destinationroot $destfolderdate

    Write-Host "Source : '$source'"
    Write-Host "Destination : '$destination'"

    $src = $source
    $dest = $destination  # ✅ Corrected the typo

    # Ensure destination exists
    if (!(Test-Path $dest)) {
        New-Item -Path $dest -ItemType Directory -Force | Out-Null
    }

    # Move the folder
    Move-Item -Path $src -Destination $dest -Force
}

###############

function move-autodesk-job {
    $sourceroot = 'C:\Temp\Autodesk'
    $sourcename = Read-Host "Source folder name"
    $source = Join-Path $sourceroot $sourcename

    $destinationroot = '\\clesccm\Application Source\Cad Applications\! Pending Creation'
    $destfolderdate = Get-Date -Format "yyyyMMdd"
    $destination = Join-Path $destinationroot $destfolderdate

    Write-Host "Source : '$source'"
    Write-Host "Destination : '$destination'"

    # Calculate folder size
    if (Test-Path $source) {
        $size = (Get-ChildItem -Path $source -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB
        Write-Host ("Source folder size: {0:N2} GB" -f $size)
    } else {
        Write-Host "Error: Source folder does not exist!"
        return
    }

    # Ensure destination exists
    if (!(Test-Path $destination)) {
        New-Item -Path $destination -ItemType Directory -Force | Out-Null
    }

    # Start a background job to move the folder
    Start-Job -Name ("Move_" + ($sourcename -replace '\s+', '_')) -ScriptBlock {
        param ($src, $dest)
        Move-Item -Path $src -Destination $dest -Force
    } -ArgumentList $source, $destination

    Write-Host "Move operation started as a background job. Use 'Get-Job' to check the status."
}
##############

#Generate Random Password (with limits)
function genrandpw {
# Define a character set for the password
#$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?"
$chars = "abcdefghijkmnopqrstuvwxyz" #removed lowercase 'l' lima and upper, num, symbols

# Create a random password generator
$random = New-Object System.Random

# Generate a random password with 7 characters
$randomPassword = -join (1..7 | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
$randomPasswordz = -join ("A",$randomPassword,"2!") #add A prefix and 2! suffix so final password length is 10 characters

# Output the generated password
Write-Host "The generated password is: $randomPasswordz"

# Copy the generated password to the clipboard (PowerShell 5.0+)
Set-Clipboard -Value $randomPasswordz
Write-Host "Password copied to clipboard."
}

###############
# get revit 2022 or 2024 file version from revit.exe
function revit2024ver {
$computerr24 = read-host("computer name")
cd "\\$computerr24\c$\program files\Autodesk\revit 2024"
$execfiler24 = get-item 'revit.exe'
$fileVersionr24 = $execfiler24.VersionInfo.FileVersion
$fileVersionr24
}

function revit2022ver {
$computerr22 = read-host("computer name")
cd "\\$computerr22\c$\program files\Autodesk\revit 2022"
$execfiler22 = get-item 'revit.exe'
$fileVersionr22 = $execfiler22.VersionInfo.FileVersion
$fileVersionr22
}

###############

$onedrivepath = 'C:\users\jason.lamb\OneDrive - middough'
$githubpath = "$onedrivepath\documents\github"
$gitpspath = "$githubpath\powershell"
$temppath = 'C:temp'
$ccmcache = 'C:\windows\ccmcache'
$clesccm = '\\clesccm\e$\application source\cad applications'
$middlocal = '\\middough.local\corp\data'
#Function np { & 'C:\Program Files (x86)\Notepad++\notepad++.exe' @args }
#Function notepadnew { & 'C:\Windows\System32\notepad.exe' @args }
$psexec = "$onedrivepath\Github\PsExec"
$domain = "middough" #${domain} for no space
$domainup = "Middough" #${domain} for no space
$username = "jason.lamb" #${username} for no space
$ndrive = "\\middough.local\corp\data\proj"
$udrive = "\\middough.local\corp\data\dept"

######################

# delete duplicate desktop files on the desktop from OneDrive with the same "middough inc-*.lnk"
function delete-dupdesktop {
$desktopfolder = "C:\users\$env:username\onedrive - middough\desktop"
$desktopfiles = Get-ChildItem -Path $desktopfolder -Filter "middough inc-*.lnk"
foreach ($dupfile in $desktopfiles) {
Write-host "File deleted: $dupfile"
	Remove-Item -Path $dupfile.FullName -Force
}
}
delete-dupdesktop

######################
$datetime = $null
<#
function datetime {
Write-Host ($datetime = Get-Date -Format "yyMMdd-HHmmss")
Write-Host ($datetime1 = Get-Date -Format "yy-MM-dd-HH-mm-ss")
Write-Host ($datetime2 = Get-Date -Format "yyyy-MM-dd-HH-mm-ss")
}
#>
function datetime {
    $global:datetime = Get-Date -Format "yyMMdd-HHmmss"
    $global:datetime1 = Get-Date -Format "yyyyMMdd-HHmmss"
    $global:datetime2 = Get-Date -Format "yy-MM-dd-HH-mm-ss"
    $global:datetime3 = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
    Write-Host "`$datetime "$global:datetime
#    Write-Host "`$datetime1 "$global:datetime1
#    Write-Host "`$datetime2 "$global:datetime2
#    Write-Host "`$datetime3 "$global:datetime3
}
datetime
$datetime

######################
function pingpsdrive {
# Create PSDrive for pingable computers

# Get the current computer name
$CurrentComputer = $env:COMPUTERNAME

# Prompt for admin credentials
#$admincred = Get-Credential

# Define a script block to check connectivity and create PSDrive
$scriptBlock = {
    param ($Computer, $CurrentComputer, $admincred)

    if ($Computer.ComputerName -eq $CurrentComputer) {
        Write-Host "$($Computer.ComputerName) is the current computer. Skipping..."
        return
    }

    # Ping the computer first
    $pingResult = Test-Connection $Computer.ComputerName -Count 1 -ErrorAction SilentlyContinue
    if ($pingResult) {
        # Check if the PSDrive already exists
        $existingDrive = Get-PSDrive -Name $Computer.ComputerName -ErrorAction SilentlyContinue

        if ($existingDrive) {
            Write-Host "PSDrive for $($Computer.ComputerName) already exists. Skipping creation."
            return
        }

        # Check if the UNC path exists
        $driveRoot = "\\$($Computer.ComputerName)\c$"
        if (Test-Path $driveRoot) {
            try {
                # Create the PSDrive without output
                New-PSDrive -Name $Computer.ComputerName -PSProvider FileSystem -Root $driveRoot -Credential $admincred | Out-Null
                Write-Host "PSDrive created for $($Computer.ComputerName)"
            } catch {
                Write-Host "Failed to create PSDrive for $($Computer.ComputerName): $_"
            }
        } else {
            Write-Host "The drive root $driveRoot does not exist or is not a valid folder. Skipping creation."
        }
    } else {
        Write-Host "$($Computer.ComputerName) is offline. No PSDrive created."
    }
}

# Start jobs for each computer to run in parallel
$jobs = @()
foreach ($Computer in $Computers) {
    $jobs += Start-Job -ScriptBlock $scriptBlock -ArgumentList $Computer, $CurrentComputer, $admincred
}

# Wait for all jobs to finish
$jobs | ForEach-Object { 
    # Wait for each job to complete
    $null = Wait-Job -Job $_ 
    # Get the job output (if any)
    Receive-Job -Job $_
    # Clean up job
    Remove-Job -Job $_
}
}

######################

$env:Path += ";C:\ProgramData\chocolatey\bin"

######################

$users = 'jason.lamb', 'adm.jlamb'
$users | ForEach-Object {
    Get-ADUser -Identity $_ -Properties msDS-UserPasswordExpiryTimeComputed |
    Select-Object Name, @{Name="PasswordExpiryDate"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
} | Sort-Object PasswordExpiryDate

######################

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    # Place code to run as admin here
    Write-Host "Running as administrator. Script will execute."
    # ...your script...
} else {
    Write-Host "Not running as administrator. Script will not execute."
    # Optionally, exit or prompt user
    # exit
}

######################

$psetemp = 'c:\temp\powershell-exports'

######################

function jlgitcom2 {
$current = (Get-Location).Path
    Git-Commit-PowerShell-Private
    Git-Commit-PowerShell
Set-Location $current
}

######################

function jlgps2 {
$current = (Get-Location).Path
    Git-PowerShell-Private-Sync
    Git-PowerShell-Sync
Set-Location $current
}

#####################

function dirtoday {
Get-ChildItem -Path . -Recurse | Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date }
}

######################

function fedex {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the FedEx tracking URL
    $url = "https://www.fedex.com/fedextrack/?trknbr=$TrackingNumber"

    # Launch Chrome in a new window pointing to the tracking URL
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

######################

function ups {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the UPS tracking URL
    $url = "https://www.ups.com/track?track=yes&trackNums=$TrackingNumber"

    # Launch Chrome in a new window with the tracking page
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

######################

function usps {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the USPS tracking URL using the qtc_tLabels1 parameter
    $url = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=$TrackingNumber"

    # Launch Chrome in a new window with the constructed URL
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or future use
    return $url
}

######################

function Get-Carrier {
    param([string]$tn)
    switch -regex ($tn) {
        '^(?i)1Z[0-9A-Z]{16}$'                { return 'UPS' }
        '^(?i)\d{12}$'                        { return 'FedEx' }
        '^(?i)9[0-9]{21}$'                    { return 'USPS' }
        default                               { return $null }
    }
}

function Track-Package {
    param([Parameter(Mandatory)][string]$TrackingNumber)

    $carrier = Get-Carrier $TrackingNumber
    if (-not $carrier) {
        Write-Warning "Unrecognized tracking number format: $TrackingNumber"; return
    }

    switch ($carrier) {
        'UPS'   { $url = "https://www.ups.com/track?track=yes&trackNums=$TrackingNumber" }
        'FedEx' { $url = "https://www.fedex.com/fedextrack/?trknbr=$TrackingNumber" }
        'USPS'  { $url = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=$TrackingNumber" }
    }

    Write-Output "Carrier detected: $carrier"
    Write-Output "Tracking URL: $url"

    Start-Process chrome.exe "--new-window $url"
}


######################

. '$onedrivepath\Documents\GitHub\!PS-custom-faq-help.ps1'

######################

# Revision : 1.0
# Description : Launches Dell support page for a given service tag in a new Chrome window and returns the URL
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-20
# Modified Date : 2025-08-20

function dell {
    param(
        [Parameter(Mandatory)][string]$ServiceTag
    )

    # Construct the Dell support URL
    $url = "https://www.dell.com/support/home/en-us/product-support/servicetag/$ServiceTag"

    # Launch Chrome in a new window with the support page
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

# call with 'dell 7QBMYK3'
# returns
# C:\> dell 7QBMYK3
# https://www.dell.com/support/home/en-us/product-support/servicetag/7QBMYK3
# launches chrome in new window

#. '$onedrivepath\Documents\GitHub\PowerShell-Private\File-Management-Scripts\compare-source-destination-files-and-csv-export-diff.ps1'

######################

# =========================
# Run-Once-Per-Day Guard
# Rev: 1.3  (J. Lamb)
# =========================

# Assumes $githubpath is set elsewhere in your $PROFILE
$stateRoot = Join-Path $githubpath "Daily Run Status"
$stampFile = Join-Path $stateRoot "daily-run.txt"
$today     = Get-Date -Format 'yyyy-MM-dd'

if (-not (Test-Path $stateRoot)) {
    New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
}

# Read last-run date: find the first line that matches YYYY-MM-DD
$last = $null
if (Test-Path $stampFile) {
    $lines = Get-Content -Path $stampFile -ErrorAction SilentlyContinue
    foreach ($line in $lines) {
        $t = $line.Trim()
        if ($t -match '^\d{4}-\d{2}-\d{2}$') { $last = $t; break }
    }
}

# Helper: locked write of header + date (prevents races)
function Set-DailyStamp {
    param([string] $Path, [string] $Date)

    $contentLines = @('#DO NOT CHANGE THIS FILE', $Date)

    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $fs = [System.IO.File]::Open($Path,
        [System.IO.FileMode]::OpenOrCreate,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None)
    try {
        $text  = ($contentLines -join [Environment]::NewLine) + [Environment]::NewLine
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        $fs.SetLength(0); $fs.Write($bytes,0,$bytes.Length); $fs.Flush()
    } finally { $fs.Dispose() }
}

# --- Only run once per calendar day ---
if ($last -ne $today) {

    # ===== Your once-per-day steps =====
    try {
        # 1) Security Now! fetch
        & '$onedrivepath\Documents\GitHub\PowerShell\GRC-TWIT-SecurityNow-Transcripts\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1'

        # 2) File compare + CSV diff
        & '$onedrivepath\Documents\GitHub\PowerShell-Private\File-Management-Scripts\compare-source-destination-files-and-csv-export-diff.ps1'

        # 3) Git sync function
        jlgps2

        # ✅ Only stamp AFTER all above attempted
        Set-DailyStamp -Path $stampFile -Date $today
        Write-Host "Daily tasks complete : stamped $today" -ForegroundColor Green  # (space before colon, just how you like it)
    }
    catch {
        Write-Warning "Daily tasks failed : $($_.Exception.Message)"
        # No stamp on failure -> will try again next session
    }
}
else {
    Write-Host "Daily tasks already stamped for $today : skipping" -ForegroundColor Yellow
}
