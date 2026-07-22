#Requires -Version 5.1
<#
.SYNOPSIS
    Master Shell - PowerShell Script Directory & Launcher
.DESCRIPTION
    Central hub for discovering and launching any script in this repository.
    Browse by category, search by keyword, view script descriptions, and run
    any subscript directly from this menu.
.NOTES
    Author  : Jason Lamb (jasrasr)
    Website : https://jasr.me/ps1
    Version : 1.0
    Requires: PowerShell 5.1+
#>

Set-StrictMode -Off

# ── Paths ─────────────────────────────────────────────────────────────────────
$script:RepoRoot = $PSScriptRoot

# ── Colour palette ────────────────────────────────────────────────────────────
$C = @{
    Title    = 'Cyan'
    Header   = 'Yellow'
    Category = 'Green'
    Script   = 'White'
    Dim      = 'DarkGray'
    Prompt   = 'Magenta'
    Error    = 'Red'
    Success  = 'Green'
    Info     = 'DarkCyan'
    Number   = 'DarkYellow'
}

# ── Categories to skip ────────────────────────────────────────────────────────
$script:SkipDirs = @('.git', '.github', 'ImageMagick', 'Downloads', 'Testing', 'Lock-Screen')

# ══════════════════════════════════════════════════════════════════════════════
#  Helper functions
# ══════════════════════════════════════════════════════════════════════════════

function Write-Banner {
    Clear-Host
    Write-Host ''
    Write-Host '  ╔══════════════════════════════════════════════════════════════╗' -ForegroundColor $C.Title
    Write-Host '  ║         POWERSHELL MASTER SHELL  –  Script Launcher          ║' -ForegroundColor $C.Title
    Write-Host '  ║              https://jasr.me/ps1  •  jasrasr                 ║' -ForegroundColor $C.Dim
    Write-Host '  ╚══════════════════════════════════════════════════════════════╝' -ForegroundColor $C.Title
    Write-Host ''
}

function Get-ScriptDescription {
    <#
    .SYNOPSIS Returns the first meaningful comment line from a .ps1 file as its description.
    #>
    param([string]$Path)

    try {
        $lines = Get-Content -Path $Path -TotalCount 30 -ErrorAction SilentlyContinue
        foreach ($line in $lines) {
            $trimmed = $line.Trim()
            # Skip blank lines, #Requires, shebang lines, and block comment markers
            if ($trimmed -match '^#\s*Requires' -or
                $trimmed -eq '#' -or
                $trimmed -match '^<#' -or
                $trimmed -match '^#>' -or
                $trimmed -eq '') { continue }

            # .SYNOPSIS value (next line after .SYNOPSIS)
            if ($trimmed -match '^\.(SYNOPSIS|DESCRIPTION)$') { continue }

            # Return the first non-boilerplate comment or code description
            if ($trimmed -match '^#+\s*(.+)') {
                return $Matches[1].Trim()
            }
            # Non-comment line → use first word as hint
            if ($trimmed.Length -gt 0) {
                return "(no description)"
            }
        }
    } catch { }
    return "(no description)"
}

function Get-Categories {
    <#
    .SYNOPSIS Enumerates all script categories (subdirectories) in the repo.
    #>
    $dirs = Get-ChildItem -Path $script:RepoRoot -Directory |
        Where-Object { $_.Name -notin $script:SkipDirs } |
        Sort-Object Name

    # Add a virtual "Root Scripts" entry for top-level .ps1 files
    $rootScripts = Get-ChildItem -Path $script:RepoRoot -Filter '*.ps1' -File
    $categories  = [System.Collections.Generic.List[object]]::new()

    if ($rootScripts.Count -gt 0) {
        $categories.Add([PSCustomObject]@{
            Name        = 'Root Scripts'
            FullName    = $script:RepoRoot
            ScriptCount = $rootScripts.Count
            IsRoot      = $true
        })
    }

    foreach ($dir in $dirs) {
        $count = (Get-ChildItem -Path $dir.FullName -Filter '*.ps1' -Recurse -File -ErrorAction SilentlyContinue).Count
        if ($count -gt 0) {
            $categories.Add([PSCustomObject]@{
                Name        = $dir.Name
                FullName    = $dir.FullName
                ScriptCount = $count
                IsRoot      = $false
            })
        }
    }

    return $categories
}

function Get-ScriptsInCategory {
    <#
    .SYNOPSIS Returns all .ps1 files inside a given directory (recursive).
    #>
    param([string]$Path, [bool]$RootOnly = $false)

    if ($RootOnly) {
        Get-ChildItem -Path $Path -Filter '*.ps1' -File | Sort-Object Name
    } else {
        Get-ChildItem -Path $Path -Filter '*.ps1' -File -Recurse |
            Where-Object { $_.DirectoryName -notmatch '\\\.git(\\|$)' } |
            Sort-Object Name
    }
}

function Show-Categories {
    param([System.Collections.Generic.List[object]]$Categories)

    Write-Host '  Script Categories' -ForegroundColor $C.Header
    Write-Host '  ─────────────────────────────────────────────────' -ForegroundColor $C.Dim
    Write-Host ''

    $i = 1
    foreach ($cat in $Categories) {
        $num    = "  [{0,2}]" -f $i
        $name   = $cat.Name.PadRight(38)
        $count  = "({0} scripts)" -f $cat.ScriptCount
        Write-Host $num -ForegroundColor $C.Number -NoNewline
        Write-Host "  $name" -ForegroundColor $C.Category -NoNewline
        Write-Host " $count" -ForegroundColor $C.Dim
        $i++
    }

    Write-Host ''
    Write-Host '  [ S]  Search all scripts by keyword' -ForegroundColor $C.Info
    Write-Host '  [ V]  Run Validation (Validate-Scripts.ps1)' -ForegroundColor $C.Info
    Write-Host '  [ Q]  Quit' -ForegroundColor $C.Dim
    Write-Host ''
}

function Show-ScriptsInCategory {
    param(
        [PSCustomObject]$Category,
        [System.Collections.Generic.List[object]]$Scripts
    )

    Write-Host ''
    Write-Host ("  Category: {0}" -f $Category.Name) -ForegroundColor $C.Header
    Write-Host '  ─────────────────────────────────────────────────' -ForegroundColor $C.Dim
    Write-Host ''

    $i = 1
    foreach ($s in $Scripts) {
        $desc = Get-ScriptDescription -Path $s.FullName
        $rel  = $s.FullName.Replace($script:RepoRoot, '').TrimStart('\','/')
        $num  = "  [{0,3}]" -f $i
        Write-Host $num -ForegroundColor $C.Number -NoNewline
        Write-Host "  $($s.Name)" -ForegroundColor $C.Script -NoNewline
        Write-Host "  →  " -ForegroundColor $C.Dim -NoNewline
        Write-Host $desc -ForegroundColor $C.Dim
        if ($rel -ne $s.Name) {
            Write-Host ("         " + $rel) -ForegroundColor $C.Dim
        }
        $i++
    }

    Write-Host ''
    Write-Host '  [ B]  Back to categories' -ForegroundColor $C.Info
    Write-Host '  [ Q]  Quit' -ForegroundColor $C.Dim
    Write-Host ''
}

function Invoke-ScriptLauncher {
    <#
    .SYNOPSIS Prompts for optional parameters then dot-sources or launches the chosen script.
    #>
    param([System.IO.FileInfo]$ScriptFile)

    Write-Host ''
    Write-Host ("  Preparing to run: {0}" -f $ScriptFile.Name) -ForegroundColor $C.Success
    Write-Host ("  Full path: {0}" -f $ScriptFile.FullName) -ForegroundColor $C.Dim
    Write-Host ''
    Write-Host '  Enter any arguments (press Enter to skip): ' -ForegroundColor $C.Prompt -NoNewline
    $argsInput = Read-Host

    Write-Host ''
    Write-Host '  How would you like to run this script?' -ForegroundColor $C.Header
    Write-Host '  [1]  & (Run in current session)'  -ForegroundColor $C.Script
    Write-Host '  [2]  Start-Process pwsh (new window)' -ForegroundColor $C.Script
    Write-Host '  [3]  Cancel' -ForegroundColor $C.Dim
    Write-Host ''
    Write-Host '  Choice: ' -ForegroundColor $C.Prompt -NoNewline
    $runChoice = Read-Host

    switch ($runChoice.Trim()) {
        '1' {
            Write-Host ''
            Write-Host '  Running script...' -ForegroundColor $C.Success
            Write-Host ('  ' + ('─' * 60)) -ForegroundColor $C.Dim
            Write-Host ''
            try {
                if ($argsInput.Trim() -ne '') {
                    $argArray = $argsInput -split '\s+(?=(?:[^"]*"[^"]*")*[^"]*$)'
                    & $ScriptFile.FullName @argArray
                } else {
                    & $ScriptFile.FullName
                }
            } catch {
                Write-Host ("  ERROR: {0}" -f $_.Exception.Message) -ForegroundColor $C.Error
            }
            Write-Host ''
            Write-Host ('  ' + ('─' * 60)) -ForegroundColor $C.Dim
            Write-Host '  Script finished. Press Enter to continue...' -ForegroundColor $C.Dim
            $null = Read-Host
        }
        '2' {
            $pwsh = if (Get-Command 'pwsh' -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }
            $args = if ($argsInput.Trim() -ne '') { "-File `"$($ScriptFile.FullName)`" $argsInput" } `
                    else { "-File `"$($ScriptFile.FullName)`"" }
            Start-Process $pwsh -ArgumentList $args
            Write-Host '  Script launched in new window.' -ForegroundColor $C.Success
            Start-Sleep -Seconds 1
        }
        default {
            Write-Host '  Cancelled.' -ForegroundColor $C.Dim
            Start-Sleep -Milliseconds 500
        }
    }
}

function Search-Scripts {
    <#
    .SYNOPSIS Searches all script names and descriptions for a keyword.
    #>
    Write-Host ''
    Write-Host '  Search all scripts' -ForegroundColor $C.Header
    Write-Host '  ─────────────────────────────────────────────────' -ForegroundColor $C.Dim
    Write-Host '  Keyword: ' -ForegroundColor $C.Prompt -NoNewline
    $keyword = Read-Host

    if ([string]::IsNullOrWhiteSpace($keyword)) { return }

    Write-Host ''
    Write-Host ("  Results for: '{0}'" -f $keyword) -ForegroundColor $C.Header
    Write-Host '  ─────────────────────────────────────────────────' -ForegroundColor $C.Dim
    Write-Host ''

    $allScripts = Get-ChildItem -Path $script:RepoRoot -Filter '*.ps1' -Recurse -File |
        Where-Object { $_.FullName -notmatch '[/\\]\.git[/\\]' }

    $results = [System.Collections.Generic.List[System.IO.FileInfo]]::new()

    foreach ($s in $allScripts) {
        $desc = Get-ScriptDescription -Path $s.FullName
        $rel  = $s.FullName.Replace($script:RepoRoot, '').TrimStart('\','/')
        if ($rel -match [regex]::Escape($keyword) -or $desc -match [regex]::Escape($keyword)) {
            $results.Add($s)
        }
    }

    if ($results.Count -eq 0) {
        Write-Host '  No scripts matched your search.' -ForegroundColor $C.Dim
    } else {
        $i = 1
        foreach ($s in $results) {
            $rel  = $s.FullName.Replace($script:RepoRoot, '').TrimStart('\','/')
            $desc = Get-ScriptDescription -Path $s.FullName
            Write-Host ("  [{0,3}]  {1}" -f $i, $rel) -ForegroundColor $C.Script
            Write-Host ("         {0}" -f $desc) -ForegroundColor $C.Dim
            $i++
        }

        Write-Host ''
        Write-Host ('  Enter a number to run a script, or press Enter to go back: ') -ForegroundColor $C.Prompt -NoNewline
        $pick = Read-Host
        if ($pick -match '^\d+$') {
            $idx = [int]$pick - 1
            if ($idx -ge 0 -and $idx -lt $results.Count) {
                Invoke-ScriptLauncher -ScriptFile $results[$idx]
            }
        }
    }

    Write-Host ''
    Write-Host '  Press Enter to continue...' -ForegroundColor $C.Dim
    $null = Read-Host
}

# ══════════════════════════════════════════════════════════════════════════════
#  Main loop
# ══════════════════════════════════════════════════════════════════════════════

function Start-MainShell {
    $validationScript = Join-Path $script:RepoRoot 'Validate-Scripts.ps1'

    :mainLoop while ($true) {

        Write-Banner
        $categories = Get-Categories
        Show-Categories -Categories $categories

        Write-Host '  Select a category number (or S / V / Q): ' -ForegroundColor $C.Prompt -NoNewline
        $choice = Read-Host

        switch -Regex ($choice.Trim().ToUpper()) {

            '^Q$' {
                Write-Host ''
                Write-Host '  Goodbye!' -ForegroundColor $C.Success
                Write-Host ''
                break mainLoop
            }

            '^S$' {
                Write-Banner
                Search-Scripts
            }

            '^V$' {
                if (Test-Path $validationScript) {
                    Write-Host ''
                    Write-Host '  Launching Validate-Scripts.ps1 ...' -ForegroundColor $C.Success
                    Write-Host ''
                    & $validationScript
                    Write-Host ''
                    Write-Host '  Press Enter to return to main menu...' -ForegroundColor $C.Dim
                    $null = Read-Host
                } else {
                    Write-Host ''
                    Write-Host '  Validate-Scripts.ps1 not found. Run Main-Shell.ps1 from the repo root.' -ForegroundColor $C.Error
                    Start-Sleep -Seconds 2
                }
            }

            '^\d+$' {
                $idx = [int]$choice - 1
                if ($idx -lt 0 -or $idx -ge $categories.Count) {
                    Write-Host '  Invalid selection.' -ForegroundColor $C.Error
                    Start-Sleep -Milliseconds 800
                    continue
                }

                $selectedCat = $categories[$idx]
                $isRoot      = $selectedCat.IsRoot

                :categoryLoop while ($true) {

                    Write-Banner
                    $scripts = [System.Collections.Generic.List[System.IO.FileInfo]](
                        Get-ScriptsInCategory -Path $selectedCat.FullName -RootOnly $isRoot
                    )
                    Show-ScriptsInCategory -Category $selectedCat -Scripts $scripts

                    Write-Host '  Select a script number (or B / Q): ' -ForegroundColor $C.Prompt -NoNewline
                    $scriptChoice = Read-Host

                    switch -Regex ($scriptChoice.Trim().ToUpper()) {
                        '^Q$' {
                            Write-Host ''
                            Write-Host '  Goodbye!' -ForegroundColor $C.Success
                            Write-Host ''
                            break mainLoop
                        }
                        '^B$' { break categoryLoop }
                        '^\d+$' {
                            $sIdx = [int]$scriptChoice - 1
                            if ($sIdx -lt 0 -or $sIdx -ge $scripts.Count) {
                                Write-Host '  Invalid selection.' -ForegroundColor $C.Error
                                Start-Sleep -Milliseconds 800
                            } else {
                                Write-Banner
                                Invoke-ScriptLauncher -ScriptFile $scripts[$sIdx]
                            }
                        }
                        default {
                            Write-Host '  Invalid input. Enter a number, B, or Q.' -ForegroundColor $C.Error
                            Start-Sleep -Milliseconds 800
                        }
                    }
                }
            }

            default {
                Write-Host '  Invalid input. Enter a number, S, V, or Q.' -ForegroundColor $C.Error
                Start-Sleep -Milliseconds 800
            }
        }
    }
}

# ── Entry point ───────────────────────────────────────────────────────────────
Start-MainShell
