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

    [int]$Threads = 8
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-StringMatch {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$InputText,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase
    )

    if ($UseRegex) {
        $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
        if (-not $MatchCase) {
            $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        }

        return [System.Text.RegularExpressions.Regex]::IsMatch($InputText, $Needle, $options)
    }

    $comparison = if ($MatchCase) {
        [System.StringComparison]::Ordinal
    }
    else {
        [System.StringComparison]::OrdinalIgnoreCase
    }

    return $InputText.IndexOf($Needle, $comparison) -ge 0
}

function Find-ZipEntryText {
    param(
        [Parameter(Mandatory)]
        [System.IO.Compression.ZipArchive]$Archive,

        [Parameter(Mandatory)]
        [string[]]$EntryPatterns,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase
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

            if (Test-StringMatch -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase) {
                return $true
            }
        }
        catch {
            continue
        }
    }

    return $false
}

function Test-FileContentMatch {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Needle,

        [switch]$UseRegex,

        [switch]$MatchCase,

        [string[]]$PlainTextExtensions
    )

    $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

    switch ($extension) {
        '.xlsx' {
            try {
                $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
            }
            catch {
                return $false
            }

            try {
                return Find-ZipEntryText -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
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
                return $false
            }

            try {
                return Find-ZipEntryText -Archive $archive -EntryPatterns @(
                    'word/document.xml',
                    'word/header*.xml',
                    'word/footer*.xml',
                    'word/footnotes.xml',
                    'word/endnotes.xml',
                    'word/comments.xml'
                ) -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
            }
            finally {
                $archive.Dispose()
            }
        }

        default {
            if ($PlainTextExtensions -notcontains $extension) {
                return $false
            }

            try {
                $content = [System.IO.File]::ReadAllText($Path)
            }
            catch {
                return $false
            }

            return Test-StringMatch -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
        }
    }
}

if (-not (Test-Path -LiteralPath $RootPath -PathType Container)) {
    throw "RootPath does not exist or is not a directory: $RootPath"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

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
        function Test-StringMatch {
            param(
                [Parameter(Mandatory)]
                [AllowEmptyString()]
                [string]$InputText,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase
            )

            if ($UseRegex) {
                $options = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
                if (-not $MatchCase) {
                    $options = $options -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
                }

                return [System.Text.RegularExpressions.Regex]::IsMatch($InputText, $Needle, $options)
            }

            $comparison = if ($MatchCase) {
                [System.StringComparison]::Ordinal
            }
            else {
                [System.StringComparison]::OrdinalIgnoreCase
            }

            return $InputText.IndexOf($Needle, $comparison) -ge 0
        }

        function Find-ZipEntryText {
            param(
                [Parameter(Mandatory)]
                [System.IO.Compression.ZipArchive]$Archive,
                [Parameter(Mandatory)]
                [string[]]$EntryPatterns,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase
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

                    if (Test-StringMatch -InputText $searchableText -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase) {
                        return $true
                    }
                }
                catch {
                    continue
                }
            }

            return $false
        }

        function Test-FileContentMatch {
            param(
                [Parameter(Mandatory)]
                [string]$Path,
                [Parameter(Mandatory)]
                [string]$Needle,
                [switch]$UseRegex,
                [switch]$MatchCase,
                [string[]]$PlainTextExtensions
            )

            $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

            switch ($extension) {
                '.xlsx' {
                    try {
                        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
                    }
                    catch {
                        return $false
                    }

                    try {
                        return Find-ZipEntryText -Archive $archive -EntryPatterns @('xl/sharedStrings.xml', 'xl/worksheets/*.xml') -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
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
                        return $false
                    }

                    try {
                        return Find-ZipEntryText -Archive $archive -EntryPatterns @(
                            'word/document.xml',
                            'word/header*.xml',
                            'word/footer*.xml',
                            'word/footnotes.xml',
                            'word/endnotes.xml',
                            'word/comments.xml'
                        ) -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
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
                        return $false
                    }

                    return Test-StringMatch -InputText $content -Needle $Needle -UseRegex:$UseRegex -MatchCase:$MatchCase
                }
            }
        }

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        if (Test-FileContentMatch -Path $_ -Needle $using:SearchText -UseRegex:$using:Regex -MatchCase:$using:CaseSensitive -PlainTextExtensions $using:plainTextExtensionsLower) {
            [pscustomobject]@{
                Path      = $_
                Extension = [System.IO.Path]::GetExtension($_).ToLowerInvariant()
                SizeKB    = [math]::Round(((Get-Item -LiteralPath $_).Length / 1KB), 2)
            }
        }
    } -ThrottleLimit $Threads
}
else {
    $results = foreach ($file in $files) {
        if (Test-FileContentMatch -Path $file -Needle $SearchText -UseRegex:$Regex -MatchCase:$CaseSensitive -PlainTextExtensions $plainTextExtensionsLower) {
            [pscustomobject]@{
                Path      = $file
                Extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
                SizeKB    = [math]::Round(((Get-Item -LiteralPath $file).Length / 1KB), 2)
            }
        }
    }
}

$results | Sort-Object Path
