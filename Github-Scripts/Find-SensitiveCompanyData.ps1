<#
.SYNOPSIS
    Scans company documents for likely sensitive data before file migration.

.DESCRIPTION
    Scans PPT, PPTX, DOC, DOCX, XLS, XLSX, PDF, CSV, TXT, JSON, XML, HTML, LOG, MD, and similar text files
    for likely PHI, PII, payroll, credential, financial, and HR-sensitive data.

.NOTES
    Script Name   : Find-SensitiveCompanyData.ps1
    Revision      : 1.0.0
    Author        : Jason Lamb with help from ChatGPT
    Created Date  : 2026-05-29
    Modified Date : 2026-05-29

.REVISION HISTORY
    1.0.0 - Initial PowerShell project version.
          - Added function-based structure.
          - Added timestamped CSV and log output.
          - Added masked sensitive match reporting.
          - Added optional ACL reporting for matched files.
          - Added OpenXML extraction for DOCX, PPTX, XLSX without requiring Office.
          - Added optional PDF text extraction using pdftotext.exe.
          - Added commented usage examples.
#>

function Find-SensitiveCompanyData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath,

        [string]$OutputFolder = 'C:\temp\powershell-exports',

        [string]$PdfToTextPath = '',

        [switch]$IncludeAclReport,

        [switch]$IncludeHash,

        [switch]$NoRecurse,

        [switch]$PauseAtEnd
    )

    $scriptRevision = '1.0.0'
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

    if (-not (Test-Path -Path $OutputFolder)) {
        New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
    }

    $findingCsv = Join-Path $OutputFolder "sensitive-data-findings-$timestamp.csv"
    $aclCsv = Join-Path $OutputFolder "sensitive-data-acl-report-$timestamp.csv"
    $logFile = Join-Path $OutputFolder "sensitive-data-scan-$timestamp.log"

    function Write-ScanLog {
        param(
            [string]$Message,
            [string]$Level = 'INFO'
        )

        $line = "[{0}] [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
        Write-Host $line
        Add-Content -Path $logFile -Value $line
    }

    function Mask-Value {
        param([string]$Value)

        if ([string]::IsNullOrWhiteSpace($Value)) {
            return ''
        }

        $cleanValue = $Value.Trim()

        if ($cleanValue.Length -le 4) {
            return ('*' * $cleanValue.Length)
        }

        return ('*' * ($cleanValue.Length - 4)) + $cleanValue.Substring($cleanValue.Length - 4)
    }

    function Test-LuhnNumber {
        param([string]$Number)

        $digits = ($Number -replace '\D', '')

        if ($digits.Length -lt 13 -or $digits.Length -gt 19) {
            return $false
        }

        $sum = 0
        $alternate = $false

        for ($i = $digits.Length - 1; $i -ge 0; $i--) {
            $numberValue = [int]::Parse($digits[$i])

            if ($alternate) {
                $numberValue *= 2

                if ($numberValue -gt 9) {
                    $numberValue -= 9
                }
            }

            $sum += $numberValue
            $alternate = -not $alternate
        }

        return (($sum % 10) -eq 0)
    }

    function Test-RoutingNumber {
        param([string]$Number)

        $digits = ($Number -replace '\D', '')

        if ($digits.Length -ne 9) {
            return $false
        }

        $checksum =
            (3 * ([int]::Parse($digits[0]) + [int]::Parse($digits[3]) + [int]::Parse($digits[6]))) +
            (7 * ([int]::Parse($digits[1]) + [int]::Parse($digits[4]) + [int]::Parse($digits[7]))) +
            (1 * ([int]::Parse($digits[2]) + [int]::Parse($digits[5]) + [int]::Parse($digits[8])))

        return (($checksum % 10) -eq 0)
    }

    function Get-ContextSnippet {
        param(
            [string]$Text,
            [int]$Index,
            [int]$Length,
            [int]$ContextSize = 80
        )

        $start = [Math]::Max(0, $Index - $ContextSize)
        $end = [Math]::Min($Text.Length, $Index + $Length + $ContextSize)

        return (($Text.Substring($start, $end - $start)) -replace '\s+', ' ').Trim()
    }

    function Get-PlainTextFromFile {
        param([string]$Path)

        try {
            return Get-Content -Path $Path -Raw -ErrorAction Stop
        }
        catch {
            Write-ScanLog "Failed to read text file $Path - $($_.Exception.Message)" 'WARN'
            return ''
        }
    }

    function Get-OpenXmlText {
        param([string]$Path)

        $tempFolder = Join-Path $env:TEMP ("openxml-" + [guid]::NewGuid().ToString())
        $textBuilder = New-Object System.Text.StringBuilder

        try {
            New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null

            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $tempFolder)

            $xmlFiles = Get-ChildItem -Path $tempFolder -Filter '*.xml' -Recurse -ErrorAction SilentlyContinue

            foreach ($xmlFile in $xmlFiles) {
                $rawXml = Get-Content -Path $xmlFile.FullName -Raw -ErrorAction SilentlyContinue

                if (-not [string]::IsNullOrWhiteSpace($rawXml)) {
                    $strippedText = $rawXml -replace '<[^>]+>', ' '
                    $strippedText = [System.Net.WebUtility]::HtmlDecode($strippedText)
                    [void]$textBuilder.AppendLine($strippedText)
                }
            }

            return $textBuilder.ToString()
        }
        catch {
            Write-ScanLog "OpenXML extraction failed for $Path - $($_.Exception.Message)" 'WARN'
            return ''
        }
        finally {
            if (Test-Path -Path $tempFolder) {
                Remove-Item -Path $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    function Get-PdfText {
        param(
            [string]$Path,
            [string]$PdfToTextPath
        )

        if ([string]::IsNullOrWhiteSpace($PdfToTextPath) -or -not (Test-Path -Path $PdfToTextPath)) {
            Write-ScanLog "PDF skipped because pdftotext.exe was not provided. File $Path" 'WARN'
            return ''
        }

        $tempTextFile = Join-Path $env:TEMP ("pdf-text-" + [guid]::NewGuid().ToString() + ".txt")

        try {
            & $PdfToTextPath -layout -enc UTF-8 $Path $tempTextFile | Out-Null

            if (Test-Path -Path $tempTextFile) {
                return Get-Content -Path $tempTextFile -Raw
            }

            return ''
        }
        catch {
            Write-ScanLog "PDF extraction failed for $Path - $($_.Exception.Message)" 'WARN'
            return ''
        }
        finally {
            if (Test-Path -Path $tempTextFile) {
                Remove-Item -Path $tempTextFile -Force -ErrorAction SilentlyContinue
            }
        }
    }

    function Get-DocumentText {
        param(
            [string]$Path,
            [string]$PdfToTextPath
        )

        $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

        switch ($extension) {
            '.docx' { return Get-OpenXmlText -Path $Path }
            '.pptx' { return Get-OpenXmlText -Path $Path }
            '.xlsx' { return Get-OpenXmlText -Path $Path }
            '.pdf'  { return Get-PdfText -Path $Path -PdfToTextPath $PdfToTextPath }
            default { return Get-PlainTextFromFile -Path $Path }
        }
    }

    $patterns = @(
        @{
            Name = 'Social Security Number'
            Severity = 'High'
            Regex = '\b(?!000|666|9\d{2})\d{3}[- ]?(?!00)\d{2}[- ]?(?!0000)\d{4}\b'
            Validator = 'None'
        },
        @{
            Name = 'Credit Card Number'
            Severity = 'High'
            Regex = '\b(?:\d[ -]*?){13,19}\b'
            Validator = 'Luhn'
        },
        @{
            Name = 'Bank Routing Number'
            Severity = 'High'
            Regex = '\b\d{9}\b'
            Validator = 'Routing'
        },
        @{
            Name = 'Payroll Keyword'
            Severity = 'Medium'
            Regex = '(?i)\b(payroll|salary|wage|bonus|commission|direct deposit|pay stub|paycheck|compensation|deduction|garnishment)\b'
            Validator = 'None'
        },
        @{
            Name = 'HIPAA PHI Keyword'
            Severity = 'Medium'
            Regex = '(?i)\b(patient|diagnosis|medical record|mrn|hipaa|treatment|prescription|medication|date of birth|dob|health plan|insurance member id|claim number)\b'
            Validator = 'None'
        },
        @{
            Name = 'HR Private Keyword'
            Severity = 'Medium'
            Regex = '(?i)\b(background check|disciplinary|termination|fmla|leave of absence|i-9|w-2|w4|1099|dependent|beneficiary)\b'
            Validator = 'None'
        },
        @{
            Name = 'Credential or Secret Keyword'
            Severity = 'High'
            Regex = '(?i)\b(password|passwd|secret|api key|apikey|token|client secret|private key|connection string)\b'
            Validator = 'None'
        },
        @{
            Name = 'Email Address'
            Severity = 'Low'
            Regex = '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
            Validator = 'None'
        },
        @{
            Name = 'Phone Number Candidate'
            Severity = 'Low'
            Regex = '\b(?:\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b'
            Validator = 'None'
        }
    )

    $supportedExtensions = @(
        '.doc', '.docx',
        '.ppt', '.pptx',
        '.xls', '.xlsx',
        '.pdf',
        '.txt', '.csv', '.json', '.xml', '.html', '.htm', '.log', '.md', '.rtf'
    )

    Write-ScanLog "Starting sensitive company data scan. Revision $scriptRevision"
    Write-ScanLog "Root path $RootPath"
    Write-ScanLog "Output folder $OutputFolder"

    $getChildItemParams = @{
        Path = $RootPath
        File = $true
        ErrorAction = 'SilentlyContinue'
    }

    if (-not $NoRecurse) {
        $getChildItemParams.Recurse = $true
    }

    $files = Get-ChildItem @getChildItemParams | Where-Object {
        $supportedExtensions -contains $_.Extension.ToLowerInvariant()
    }

    Write-ScanLog "Files selected for scan $($files.Count)"

    $findings = New-Object System.Collections.Generic.List[object]
    $aclRows = New-Object System.Collections.Generic.List[object]
    $processed = 0

    foreach ($file in $files) {
        $processed++
        $percentComplete = [Math]::Round(($processed / [Math]::Max($files.Count, 1)) * 100, 2)

        Write-Progress -Activity 'Scanning files for sensitive data' -Status $file.FullName -PercentComplete $percentComplete

        $text = Get-DocumentText -Path $file.FullName -PdfToTextPath $PdfToTextPath

        if ([string]::IsNullOrWhiteSpace($text)) {
            continue
        }

        $fileHadFinding = $false
        $fileHash = ''

        if ($IncludeHash) {
            try {
                $fileHash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash
            }
            catch {
                $fileHash = 'Hash failed'
            }
        }

        foreach ($pattern in $patterns) {
            $matches = [regex]::Matches($text, $pattern.Regex)

            foreach ($match in $matches) {
                $value = $match.Value

                if ($pattern.Validator -eq 'Luhn' -and -not (Test-LuhnNumber -Number $value)) {
                    continue
                }

                if ($pattern.Validator -eq 'Routing' -and -not (Test-RoutingNumber -Number $value)) {
                    continue
                }

                $fileHadFinding = $true

                $maskedValue = Mask-Value -Value $value
                $snippet = Get-ContextSnippet -Text $text -Index $match.Index -Length $match.Length
                $maskedSnippet = $snippet.Replace($value, $maskedValue)

                $findings.Add([pscustomobject]@{
                    ScanDate       = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                    Severity       = $pattern.Severity
                    FindingType    = $pattern.Name
                    FileName       = $file.Name
                    FullPath       = $file.FullName
                    Extension      = $file.Extension
                    FileSizeMB     = [Math]::Round(($file.Length / 1MB), 2)
                    LastWriteTime  = $file.LastWriteTime
                    FileHashSHA256 = $fileHash
                    MaskedMatch    = $maskedValue
                    ContextSnippet = $maskedSnippet
                })
            }
        }

        if ($IncludeAclReport -and $fileHadFinding) {
            try {
                $acl = Get-Acl -Path $file.FullName

                foreach ($access in $acl.Access) {
                    $aclRows.Add([pscustomobject]@{
                        ScanDate          = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                        FullPath          = $file.FullName
                        Owner             = $acl.Owner
                        IdentityReference = $access.IdentityReference.Value
                        FileSystemRights  = $access.FileSystemRights
                        AccessControlType = $access.AccessControlType
                        IsInherited       = $access.IsInherited
                    })
                }
            }
            catch {
                Write-ScanLog "ACL read failed for $($file.FullName) - $($_.Exception.Message)" 'WARN'
            }
        }
    }

    Write-Progress -Activity 'Scanning files for sensitive data' -Completed

    if ($findings.Count -gt 0) {
        $findings |
            Sort-Object Severity, FindingType, FullPath |
            Export-Csv -Path $findingCsv -NoTypeInformation -Append

        Write-ScanLog "Findings exported to $findingCsv"
    }
    else {
        Write-ScanLog 'No findings detected'
    }

    if ($IncludeAclReport -and $aclRows.Count -gt 0) {
        $aclRows |
            Sort-Object FullPath, IdentityReference |
            Export-Csv -Path $aclCsv -NoTypeInformation -Append

        Write-ScanLog "ACL report exported to $aclCsv"
    }

    Write-ScanLog 'Scan complete'

    if ($PauseAtEnd) {
        Write-Host ''
        Write-Host 'press any key'
        Write-Host 'to end'
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
}

<#
.EXAMPLE
    . .\Find-SensitiveCompanyData.ps1
    Find-SensitiveCompanyData -RootPath "N:\DataToMigrate" -IncludeAclReport

.EXAMPLE
    . .\Find-SensitiveCompanyData.ps1
    Find-SensitiveCompanyData -RootPath "N:\DataToMigrate" -OutputFolder "C:\temp\powershell-exports" -IncludeAclReport -IncludeHash

.EXAMPLE
    . .\Find-SensitiveCompanyData.ps1
    Find-SensitiveCompanyData -RootPath "N:\DataToMigrate" -PdfToTextPath "C:\Tools\poppler\Library\bin\pdftotext.exe" -IncludeAclReport

.EXAMPLE
    .\Find-SensitiveCompanyData.ps1
    Find-SensitiveCompanyData -RootPath "C:\Temp\TestData" -NoRecurse -PauseAtEnd
#>