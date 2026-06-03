# Filename: test-get-github-repo-issues.ps1
# Revision : 1.0.0
# Description : Regression checks for get-github-repo-issues.ps1 helper behavior
# Author : Jason Lamb (with help from Codex CLI)
# Created Date : 2026-06-03
# Modified Date : 2026-06-03
# Changelog :
# 1.0.0 initial release

$scriptPath = Join-Path $PSScriptRoot "get-github-repo-issues.ps1"
$scriptText = Get-Content -Path $scriptPath -Raw
$tokens = $null
$errors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseInput($scriptText, [ref]$tokens, [ref]$errors)

if ($errors.Count -gt 0) {
    throw "Script parse failed: $($errors[0].Message)"
}

$functionAst = $ast.Find({
    param ($node)
    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
    $node.Name -eq "ConvertTo-GitHubRepoSlug"
}, $true)

if (-not $functionAst) {
    throw "ConvertTo-GitHubRepoSlug function was not found."
}

. ([scriptblock]::Create($functionAst.Extent.Text))

$cases = @(
    @{ Input = "jasrasr/website"; Expected = "jasrasr/website" },
    @{ Input = "github.com/jasrasr/website"; Expected = "jasrasr/website" },
    @{ Input = "github.com/jasrasr/website.git"; Expected = "jasrasr/website" },
    @{ Input = "https://github.com/jasrasr/website.git"; Expected = "jasrasr/website" }
)

foreach ($case in $cases) {
    $actual = ConvertTo-GitHubRepoSlug -Repo $case.Input

    if ($actual -ne $case.Expected) {
        throw "Expected '$($case.Input)' to normalize to '$($case.Expected)', but got '$actual'."
    }
}

Write-Host "All repo normalization checks passed."

# Example Usage:
#   .\test-get-github-repo-issues.ps1
