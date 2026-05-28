# Filename: Search-FileContent.ps1
# Revision : 1.3.0
# Description : Recursively searches file contents for matching text across plain-text files and Office .xlsx/.docx documents, with optional regex, case-sensitive, and multi-threaded execution. Emits a Snippet column with match context, returns paths relative to -RootPath, adds a MatchCount column, and (with -AllMatches) emits one row per occurrence. Auto-logs results to a timestamped CSV under $psexports.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-28
# Modified Date : 2026-05-28
# Changelog :
# 1.3.0 add MatchCount column showing total occurrences per file; add -AllMatches switch to emit one row per occurrence (with MatchIndex column)
# 1.2.0 emit Path relative to -RootPath by default; add -AbsolutePath switch to opt back into full paths
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

    [switch]$NoLog,

    [switch]$AbsolutePath,

    [switch]$AllMatches
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-MatchInfo {
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
        return
    }

    $textLength = $InputText.Length

    if ($UseRegex) {
        $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
        if (-not $MatchCase) {
            $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        }

        $rxMatches = [System.Text.RegularExpressions.Regex]::Matches($InputText, $Needle, $options)
        foreach ($m in $rxMatches) {
            $start = $m.Index
            $len = $m.Length
            $snippetStart = [Math]::Max(0, $start - $Context)
            $snippetEnd = [Math]::Min($textLength, $start + $len + $Context)
            $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)
            $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()
            if ($snippetStart -gt 0) { $snippet = "...$snippet" }
            if ($snippetEnd -lt $textLength) { $snippet = "$snippet..." }

            [pscustomobject]@{
                Index   = $start
                Length  = $len
                Snippet = $snippet
            }
        }
    }
    else {
        $comparison = if ($MatchCase) {
            [System.StringComparison]::Ordinal
        }
        else {
            [System.StringComparison]::OrdinalIgnoreCase
        }

        $needleLength = $Needle.Length
        $offset = 0

        while ($offset -le $textLength) {
            $idx = $InputText.IndexOf($Needle, $offset, $comparison)
            if ($idx -lt 0) { break }

            $snippetStart = [Math]::Max(0, $idx - $Context)
            $snippetEnd = [Math]::Min($textLength, $idx + $needleLength + $Context)
            $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)
            $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()
            if ($snippetStart -gt 0) { $snippet = "...$snippet" }
            if ($snippetEnd -lt $textLength) { $snippet = "$snippet..." }

            [pscustomobject]@{
                Index   = $idx
                Length  = $needleLength
                Snippet = $snippet
            }

            $offset = $idx + [Math]::Max($needleLength, 1)
        }
    }
}

function Get-ZipEntryMatches {
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

            Get-MatchInfo -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
        }
        catch {
            continue
        }
    }
}

function Get-FileContentMatches {
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
                return
            }

            try {
                Get-ZipEntryMatches -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
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
                return
            }

            try {
                Get-ZipEntryMatches -Archive $archive -EntryPatterns @(
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
                return
            }

            try {
                $content = [System.IO.File]::ReadAllText($Path)
            }
            catch {
                return
            }

            Get-MatchInfo -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
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
$dirSep = [System.IO.Path]::DirectorySeparatorChar
$altSep = [System.IO.Path]::AltDirectorySeparatorChar
$relativeBasePrefix = $resolvedRoot.TrimEnd($dirSep, $altSep) + $dirSep
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
        function Get-MatchInfo {
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
                return
            }

            $textLength = $InputText.Length

            if ($UseRegex) {
                $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
                if (-not $MatchCase) {
                    $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                }

                $rxMatches = [System.Text.RegularExpressions.Regex]::Matches($InputText, $Needle, $options)
                foreach ($m in $rxMatches) {
                    $start = $m.Index
                    $len = $m.Length
                    $snippetStart = [Math]::Max(0, $start - $Context)
                    $snippetEnd = [Math]::Min($textLength, $start + $len + $Context)
                    $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)
                    $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()
                    if ($snippetStart -gt 0) { $snippet = "...$snippet" }
                    if ($snippetEnd -lt $textLength) { $snippet = "$snippet..." }

                    [pscustomobject]@{
                        Index   = $start
                        Length  = $len
                        Snippet = $snippet
                    }
                }
            }
            else {
                $comparison = if ($MatchCase) {
                    [System.StringComparison]::Ordinal
                }
                else {
                    [System.StringComparison]::OrdinalIgnoreCase
                }

                $needleLength = $Needle.Length
                $offset = 0

                while ($offset -le $textLength) {
                    $idx = $InputText.IndexOf($Needle, $offset, $comparison)
                    if ($idx -lt 0) { break }

                    $snippetStart = [Math]::Max(0, $idx - $Context)
                    $snippetEnd = [Math]::Min($textLength, $idx + $needleLength + $Context)
                    $snippet = $InputText.Substring($snippetStart, $snippetEnd - $snippetStart)
                    $snippet = [regex]::Replace($snippet, '\s+', ' ').Trim()
                    if ($snippetStart -gt 0) { $snippet = "...$snippet" }
                    if ($snippetEnd -lt $textLength) { $snippet = "$snippet..." }

                    [pscustomobject]@{
                        Index   = $idx
                        Length  = $needleLength
                        Snippet = $snippet
                    }

                    $offset = $idx + [Math]::Max($needleLength, 1)
                }
            }
        }

        function Get-ZipEntryMatches {
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

                    Get-MatchInfo -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                }
                catch {
                    continue
                }
            }
        }

        function Get-FileContentMatches {
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
                        return
                    }

                    try {
                        Get-ZipEntryMatches -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
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
                        return
                    }

                    try {
                        Get-ZipEntryMatches -Archive $archive -EntryPatterns @(
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
                        return
                    }

                    Get-MatchInfo -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase -Context $Context
                }
            }
        }

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        $fileMatches = @(Get-FileContentMatches -Path $_ -Needle $using:SearchText -UseRegex:$using:Regex -MatchCase:$using:CaseSensitive -PlainTextExtensions $using:plainTextExtensionsLower -Context $using:SnippetContext)
        if ($fileMatches.Count -gt 0) {
            $displayPath = if ($using:AbsolutePath) {
                $_
            }
            else {
                $basePrefix = $using:relativeBasePrefix
                if ($_.StartsWith($basePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $_.Substring($basePrefix.Length)
                }
                else {
                    $_
                }
            }

            $ext = [System.IO.Path]::GetExtension($_).ToLowerInvariant()
            $sizeKB = [math]::Round(((Get-Item -LiteralPath $_).Length / 1KB), 2)

            if ($using:AllMatches) {
                for ($i = 0; $i -lt $fileMatches.Count; $i++) {
                    [pscustomobject]@{
                        Path       = $displayPath
                        Extension  = $ext
                        SizeKB     = $sizeKB
                        MatchCount = $fileMatches.Count
                        MatchIndex = $i + 1
                        Snippet    = $fileMatches[$i].Snippet
                    }
                }
            }
            else {
                [pscustomobject]@{
                    Path       = $displayPath
                    Extension  = $ext
                    SizeKB     = $sizeKB
                    MatchCount = $fileMatches.Count
                    Snippet    = $fileMatches[0].Snippet
                }
            }
        }
    } -ThrottleLimit $Threads
}
else {
    $results = foreach ($file in $files) {
        $fileMatches = @(Get-FileContentMatches -Path $file -Needle $SearchText -UseRegex:$Regex -MatchCase:$CaseSensitive -PlainTextExtensions $plainTextExtensionsLower -Context $SnippetContext)
        if ($fileMatches.Count -gt 0) {
            $displayPath = if ($AbsolutePath) {
                $file
            }
            elseif ($file.StartsWith($relativeBasePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                $file.Substring($relativeBasePrefix.Length)
            }
            else {
                $file
            }

            $ext = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
            $sizeKB = [math]::Round(((Get-Item -LiteralPath $file).Length / 1KB), 2)

            if ($AllMatches) {
                for ($i = 0; $i -lt $fileMatches.Count; $i++) {
                    [pscustomobject]@{
                        Path       = $displayPath
                        Extension  = $ext
                        SizeKB     = $sizeKB
                        MatchCount = $fileMatches.Count
                        MatchIndex = $i + 1
                        Snippet    = $fileMatches[$i].Snippet
                    }
                }
            }
            else {
                [pscustomobject]@{
                    Path       = $displayPath
                    Extension  = $ext
                    SizeKB     = $sizeKB
                    MatchCount = $fileMatches.Count
                    Snippet    = $fileMatches[0].Snippet
                }
            }
        }
    }
}

$sortProps = if ($AllMatches) { @('Path', 'MatchIndex') } else { @('Path') }
$sorted = @($results | Sort-Object $sortProps)

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
#   .\Search-FileContent.ps1 -SearchText "needle" -AbsolutePath
#   .\Search-FileContent.ps1 -SearchText "needle" -AllMatches
