<# 
    Script     : Chrome-Clean.ps1
    Revision   : 1.0
    Description: Cleans Google Chrome junk for all local profiles (Default + Profile 1/2/…).
                 Supports Light (default) and Deep modes, kills Chrome before cleaning,
                 logs actions + freed space, and supports -WhatIf.
    Author     : Jason Lamb (with help from ChatGPT)
    Created    : 2025-09-22
    Modified   : 2025-09-22

    Usage:
      # Dry run (see what would happen)
      .\Chrome-Clean.ps1 -WhatIf

      # Light clean (safe: cache and temp only)
      .\Chrome-Clean.ps1

      # Deep clean (removes cookies/history etc.)
      .\Chrome-Clean.ps1 -Deep

      # Relaunch Chrome after cleaning
      .\Chrome-Clean.ps1 -Deep -Relaunch
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch] $Deep,
    [switch] $Relaunch
)

# ---------- Settings ----------
$logRoot = 'C:\temp\powershell-exports'
if (-not (Test-Path $logRoot)) { New-Item -ItemType Directory -Path $logRoot -Force | Out-Null }
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$logPath   = Join-Path $logRoot "chrome-clean-$timestamp.log"

# ---------- Helpers ----------
# Replace the existing Write-Log with this version that ignores -WhatIf
function Write-Log {
    param(
        [string] $Message,
        [string] $Level = 'INFO'
    )
    $line = "{0} [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message

    # Always print to console
    Write-Host $line

    # Bypass WhatIf by using .NET file I/O (AppendAllText creates the file if missing)
    try {
        [System.IO.File]::AppendAllText($logPath, $line + [Environment]::NewLine, [System.Text.Encoding]::UTF8)
    } catch {
        # As a fallback, at least show the error on screen
        Write-Host ("{0} [WARN] Failed to write log file : {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $_)
    }
}


function Get-FolderSizeBytes {
    param([string] $Path)
    if (-not (Test-Path $Path)) { return 0 }
    try {
        $sum = Get-ChildItem -LiteralPath $Path -Recurse -Force -ErrorAction SilentlyContinue |
               Where-Object { -not $_.PSIsContainer } |
               Measure-Object -Sum Length
        return ($sum.Sum | ForEach-Object { $_ })  # handle $null
    } catch {
        Write-Log "Error calculating size for $Path : $_" 'WARN'
        return 0
    }
}

function Remove-Path {
    param([string] $Target)
    if (Test-Path -LiteralPath $Target) {
        if ($PSCmdlet.ShouldProcess($Target, 'Remove-Item -Recurse -Force')) {
            try {
                Remove-Item -LiteralPath $Target -Recurse -Force -ErrorAction Stop
                Write-Log "Removed $Target"
            } catch {
                Write-Log "Failed to remove $Target : $_" 'WARN'
            }
        } else {
            Write-Log "Would remove $Target (WhatIf)"
        }
    }
}

function Stop-Chrome {
    $procs = Get-Process chrome -ErrorAction SilentlyContinue
    if ($procs) {
        if ($PSCmdlet.ShouldProcess('chrome.exe', 'Stop-Process -Force')) {
            try {
                Stop-Process -Name chrome -Force -ErrorAction Stop
                Start-Sleep -Milliseconds 500
                Write-Log 'Stopped chrome.exe'
            } catch {
                Write-Log "Error stopping chrome.exe : $_" 'WARN'
            }
        } else {
            Write-Log 'Would stop chrome.exe (WhatIf)'
        }
    } else {
        Write-Log 'chrome.exe not running'
    }
}

function Start-Chrome {
    $exe = Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'
    if (-not (Test-Path $exe)) {
        $exe = Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'
    }
    if (Test-Path $exe) {
        if ($PSCmdlet.ShouldProcess($exe, 'Start-Process')) {
            Start-Process $exe
            Write-Log 'Relaunched Chrome'
        } else {
            Write-Log 'Would relaunch Chrome (WhatIf)'
        }
    } else {
        Write-Log 'Chrome executable not found' 'WARN'
    }
}

# ---------- Targets ----------
$chromeUserData = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'
if (-not (Test-Path $chromeUserData)) {
    Write-Log "Chrome User Data folder not found at $chromeUserData" 'WARN'
    Write-Log "Nothing to do. Exiting."
    return
}

# Collect profiles: "Default" and any "Profile *"
$profiles = @()
$defaultPath = Join-Path $chromeUserData 'Default'
if (Test-Path $defaultPath) { $profiles += $defaultPath }
$profiles += Get-ChildItem -LiteralPath $chromeUserData -Directory -ErrorAction SilentlyContinue |
             Where-Object { $_.Name -like 'Profile *' } |
             Select-Object -ExpandProperty FullName

# Paths to wipe for Light vs Deep
$lightDirs = @(
    'Cache',
    'Code Cache',
    'GPUCache',
    'Service Worker',
    'ShaderCache',
    'Media Cache',
    'Crashpad',
    'GrShaderCache',
    'Safe Browsing',
    'Offline Web Application Cache',
    'File System',
    'IndexedDB',
    'Local Storage',
    'Session Storage'
)

# WARNING: Deep wipes cookies/history/etc.
$deepFiles = @(
    'Cookies',
    'Cookies-journal',
    'History',
    'History-journal',
    'History Provider Cache',
    'Network Action Predictor',
    'Visited Links',
    'Shortcuts',
    'Top Sites',
    'Top Sites-journal',
    'Favicons',
    'Favicons-journal',
    'Web Data',
    'Web Data-journal'
    # Intentionally NOT deleting 'Login Data' to avoid nuking saved passwords
)

$mode = if ($Deep) { 'Deep' } else { 'Light' }
Write-Log "=== Chrome Cleaner Started ($mode) ==="

Write-Log "Log file : $logPath"
Write-Log "Profiles detected : $($profiles -join ', ')"

# ---------- Execute ----------
Stop-Chrome

$totalFreed = 0
foreach ($prof in $profiles) {
    Write-Log "Processing profile : $prof"

    $before = Get-FolderSizeBytes -Path $prof

    # Light clean directories
    foreach ($dir in $lightDirs) {
        $target = Join-Path $prof $dir
        Remove-Path -Target $target
    }

    if ($Deep) {
        # Deep clean databases/files
        foreach ($f in $deepFiles) {
            $target = Join-Path $prof $f
            Remove-Path -Target $target
        }
    }

    $after = Get-FolderSizeBytes -Path $prof
    $freed = [math]::Max(0, $before - $after)
    $totalFreed += $freed

    # Pretty print sizes
    $fmt = [Func[UInt64,string]]{
        param([UInt64] $b)
        switch ($b) {
            {$_ -ge 1TB} { '{0:N2} TB' -f ($b/1TB); break }
            {$_ -ge 1GB} { '{0:N2} GB' -f ($b/1GB); break }
            {$_ -ge 1MB} { '{0:N2} MB' -f ($b/1MB); break }
            {$_ -ge 1KB} { '{0:N2} KB' -f ($b/1KB); break }
            default { "$b B" }
        }
    }

    Write-Log "Freed for profile : $($fmt.Invoke([uint64]$freed))"
}

Write-Log "Total freed space : $([string]([math]::Round($totalFreed/1MB,2))) MB"

if ($Relaunch) { Start-Chrome }

Write-Log '=== Done ==='
Write-Log "Tip : Run with -Deep for a full reset (you'll be logged out of sites)."
invoke-item -path $logPath