<#
  File     : questions-hard.ps1
  Revision : 1.0
  Purpose  : Hard-level question set for QuizEngine.ps1
  Usage    : . "$PSScriptRoot\questions-hard.ps1"
#>

$Questions = @(
    @{ Q = "In a Try/Catch that must catch a cmdlet's non-terminating errors WITHOUT changing global preference, what should you do?"
       A = @("Set `$ErrorActionPreference = 'Continue'",
             "Use -ErrorAction Stop on that cmdlet",
             "Append 'Throw' at the end of the pipeline",
             "Use -Verbose") },

    @{ Q = "Which command retrieves processes via CIM over WSMan using an existing CIM session `$s`?"
       A = @("Get-CimInstance -ClassName Win32_Process -CimSession $s",
             "Get-WmiObject Win32_Process -ComputerName .",
             "Get-Process -CimSession $s",
             "Invoke-CimMethod -ClassName Win32_Process -MethodName Create") },

    @{ Q = "Inside an advanced function, what does `$PSBoundParameters` contain?"
       A = @("All declared parameters with defaults",
             "Only parameters actually bound by the caller",
             "All environment variables available to the session",
             "All automatic variables like `$PID` and `$HOME`") },

    @{ Q = "Which pipeline produces a VALID CSV of service names and statuses?"
       A = @("Get-Service | Format-Table Name,Status | Export-Csv .\svc.csv -NoTypeInformation",
             "Get-Service | Select-Object Name,Status | Export-Csv .\svc.csv -NoTypeInformation",
             "Get-Service | Out-Host | Export-Csv .\svc.csv -NoTypeInformation",
             "Get-Service | ConvertTo-Html | Export-Csv .\svc.csv -NoTypeInformation") },

    @{ Q = "Which attribute turns a normal function into an advanced function (cmdlet-like)?"
       A = @("[CmdletBinding()]", "[Parameter(Mandatory)]", "[ValidateNotNullOrEmpty()]", "[Alias()]") },

    @{ Q = "Which validation attribute enforces a regular expression match for a parameter?"
       A = @("[ValidateSet('A','B')]", "[ValidateScript({ $_ -gt 0 })]", "[ValidatePattern('^\\d{3}-\\d{2}-\\d{4}$')]", "[ValidateRange(1,10)]") },

    @{ Q = "Which is TRUE about ForEach-Object -Parallel?"
       A = @("It works in Windows PowerShell 5.1",
             "It requires PowerShell 7+",
             "It guarantees output order matches input",
             "It runs only on remote computers") },

    @{ Q = "Which cmdlet converts a SecureString to an encrypted string you can store and later reconstruct on the SAME user+machine?"
       A = @("ConvertTo-SecureString", "ConvertFrom-SecureString", "Protect-String", "Export-CliXml -AsPlainText") },

    @{ Q = "What does 'using module Foo' do at the top of a script?"
       A = @("Imports the module at parse time so types/commands are available for things like class definitions",
             "Imports the module only after the first command is called",
             "Installs the module if missing and then imports",
             "Downloads the module manifest but not the functions") },

    @{ Q = "Which stream number corresponds to Verbose output?"
       A = @("2", "3", "4", "6") }
)

# XOR key and obfuscated correct answers (no plaintext comments)
$AnswerKeyXor = 0x5A
# Correct letters mapping: A=27, B=24, C=25, D=30
# Answer string (10): B A B B A C B B A C
[byte[]] $ObfuscatedAnswers = [byte[]]@( 24, 27, 24, 24, 27, 25, 24, 24, 27, 25 )