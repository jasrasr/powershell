# ADD TO `$PROFILE

function ChatGPT {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false)]
        [string]$Prompt = $(Read-Host "Enter your prompt"),

        [Parameter(Position = 1, Mandatory = $false)]
        [string]$Project = "Project1"
    )

    $ScriptPath = "$GitHubPath\PowerShell-Private\ChatGPT-CLI\Invoke-ChatGPT.ps1"
    $ProjectRoot = "$GitHubPath\PowerShell-Private\ChatGPT-CLI\$Project"

    & $ScriptPath -Prompt $Prompt -ProjectPath $ProjectRoot
}
