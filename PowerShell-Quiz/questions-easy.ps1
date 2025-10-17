<#
  File     : questions-easy.ps1
  Revision : 1.0
  Purpose  : Beginner-level question set for QuizEngine.ps1
  Usage    : . "$PSScriptRoot\questions-easy.ps1"
#>

$Questions = @(
    @{ Q = "What is the default file extension for a PowerShell script?"
       A = @(".ps", ".ps1", ".sh", ".cmd") },
    @{ Q = "Which cmdlet lists all running processes?"
       A = @("Get-Services", "Get-Process", "Show-Tasks", "List-Process") },
    @{ Q = "What does the `$` symbol mean in PowerShell?"
       A = @("It declares a variable", "It runs a script", "It’s the pipe operator", "It’s a comment indicator") },
    @{ Q = "What cmdlet displays a list of all cmdlets/commands?"
       A = @("Get-Help", "Get-Command", "Get-All", "Show-Cmd") },
    @{ Q = "Which command clears the screen in PowerShell?"
       A = @("cls", "Clear-Host", "Both A and B", "Reset-Screen") },
    @{ Q = "What does the pipe operator `|` do?"
       A = @("Assigns variables", "Ends a script", "Passes output between commands", "Writes to a file") },
    @{ Q = "Which cmdlet reads the contents of a text file?"
       A = @("Get-Content", "Read-File", "Show-Text", "Import-File") },
    @{ Q = "How do you add a comment in PowerShell?"
       A = @("//", "--", "#", "/* … */") },
    @{ Q = "Which cmdlet stops a running process?"
       A = @("Stop-Task", "Stop-Service", "Stop-Process", "Kill-Proc") },
    @{ Q = "Which command shows your current directory?"
       A = @("pwd", "Get-Location", "Both A and B", "Show-Path") }
)

# XOR key and obfuscated correct answers (no plaintext comments)
$AnswerKeyXor = 0x5A
# Correct letters (not commented here): B B A B C C A C C C
[byte[]] $ObfuscatedAnswers = [byte[]]@( 24, 24, 27, 24, 25, 25, 27, 25, 25, 25 )