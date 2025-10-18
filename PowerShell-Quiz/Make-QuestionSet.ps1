<#
  File     : Make-QuestionSet.ps1
  Purpose  : Interactive builder for question-set files used by Quiz-Engine.ps1
  Usage    : .\Make-QuestionSet.ps1 -OutputPath .\questions-myset.ps1 -SetName 'myset'
             (Both params optional; you’ll be prompted if omitted)
#>

[CmdletBinding()]
param(
    [string] $OutputPath,
    [string] $SetName = 'custom',
    [int]    $AnswerKeyXor = 0x5A,
    [int]    $NumQuestions = 10
)

function Escape-SingleQuoted {
    param([string] $s)
    if ($null -eq $s) { return '' }
    # single-quoted PowerShell strings: escape ' as ''
    return ($s -replace "'", "''")
}

if (-not $OutputPath) {
    $default = ".\questions-$SetName.ps1"
    $OutputPath = Read-Host "Enter output file path [$default]"
    if ([string]::IsNullOrWhiteSpace($OutputPath)) { $OutputPath = $default }
}

Write-Host "Building $NumQuestions questions. Leave nothing blank, or I sass you." -ForegroundColor Cyan

$questions = New-Object System.Collections.Generic.List[object]
$answerLetters = New-Object System.Collections.Generic.List[string]
$obfBytes = New-Object System.Collections.Generic.List[byte]

for ($i = 1; $i -le $NumQuestions; $i++) {
    Write-Host ""
    Write-Host "---- Question $i ----" -ForegroundColor Yellow

    do {
        $q = Read-Host "Q$i text"
    } until ($q -and $q.Trim().Length -gt 0)

    $choices = @()
    foreach ($label in 'A','B','C','D') {
        do {
            $t = Read-Host "Choice $label"
        } until ($t -and $t.Trim().Length -gt 0)
        $choices += $t
    }

    do {
        $correct = (Read-Host "Correct letter for Q$i (A/B/C/D)").ToUpper()
    } until ($correct -in @('A','B','C','D'))

    # store
    $questions.Add([pscustomobject]@{
        Q = $q
        A = $choices
    })
    $answerLetters.Add($correct)

    # obfuscate: letter -> ASCII -> XOR
    $b = ([byte][char]$correct) -bxor [byte]$AnswerKeyXor
    $obfBytes.Add($b)
}

# Build file content (single-quoted literals, no plaintext answers)
$sb = New-Object System.Text.StringBuilder

# Header
[void]$sb.AppendLine("<#")
[void]$sb.AppendLine("  Auto-generated question set")
[void]$sb.AppendLine("  Created : $(Get-Date)")
[void]$sb.AppendLine("  Note    : No plaintext answers are stored here. Obfuscated bytes only.")
[void]$sb.AppendLine("#>")
[void]$sb.AppendLine("")
[void]$sb.AppendLine('$Questions = @(')

# Questions
for ($i = 0; $i -lt $questions.Count; $i++) {
    $q = $questions[$i]
    $qText = Escape-SingleQuoted $q.Q
    $aA = Escape-SingleQuoted $q.A[0]
    $aB = Escape-SingleQuoted $q.A[1]
    $aC = Escape-SingleQuoted $q.A[2]
    $aD = Escape-SingleQuoted $q.A[3]

    [void]$sb.AppendLine("    @{ Q = '$qText'")
    [void]$sb.AppendLine("       A = @('$aA', '$aB', '$aC', '$aD') },")
}
[void]$sb.AppendLine(')')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('$AnswerKeyXor = 0x5A')
# Bytes
$byteList = ($obfBytes | ForEach-Object { $_.ToString() }) -join ', '
[void]$sb.AppendLine("[byte[]] `\$ObfuscatedAnswers = [byte[]]@($byteList)")
[void]$sb.AppendLine("")

# Write file
$dir = Split-Path -Path $OutputPath -Parent
if (-not [string]::IsNullOrWhiteSpace($dir) -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}
$sb.ToString() | Out-File -FilePath $OutputPath -Encoding UTF8 -Force

Write-Host ""
Write-Host "Wrote: $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host "Run with:" -ForegroundColor Cyan
Write-Host ". .\Quiz-Engine.ps1 -QuestionSetPath `"$OutputPath`"" -ForegroundColor White
Write-Host ""
Write-Host "FYI: XOR key used: 0x$(('{0:X2}' -f $AnswerKeyXor))" -ForegroundColor DarkGray
