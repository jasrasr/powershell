# Revision : 1.0
# Description : Parse icacls text into CSV, bump MIDDOUGH\* with leading comma
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-06
# Modified Date : 2025-10-06

param(
    [Parameter(Mandatory=$true)]
    [string]$InputPath,

    [string]$OutFolder = 'C:\temp\powershell-exports\'
)

# Ensure output folder exists
New-Item -ItemType Directory -Path $OutFolder -Force | Out-Null

$dt = (Get-Date).ToString('yyyyMMdd-HHmmss')
$outCsv = Join-Path $OutFolder "icacls-parsed-$dt.csv"

Write-Host "Input file : $InputPath" -ForegroundColor Yellow
Write-Host "Output CSV : $outCsv" -ForegroundColor Yellow

function Parse-Ace {
    param([string]$Line,[string]$Path)

    if ($Line -notmatch "^(?<id>[^:]+):(?<rest>.+)$") { return $null }

    $id   = ($Matches.id).Trim()
    $rest = ($Matches.rest).Trim()

    # Bump MIDDOUGH\* into next column for CSV
    if ($id -like 'MIDDOUGH\*') { $id = ",$id" }

    $tokens = [System.Text.RegularExpressions.Regex]::Matches($rest, "\((.*?)\)") |
              ForEach-Object { $_.Groups[1].Value }

    $inherited = $false
    $flags = [System.Collections.Generic.List[string]]::new()
    $perms = [System.Collections.Generic.List[string]]::new()

    foreach ($t in $tokens) {
        switch -Regex ($t) {
            '^I$'   { $inherited = $true; continue }
            '^(OI|CI|IO|NP)$' { $flags.Add($t); continue }
            default { $perms.Add($t); continue }
        }
    }

    $permExpanded = @()
    foreach ($p in $perms) {
        $permExpanded += ($p -split '\s*,\s*')
    }

    [pscustomobject]@{
        Path        = $Path
        Identity    = $id
        Inherited   = $inherited
        Flags       = ($flags -join ',')
        Permissions = ($permExpanded -join ',')
    }
}

# Read file and parse
$lines = Get-Content -LiteralPath $InputPath
$currentPath = $null
$records = @()

foreach ($line in $lines) {
    $line = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    if ($line -notmatch ":") {
        # Path line
        $currentPath = $line
        continue
    }

    $rec = Parse-Ace -Line $line -Path $currentPath
    if ($rec) { $records += $rec }
}

$records | Export-Csv -Path $outCsv -NoTypeInformation -Encoding UTF8
Write-Host "Done. CSV written to $outCsv" -ForegroundColor Green
