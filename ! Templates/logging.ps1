# Logging template. Rename this file to logging.ps1 if used directly.
$LogRoot = if ($env:psexports) {
    $env:psexports
} else {
    Join-Path -Path $HOME -ChildPath 'powershell-exports'
}

if (-not (Test-Path -LiteralPath $LogRoot)) {
    New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
}

$ScriptBaseName = if ($PSCommandPath) {
    [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
} else {
    'PowerShellScript'
}

$LogFile = Join-Path -Path $LogRoot -ChildPath "$ScriptBaseName-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $Line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    $Line | Tee-Object -FilePath $LogFile -Append
}
