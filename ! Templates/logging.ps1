# Logging template. Rename this file to logging.ps1 if used directly.
# Preferred log location: $env:psexports, falling back to c:\temp\psexports.
# Preferred log name: <ScriptName>_<yyyyMMdd_HHmmss>.log
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logDir = $env:psexports
if (-not $logDir -or -not (Test-Path $logDir)) {
    $logDir = 'c:\temp\psexports'
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$ScriptBaseName = if ($PSCommandPath) {
    [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
} else {
    'PowerShellScript'
}

$logExport = Join-Path $logDir "${ScriptBaseName}_$timestamp.log"

function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $Line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    $Line | Tee-Object -FilePath $logExport -Append
}
