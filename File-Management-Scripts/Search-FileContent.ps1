# Filename: Search-FileContent.ps1
# Revision : 1.1.0
# Description : Recursively searches file contents for matching text across plain-text files and Office .xlsx/.docx documents, with optional regex, case-sensitive, and multi-threaded execution. Emits a Snippet column with match context and auto-logs results to a timestamped CSV under $psexports.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-28
# Modified Date : 2026-05-28
# Changelog :
# 1.1.0 add Snippet column showing matched-text context; auto-log results to $env:psexports (or default powershell-exports folder) with timestamped CSV; add -SnippetContext, -LogFile, -NoLog parameters
# 1.0.0 initial release

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [Alias('Pattern')]
    [string]$SearchText,

    [string]$RootPath = $(if ($env:onedrivepath) { $env:onedrivepath } elseif ($env:OneDrive) { $env:OneDrive } else { (Get-Location).Path }),

    [switch]$Regex,

    [switch]$CaseSensitive,

    [string[]]$Include = @('*'),

    [string[]]$Exclude = @(),

    [string[]]$TextExtensions = @(
        '.txt', '.csv', '.log', '.md', '.json', '.xml', '.yml', '.yaml',
        '.ini', '.cfg', '.ps1', '.psm1', '.psd1', '.bat', '.cmd',
        '.js', '.ts', '.jsx', '.tsx', '.css', '.scss', '.html', '.htm',
        '.sql', '.psv', '.tsv'
    ),

    [switch]$NoRecurse,

    [int]$Threads = 8,

    [int]$SnippetContext = 80,

    [string]$LogFile,

    [switch]$NoLog
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-MatchSnippet {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$InputText,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase,

        [int]$Context = 80
    )

    if ([string]::IsNullOrEmpty($InputText)) {
        return $null
    }

    $matchStart = -1
    $matchLength = 0

    if ($UseRegex) {
        $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
        if (-not $MatchCase) {
            $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        }

        $m = [System.Text.RegularExpressions.Regex]::Match($InputText, $Needle, $options)
        if ($m.Success) {
            $matchStart = $m.Index
            $matchLength = $m.Length
        }
    }
    else {
        $comparison = if ($MatchCase) {
            [System.StringComparison]::Ordinal
        }
        else {
            [System.StringComparison]::OrdinalIgnoreCase
        }

        $matchStart = $InputText.IndexOf($Needle, $comparison)
        if ($matchStart -ge 0) {
            $matchLength = $Needle.Length
        }
    }

    if ($matchStart -lt 0) {
        return $null
    }

    $snippetStart = [Math]::Max(0, $matchStart - $Context)
    $snippetEnd = [Math]::Min($InputText.Length, $matchStart + $matchLength + $Context)
    $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)

    $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()

    if ($snippetStart -gt 0) {
        $snippet = "...$snippet"
    }
    if ($snippetEnd -lt $InputText.Length) {
        $snippet = "$snippet..."
    }

    return $snippet
}

function Get-ZipEntrySnippet {
    param(
        [Parameter(Mandatory)]
        [System.IO.Compression.ZipArchive]$Archive,

        [Parameter(Mandatory)]
        [string[]]$EntryPatterns,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase,

        [int]$Context = 80
    )

    foreach ($entry in $Archive.Entries) {
        $name = $entry.FullName
        $shouldRead = $false

        foreach ($entryPattern in $EntryPatterns) {
            if ($name -like $entryPattern) {
                $shouldRead = $true
                break
            }
        }

        if (-not $shouldRead) {
            continue
        }

        try {
            $stream = $entry.Open()
            try {
                $reader = [System.IO.StreamReader]::new($stream)
                try {
                    $xmlText = $reader.ReadToEnd()
                }
                finally {
                    $reader.Dispose()
                }
            }
            finally {
                $stream.Dispose()
            }

            if ([string]::IsNullOrWhiteSpace($xmlText)) {
                continue
            }

            $doc = [System.Xml.XmlDocument]::new()
            $doc.XmlResolver = $null
            $doc.LoadXml($xmlText)
            $searchableText = if ($doc.DocumentElement) { $doc.DocumentElement.InnerText } else { '' }

            $snippet = Get-MatchSnippet -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
            if ($snippet) {
                return $snippet
            }
        }
        catch {
            continue
        }
    }

    return $null
}

function Get-FileContentSnippet {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase,

        [string[]]$PlainTextExtensions,

        [int]$Context = 80
    )

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

    switch ($extension) {
        '.xlsx' {
            try {
                $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
            }
            catch {
                return $null
            }

            try {
                return Get-ZipEntrySnippet -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
            }
            finally {
                $archive.Dispose()
            }
        }

        '.docx' {
            try {
                $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
            }
            catch {
                return $null
            }

            try {
                return Get-ZipEntrySnippet -Archive $archive -EntryPatterns @(
                    'word/document.xml',
                    'word/header*.xml',
                    'word/footer*.xml',
                    'word/footnotes.xml',
                    'word/endnotes.xml',
                    'word/comments.xml'
                ) -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
            }
            finally {
                $archive.Dispose()
            }
        }

        default {
            if ($PlainTextExtensions -notcontains $extension) {
                return $null
            }

            try {
                $content = [System.IO.File]::ReadAllText($Path)
            }
            catch {
                return $null
            }

            return Get-MatchSnippet -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
        }
    }
}

if (-not (Test-Path -LiteralPath $RootPath -PathType Container)) {
    throw "RootPath does not exist or is not a directory: $RootPath"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not $NoLog -and -not $LogFile) {
    $exportRoot = if ($env:psexports) {
        $env:psexports
    }
    elseif (Test-Path -LiteralPath 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports' -PathType Container) {
        'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\powershell-exports'
    }
    else {
        Join-Path $env:USERPROFILE 'powershell-exports'
    }

    if (-not (Test-Path -LiteralPath $exportRoot -PathType Container)) {
        Write-Warning "Export directory not found: $exportRoot - log skipped. Use -LogFile <path> or -NoLog to suppress."
        $NoLog = $true
    }
    else {
        $LogFile = Join-Path $exportRoot ("Search-FileContent_{0}.csv" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
    }
}

$resolvedRoot = (Resolve-Path -LiteralPath $RootPath).Path
$searchOption = if ($NoRecurse) { 'TopDirectoryOnly' } else { 'AllDirectories' }
$plainTextExtensionsLower = $TextExtensions.ForEach({ $_.ToLowerInvariant() })

$files = [System.IO.Directory]::EnumerateFiles($resolvedRoot, '*', $searchOption) |
    Where-Object {
        $name = [System.IO.Path]::GetFileName($_)
        $includeMatch = $false

        foreach ($pattern in $Include) {
            if ($name -like $pattern) {
                $includeMatch = $true
                break
            }
        }

        if (-not $includeMatch) {
            return $false
        }

        foreach ($pattern in $Exclude) {
            if ($name -like $pattern) {
                return $false
            }
        }

        $extension = [System.IO.Path]::GetExtension($_).ToLowerInvariant()
        return $extension -in @('.xlsx', '.docx') -or $extension -in $plainTextExtensionsLower
    }

if ($PSVersionTable.PSVersion.Major -ge 7 -and $Threads -gt 1) {
    $results = $files | ForEach-Object -Parallel {
        function Get-MatchSnippet {
            param(
                [Parameter(Mandatory)]
                [AllowEmptyString()]
                [string]$InputText,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase,
                [int]$Context = 80
            )

            if ([string]::IsNullOrEmpty($InputText)) {
                return $null
            }

            $matchStart = -1
            $matchLength = 0

            if ($UseRegex) {
                $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
                if (-not $MatchCase) {
                    $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                }

                $m = [System.Text.RegularExpressions.Regex]::Match($InputText, $Needle, $options)
                if ($m.Success) {
                    $matchStart = $m.Index
                    $matchLength = $m.Length
                }
            }
            else {
                $comparison = if ($MatchCase) {
                    [System.StringComparison]::Ordinal
                }
                else {
                    [System.StringComparison]::OrdinalIgnoreCase
                }

                $matchStart = $InputText.IndexOf($Needle, $comparison)
                if ($matchStart -ge 0) {
                    $matchLength = $Needle.Length
                }
            }

            if ($matchStart -lt 0) {
                return $null
            }

            $snippetStart = [Math]::Max(0, $matchStart - $Context)
            $snippetEnd = [Math]::Min($InputText.Length, $matchStart + $matchLength + $Context)
            $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)

            $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()

            if ($snippetStart -gt 0) {
                $snippet = "...$snippet"
            }
            if ($snippetEnd -lt $InputText.Length) {
                $snippet = "$snippet..."
            }

            return $snippet
        }

        function Get-ZipEntrySnippet {
            param(
                [Parameter(Mandatory)]
                [System.IO.Compression.ZipArchive]$Archive,
                [Parameter(Mandatory)]
                [string[]]$EntryPatterns,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase,
                [int]$Context = 80
            )

            foreach ($entry in $Archive.Entries) {
                $name = $entry.FullName
                $shouldRead = $false

                foreach ($entryPattern in $EntryPatterns) {
                    if ($name -like $entryPattern) {
                        $shouldRead = $true
                        break
                    }
                }

                if (-not $shouldRead) {
                    continue
                }

                try {
                    $stream = $entry.Open()
                    try {
                        $reader = [System.IO.StreamReader]::new($stream)
                        try {
                            $xmlText = $reader.ReadToEnd()
                        }
                        finally {
                            $reader.Dispose()
                        }
                    }
                    finally {
                        $stream.Dispose()
                    }

                    if ([string]::IsNullOrWhiteSpace($xmlText)) {
                        continue
                    }

                    $doc = [System.Xml.XmlDocument]::new()
                    $doc.XmlResolver = $null
                    $doc.LoadXml($xmlText)
                    $searchableText = if ($doc.DocumentElement) { $doc.DocumentElement.InnerText } else { '' }

                    $snippet = Get-MatchSnippet -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                    if ($snippet) {
                        return $snippet
                    }
                }
                catch {
                    continue
                }
            }

            return $null
        }

        function Get-FileContentSnippet {
            param(
                [Parameter(Mandatory)]
                [string]$Path,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase,
                [string[]]$PlainTextExtensions,
                [int]$Context = 80
            )

            $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

            switch ($extension) {
                '.xlsx' {
                    try {
                        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
                    }
                    catch {
                        return $null
                    }

                    try {
                        return Get-ZipEntrySnippet -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                    }
                    finally {
                        $archive.Dispose()
                    }
                }

                '.docx' {
                    try {
                        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
                    }
                    catch {
                        return $null
                    }

                    try {
                        return Get-ZipEntrySnippet -Archive $archive -EntryPatterns @(
                            'word/document.xml',
                            'word/header*.xml',
                            'word/footer*.xml',
                            'word/footnotes.xml',
                            'word/endnotes.xml',
                            'word/comments.xml'
                        ) -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                    }
                    finally {
                        $archive.Dispose()
                    }
                }

                default {
                    try {
                        $content = [System.IO.File]::ReadAllText($Path)
                    }
                    catch {
                        return $null
                    }

                    return Get-MatchSnippet -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                }
            }
        }

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        $snippet = Get-FileContentSnippet -Path $_ -Needle $using:SearchText -UseRegex:$using:Regex -MatchCase:$using:CaseSensitive -PlainTextExtensions $using:plainTextExtensionsLower -Context $using:SnippetContext
        if ($snippet) {
            [pscustomobject]@{
                Path      = $_
                Extension = [System.IO.Path]::GetExtension($_).ToLowerInvariant()
                SizeKB    = [math]::Round(((Get-Item -LiteralPath $_).Length / 1KB), 2)
                Snippet   = $snippet
            }
        }
    } -ThrottleLimit $Threads
}
else {
    $results = foreach ($file in $files) {
        $snippet = Get-FileContentSnippet -Path $file -Needle $SearchText -UseRegex:$Regex -MatchCase:$CaseSensitive -PlainTextExtensions $plainTextExtensionsLower -Context $SnippetContext
        if ($snippet) {
            [pscustomobject]@{
                Path      = $file
                Extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
                SizeKB    = [math]::Round(((Get-Item -LiteralPath $file).Length / 1KB), 2)
                Snippet   = $snippet
            }
        }
    }
}

$sorted = @($results | Sort-Object Path)

if (-not $NoLog -and $LogFile) {
    if ($sorted.Count -gt 0) {
        try {
            $sorted | Export-Csv -LiteralPath $LogFile -NoTypeInformation -Encoding UTF8
            Write-Host "Results logged to: $LogFile" -ForegroundColor Cyan
        }
        catch {
            Write-Warning "Failed to write log file '$LogFile': $($_.Exception.Message)"
        }
    }
    else {
        Write-Host "No matches found - log file not written." -ForegroundColor Yellow
    }
}

$sorted

# Example Usage:
#   .\Search-FileContent.ps1 -SearchText "API_KEY"
#   .\Search-FileContent.ps1 -SearchText "password" -RootPath "C:\Logs"
#   .\Search-FileContent.ps1 -SearchText "error\s+\d+" -Regex
#   .\Search-FileContent.ps1 -SearchText "TODO" -CaseSensitive
#   .\Search-FileContent.ps1 -SearchText "invoice" -Include *.xlsx,*.docx
#   .\Search-FileContent.ps1 -SearchText "secret" -Exclude *.log,*.tmp
#   .\Search-FileContent.ps1 -SearchText "config" -TextExtensions .ps1,.psm1
#   .\Search-FileContent.ps1 -SearchText "Smith" -NoRecurse
#   .\Search-FileContent.ps1 -SearchText "internal" -Threads 16
#   .\Search-FileContent.ps1 -SearchText "needle" -SnippetContext 150
#   .\Search-FileContent.ps1 -SearchText "needle" -LogFile "C:\temp\hits.csv"
#   .\Search-FileContent.ps1 -SearchText "needle" -NoLog
