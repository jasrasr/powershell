#Requires -Version 5.1
<#
.SYNOPSIS
    Validate-Scripts.ps1 – Compatibility & Health Checker for all repo subscripts
.DESCRIPTION
    Scans every .ps1 file in this repository and checks:
      1. Syntax validity  – parses each script with the PowerShell AST parser
      2. #Requires version – compares against the current PS version
      3. Required modules  – detects Import-Module / #Requires -Module declarations
      4. Hardcoded paths   – flags absolute Windows paths that may not be portable
      5. Dangerous cmdlets – warns about Remove-Item -Recurse / Format-* disk ops
      6. Missing error handling – notes scripts that use no try/catch
      7. Credential exposure – detects plain-text password patterns

    Outputs a colour-coded report to the console and (optionally) exports to CSV.

.PARAMETER Path
    Root path to scan. Defaults to the directory containing this script.

.PARAMETER ExportCsv
    If specified, saves the full report to this CSV path.

.PARAMETER IncludePassing
    When set, passing scripts are also listed (default: only warnings/errors).

.PARAMETER Category
    Limit scanning to a specific subdirectory name (e.g. "AD-Scripts").

.EXAMPLE
    .\Validate-Scripts.ps1
    .\Validate-Scripts.ps1 -ExportCsv C:\Reports\ps1-validation.csv
    .\Validate-Scripts.ps1 -Category File-Management-Scripts -IncludePassing
.NOTES
    Author  : Jason Lamb (jasrasr)
    Website : https://jasr.me/ps1
    Version : 1.0
#>
[CmdletBinding()]
param(
    [string] $Path        = $PSScriptRoot,
    [string] $ExportCsv   = '',
    [switch] $IncludePassing,
    [string] $Category    = ''
)

Set-StrictMode -Off

# ── Colour palette ─────────────────────────────────────────────────────────────
$C = @{
    Title   = 'Cyan'
    Header  = 'Yellow'
    Pass    = 'Green'
    Warn    = 'DarkYellow'
    Fail    = 'Red'
    Info    = 'DarkCyan'
    Dim     = 'DarkGray'
    Prompt  = 'Magenta'
    Number  = 'DarkYellow'
}

# ── Directories to skip ────────────────────────────────────────────────────────
$SkipDirs = @('.git', '.github', 'ImageMagick', 'Downloads')

# ── Current PS version ────────────────────────────────────────────────────────
$CurrentPSVersion = $PSVersionTable.PSVersion

# ══════════════════════════════════════════════════════════════════════════════
#  Severity levels (ordered low → high)
# ══════════════════════════════════════════════════════════════════════════════
enum Severity { Pass; Info; Warning; Error }

# ══════════════════════════════════════════════════════════════════════════════
#  Check functions  (each returns [PSCustomObject[]] of findings)
# ══════════════════════════════════════════════════════════════════════════════

function Test-Syntax {
    <#
    .SYNOPSIS Uses the PowerShell AST parser to detect syntax errors.
    #>
    param([string]$FilePath)

    $errors  = $null
    $tokens  = $null
    $null    = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$tokens, [ref]$errors)

    if ($errors -and $errors.Count -gt 0) {
        foreach ($e in $errors) {
            [PSCustomObject]@{
                Check    = 'Syntax'
                Severity = [Severity]::Error
                Message  = "Line $($e.Extent.StartLineNumber): $($e.Message)"
            }
        }
    } else {
        [PSCustomObject]@{
            Check    = 'Syntax'
            Severity = [Severity]::Pass
            Message  = 'No syntax errors'
        }
    }
}

function Test-RequiresVersion {
    <#
    .SYNOPSIS Checks #Requires -Version against the running PS version.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) {
        return [PSCustomObject]@{ Check = 'PSVersion'; Severity = [Severity]::Info; Message = 'Empty or unreadable file' }
    }

    $match = [regex]::Match($content, '#Requires\s+-Version\s+([\d\.]+)', 'IgnoreCase')
    if (-not $match.Success) {
        return [PSCustomObject]@{ Check = 'PSVersion'; Severity = [Severity]::Info; Message = 'No #Requires -Version declaration' }
    }

    try {
        $required = [Version]$match.Groups[1].Value
        if ($CurrentPSVersion -lt $required) {
            return [PSCustomObject]@{
                Check    = 'PSVersion'
                Severity = [Severity]::Error
                Message  = "Requires PS $required but running PS $CurrentPSVersion"
            }
        }
        return [PSCustomObject]@{
            Check    = 'PSVersion'
            Severity = [Severity]::Pass
            Message  = "PS $required required – current PS $CurrentPSVersion  OK"
        }
    } catch {
        return [PSCustomObject]@{
            Check    = 'PSVersion'
            Severity = [Severity]::Warning
            Message  = "Could not parse version '$($match.Groups[1].Value)'"
        }
    }
}

function Test-RequiredModules {
    <#
    .SYNOPSIS Detects module dependencies and checks if they are installed.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    $moduleNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

    # #Requires -Module <name> or #Requires -Modules @('a','b')
    $requiresMatches = [regex]::Matches($content, '#Requires\s+-Modules?\s+(.+)', 'IgnoreCase')
    foreach ($m in $requiresMatches) {
        $raw = $m.Groups[1].Value -replace "@\(|'|""|`"|\)" , '' -replace '\s', ''
        foreach ($n in ($raw -split ',')) { if ($n) { $null = $moduleNames.Add($n) } }
    }

    # Import-Module "name" or Import-Module name
    $importMatches = [regex]::Matches($content, 'Import-Module\s+[''"]?([A-Za-z0-9\.\-_]+)[''"]?', 'IgnoreCase')
    foreach ($m in $importMatches) { $null = $moduleNames.Add($m.Groups[1].Value) }

    # Connect-* cmdlets often imply a module
    $connectMap = @{
        'Connect-AzureAD'         = 'AzureAD'
        'Connect-MsolService'     = 'MSOnline'
        'Connect-ExchangeOnline'  = 'ExchangeOnlineManagement'
        'Connect-MgGraph'         = 'Microsoft.Graph'
        'Connect-SPOService'      = 'Microsoft.Online.SharePoint.PowerShell'
        'Connect-MicrosoftTeams'  = 'MicrosoftTeams'
        'New-ADUser'              = 'ActiveDirectory'
        'Get-ADUser'              = 'ActiveDirectory'
    }
    foreach ($cmd in $connectMap.Keys) {
        if ($content -match [regex]::Escape($cmd)) {
            $null = $moduleNames.Add($connectMap[$cmd])
        }
    }

    if ($moduleNames.Count -eq 0) {
        return [PSCustomObject]@{ Check = 'Modules'; Severity = [Severity]::Info; Message = 'No module dependencies detected' }
    }

    $results = @()
    foreach ($mod in $moduleNames | Sort-Object) {
        $installed = Get-Module -Name $mod -ListAvailable -ErrorAction SilentlyContinue
        if ($installed) {
            $ver = ($installed | Sort-Object Version -Descending | Select-Object -First 1).Version
            $results += [PSCustomObject]@{
                Check    = 'Modules'
                Severity = [Severity]::Pass
                Message  = "Module '$mod' found (v$ver)"
            }
        } else {
            $results += [PSCustomObject]@{
                Check    = 'Modules'
                Severity = [Severity]::Warning
                Message  = "Module '$mod' NOT installed on this machine"
            }
        }
    }
    return $results
}

function Test-HardcodedPaths {
    <#
    .SYNOPSIS Warns about absolute Windows paths that will break on other systems.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    # Match C:\... D:\... \\server\share  but skip comment lines
    $lines   = $content -split "`n"
    $results = @()
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        $trimmed = $line.Trim()
        if ($trimmed -match '^#') { continue }   # skip full-line comments
        if ($trimmed -match '[A-Z]:\\' -or $trimmed -match '\\\\[A-Za-z0-9]') {
            $results += [PSCustomObject]@{
                Check    = 'HardcodedPaths'
                Severity = [Severity]::Warning
                Message  = "Line $lineNum may contain a hardcoded path: $($trimmed.Substring(0, [Math]::Min(80,$trimmed.Length)))"
            }
            if ($results.Count -ge 3) {
                $results += [PSCustomObject]@{
                    Check    = 'HardcodedPaths'
                    Severity = [Severity]::Warning
                    Message  = "... (additional hardcoded paths truncated)"
                }
                break
            }
        }
    }

    if ($results.Count -eq 0) {
        return [PSCustomObject]@{ Check = 'HardcodedPaths'; Severity = [Severity]::Pass; Message = 'No hardcoded Windows paths detected' }
    }
    return $results
}

function Test-DangerousCmdlets {
    <#
    .SYNOPSIS Flags cmdlets that can be destructive if run unintentionally.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    $dangerous = @(
        @{ Pattern = 'Remove-Item.+-Recurse'; Label = 'Remove-Item -Recurse (recursive delete)' }
        @{ Pattern = 'Format-Volume|Clear-Disk'; Label = 'Format-Volume / Clear-Disk (disk format)' }
        @{ Pattern = 'Stop-Computer|Restart-Computer'; Label = 'Stop/Restart-Computer (system power)' }
        @{ Pattern = 'Invoke-Expression|iex\b'; Label = 'Invoke-Expression / iex (code injection risk)' }
        @{ Pattern = 'DownloadString|WebClient.*Download'; Label = 'WebClient download (execution from web)' }
        @{ Pattern = '\[Net\.ServicePointManager\].*ServerCertificateValidationCallback'; Label = 'SSL validation disabled' }
    )

    $results = @()
    foreach ($item in $dangerous) {
        if ($content -match $item.Pattern) {
            $results += [PSCustomObject]@{
                Check    = 'DangerousCmdlets'
                Severity = [Severity]::Warning
                Message  = "Contains: $($item.Label)"
            }
        }
    }

    if ($results.Count -eq 0) {
        return [PSCustomObject]@{ Check = 'DangerousCmdlets'; Severity = [Severity]::Pass; Message = 'No dangerous cmdlets detected' }
    }
    return $results
}

function Test-ErrorHandling {
    <#
    .SYNOPSIS Notes scripts that have no try/catch, -ErrorAction, or trap blocks.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    $hasTry         = $content -match '\btry\s*\{'
    $hasErrorAction = $content -match '-ErrorAction\b'
    $hasTrap        = $content -match '\btrap\b'

    if (-not ($hasTry -or $hasErrorAction -or $hasTrap)) {
        return [PSCustomObject]@{
            Check    = 'ErrorHandling'
            Severity = [Severity]::Info
            Message  = 'No try/catch, -ErrorAction, or trap found – consider adding error handling'
        }
    }
    return [PSCustomObject]@{ Check = 'ErrorHandling'; Severity = [Severity]::Pass; Message = 'Error handling present' }
}

function Test-CredentialExposure {
    <#
    .SYNOPSIS Detects patterns that suggest plain-text credentials in source code.
    #>
    param([string]$FilePath)

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return }

    $patterns = @(
        @{ Pattern = 'password\s*=\s*["''][^"'']+["'']';        Label = 'Plain-text password assignment' }
        @{ Pattern = '\$pass(word)?\s*=\s*["''][^"'']+["'']';   Label = 'Plain-text $password variable' }
        @{ Pattern = 'ConvertTo-SecureString.+-AsPlainText';      Label = 'ConvertTo-SecureString -AsPlainText (credential in code)' }
        @{ Pattern = 'apikey|api_key|secret.{0,10}=\s*["'']';    Label = 'Possible API key / secret in source' }
    )

    $results = @()
    foreach ($item in $patterns) {
        if ($content -match $item.Pattern) {
            $results += [PSCustomObject]@{
                Check    = 'Credentials'
                Severity = [Severity]::Warning
                Message  = $item.Label
            }
        }
    }

    if ($results.Count -eq 0) {
        return [PSCustomObject]@{ Check = 'Credentials'; Severity = [Severity]::Pass; Message = 'No exposed credential patterns detected' }
    }
    return $results
}

# ══════════════════════════════════════════════════════════════════════════════
#  Aggregation & reporting
# ══════════════════════════════════════════════════════════════════════════════

function Get-AllScripts {
    param([string]$RootPath, [string]$CategoryFilter)

    $allScripts = Get-ChildItem -Path $RootPath -Filter '*.ps1' -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $skip = $false
            foreach ($d in $SkipDirs) {
                if ($_.FullName -match [regex]::Escape([IO.Path]::DirectorySeparatorChar + $d + [IO.Path]::DirectorySeparatorChar) -or
                    $_.FullName -match [regex]::Escape([IO.Path]::DirectorySeparatorChar + $d + '$')) {
                    $skip = $true; break
                }
            }
            -not $skip
        }

    if ($CategoryFilter) {
        $allScripts = $allScripts | Where-Object { $_.FullName -match [regex]::Escape($CategoryFilter) }
    }

    return $allScripts | Sort-Object FullName
}

function Invoke-Validation {
    param([System.IO.FileInfo[]]$Scripts)

    $report = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach ($script in $Scripts) {
        $rel      = $script.FullName.Replace($Path, '').TrimStart('/\')
        $findings = @()
        $findings += Test-Syntax           -FilePath $script.FullName
        $findings += Test-RequiresVersion  -FilePath $script.FullName
        $findings += Test-RequiredModules  -FilePath $script.FullName
        $findings += Test-HardcodedPaths   -FilePath $script.FullName
        $findings += Test-DangerousCmdlets -FilePath $script.FullName
        $findings += Test-ErrorHandling    -FilePath $script.FullName
        $findings += Test-CredentialExposure -FilePath $script.FullName

        # Overall status = highest severity
        $overallSev = $findings | Measure-Object -Property Severity -Maximum | Select-Object -ExpandProperty Maximum
        $overallSev = [Severity]$overallSev

        $report.Add([PSCustomObject]@{
            Script   = $rel
            FullPath = $script.FullName
            Status   = $overallSev.ToString()
            Findings = $findings
        })
    }
    return $report
}

function Write-Report {
    param([System.Collections.Generic.List[PSCustomObject]]$Report)

    $total   = $Report.Count
    $passing = ($Report | Where-Object Status -eq 'Pass').Count
    $infos   = ($Report | Where-Object Status -eq 'Info').Count
    $warns   = ($Report | Where-Object Status -eq 'Warning').Count
    $errors  = ($Report | Where-Object Status -eq 'Error').Count

    # ── Banner ────────────────────────────────────────────────────────────────
    Clear-Host
    Write-Host ''
    Write-Host '  ╔══════════════════════════════════════════════════════════════╗' -ForegroundColor $C.Title
    Write-Host '  ║         VALIDATE-SCRIPTS  –  Compatibility Report            ║' -ForegroundColor $C.Title
    Write-Host '  ║              https://jasr.me/ps1  •  jasrasr                 ║' -ForegroundColor $C.Dim
    Write-Host '  ╚══════════════════════════════════════════════════════════════╝' -ForegroundColor $C.Title
    Write-Host ''
    Write-Host ("  PowerShell Version : {0}" -f $CurrentPSVersion) -ForegroundColor $C.Info
    Write-Host ("  Scan Path          : {0}" -f $Path) -ForegroundColor $C.Info
    Write-Host ("  Scripts Scanned    : {0}" -f $total) -ForegroundColor $C.Info
    Write-Host ''

    # ── Per-script results ────────────────────────────────────────────────────
    foreach ($entry in $Report) {

        $shouldShow = switch ($entry.Status) {
            'Error'   { $true }
            'Warning' { $true }
            'Info'    { $IncludePassing }
            'Pass'    { $IncludePassing }
            default   { $false }
        }
        if (-not $shouldShow) { continue }

        $statusColour = switch ($entry.Status) {
            'Pass'    { $C.Pass }
            'Info'    { $C.Info }
            'Warning' { $C.Warn }
            'Error'   { $C.Fail }
        }

        Write-Host ("  ── {0}" -f $entry.Script) -ForegroundColor $C.Header
        Write-Host ("     Status: [{0}]" -f $entry.Status.ToUpper()) -ForegroundColor $statusColour

        foreach ($f in $entry.Findings) {
            if ($f.Severity -eq [Severity]::Pass -and -not $IncludePassing) { continue }
            $fc = switch ($f.Severity) {
                ([Severity]::Pass)    { $C.Dim }
                ([Severity]::Info)    { $C.Info }
                ([Severity]::Warning) { $C.Warn }
                ([Severity]::Error)   { $C.Fail }
            }
            $prefix = switch ($f.Severity) {
                ([Severity]::Pass)    { '  ✓' }
                ([Severity]::Info)    { '  ℹ' }
                ([Severity]::Warning) { '  ⚠' }
                ([Severity]::Error)   { '  ✗' }
            }
            Write-Host ("     {0} [{1,-16}] {2}" -f $prefix, $f.Check, $f.Message) -ForegroundColor $fc
        }
        Write-Host ''
    }

    # ── Summary ───────────────────────────────────────────────────────────────
    Write-Host '  ══════════════════════════════════════════════════════════════' -ForegroundColor $C.Dim
    Write-Host '  SUMMARY' -ForegroundColor $C.Header
    Write-Host ("    Total scripts : {0}" -f $total)   -ForegroundColor $C.Info
    Write-Host ("    ✓ Pass        : {0}" -f $passing) -ForegroundColor $C.Pass
    Write-Host ("    ℹ Info        : {0}" -f $infos)   -ForegroundColor $C.Info
    Write-Host ("    ⚠ Warnings    : {0}" -f $warns)   -ForegroundColor $C.Warn
    Write-Host ("    ✗ Errors      : {0}" -f $errors)  -ForegroundColor $C.Fail

    if (-not $IncludePassing -and ($passing + $infos) -gt 0) {
        Write-Host ''
        Write-Host ("    (Run with -IncludePassing to see all {0} clean scripts)" -f ($passing + $infos)) -ForegroundColor $C.Dim
    }
    Write-Host ''
}

function Export-CsvReport {
    param([System.Collections.Generic.List[PSCustomObject]]$Report, [string]$CsvPath)

    $rows = foreach ($entry in $Report) {
        foreach ($f in $entry.Findings) {
            [PSCustomObject]@{
                Script   = $entry.Script
                Status   = $entry.Status
                Check    = $f.Check
                Severity = $f.Severity.ToString()
                Message  = $f.Message
                FullPath = $entry.FullPath
            }
        }
    }

    try {
        $rows | Export-Csv -Path $CsvPath -NoTypeInformation -Force -Encoding UTF8
        Write-Host ("  CSV report saved to: {0}" -f $CsvPath) -ForegroundColor $C.Pass
    } catch {
        Write-Host ("  Could not save CSV: {0}" -f $_.Exception.Message) -ForegroundColor $C.Fail
    }
}

# ══════════════════════════════════════════════════════════════════════════════
#  Entry point
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ''
Write-Host '  Scanning scripts, please wait...' -ForegroundColor $C.Info

$scripts = Get-AllScripts -RootPath $Path -CategoryFilter $Category

if ($scripts.Count -eq 0) {
    Write-Host '  No .ps1 scripts found in the specified path.' -ForegroundColor $C.Warn
    exit 0
}

Write-Host ("  Found {0} scripts. Running checks..." -f $scripts.Count) -ForegroundColor $C.Info
$report = Invoke-Validation -Scripts $scripts

Write-Report -Report $report

if ($ExportCsv) {
    Export-CsvReport -Report $report -CsvPath $ExportCsv
}

Write-Host '  Press Enter to return...' -ForegroundColor $C.Dim
$null = Read-Host
