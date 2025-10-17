<#
  File     : questions-medium.ps1
  Revision : 1.0
  Purpose  : Medium-level question set for QuizEngine.ps1
  Usage    : . "$PSScriptRoot\questions-medium.ps1"
#>

$Questions = @(
    @{ Q = "Which common parameter suppresses non-terminating error messages from a cmdlet?"
       A = @("-ErrorAction Stop", "-ErrorVariable", "-ErrorAction SilentlyContinue", "-WarningAction") },

    @{ Q = "Which automatic variable is an alias of $PSItem in pipeline scriptblocks?"
       A = @("$Input", "$_", "$This", "$Args") },

    @{ Q = "Which command returns the raw property value (not a wrapped object) from objects in the pipeline?"
       A = @("Select-Object Name", "Format-Table -Property Name", "Select-Object -ExpandProperty Name", "Get-Member -Name Name") },

    @{ Q = "Which is valid splatting syntax?"
       A = @("$p = @{ Path='C:\'; Filter='*.log' }; Get-ChildItem @p",
             "$p = 'Path=C:\,Filter=*.log'; Get-ChildItem $p",
             "Get-ChildItem -Splat @{ Path='C:\'; Filter='*.log' }",
             "Get-ChildItem @{ Path='C:\'; Filter='*.log' }") },

    @{ Q = "Which profile path applies to the current user in all hosts?"
       A = @("$PROFILE.CurrentUserCurrentHost", "$PROFILE.AllUsersAllHosts", "$PROFILE.CurrentUserAllHosts", "$PROFILE.AllUsersCurrentHost") },

    @{ Q = "Which of the following is a hashtable literal?"
       A = @("@{Name='Jason';Age=42}", "@('Jason','Lamb')", "[PSCustomObject]@{Name='Jason';Age=42}", "[ordered]@{Name='Jason';Age=42}") },

    @{ Q = "How do you get the TOTAL size of all files under a folder?"
       A = @("Get-ChildItem -File -Recurse | Measure-Object",
             "Get-ChildItem -File -Recurse | Measure-Object -Property Length -Sum",
             "Get-ChildItem -Recurse | Sort-Object Length -Descending | Select-Object -First 1",
             "Measure-Object -Sum Length -InputObject (Get-ChildItem)") },

    @{ Q = "Which command runs a scriptblock on multiple remote computers?"
       A = @("Enter-PSSession -ComputerName S1,S2 -ScriptBlock {...}",
             "Start-Job -ComputerName S1,S2 -ScriptBlock {...}",
             "Invoke-Command -ComputerName S1,S2 -ScriptBlock {...}",
             "New-PSSessionConfigurationFile -ComputerName S1,S2") },

    @{ Q = "Which Get-Content switch waits for new lines like tail -f?"
       A = @("-TailForever", "-Wait", "-Monitor", "-Stream") },

    @{ Q = "Which redirection operator sends ONLY the error stream to a file (overwrite)?"
       A = @(">", "2>", "*>", "1>>") }
)

# XOR key and obfuscated correct answers (no plaintext comments)
$AnswerKeyXor = 0x5A
# Correct letters mapping: A=27, B=24, C=25, D=30
# Answer string (10): C B C A C A B C B B
[byte[]] $ObfuscatedAnswers = [byte[]]@( 25, 24, 25, 27, 25, 27, 24, 25, 24, 24 )