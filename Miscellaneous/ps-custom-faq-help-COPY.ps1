# Revision : 1.5
# Description : Jason's custom PowerShell quick reference with colored banner details (labels magenta, values white)
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-19
# Modified Date : Auto-updates when reloaded

$Revision     = '1.5'
$CreatedDate  = '2025-08-19'
$ModifiedDate = (Get-Date).ToString('yyyy-MM-dd')

function Show-JasonHelp {

    # --- Banner ---
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " Jason's PowerShell Quick Reference " -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan

    Write-Host "Revision : $Revision" -ForegroundColor Magenta
    Write-Host "Created   : $CreatedDate" -ForegroundColor Magenta
    Write-Host "Modified  : $ModifiedDate" -ForegroundColor Magenta
    Write-Host ""

    # --- Help Text ---
    $helpText = @"
# FAQ File Location
$githubpath\!PS-custom-faq-help.ps1

# Common Paths
C:\temp\powershell-exports\

# Useful Commands
dir | Select -ExpandProperty ProviderPath
``n for break line
write-host -foregroundcolor -NoNewline

# Notes
Keep scripts revisioned, logged, and stored in GitHub repos. > jlgps2
"@

    foreach ($line in $helpText -split "`r?`n") {
        switch -Regex ($line) {
            '^#'         { Write-Host $line -ForegroundColor Yellow }   # Headers
            '^[A-Z]:\\'  { Write-Host $line -ForegroundColor Green }    # Paths
            'dir \|'     { Write-Host $line -ForegroundColor Green }    # Commands
            '`n'         { Write-Host $line -ForegroundColor Green }    # Special notes
            '==='        { Write-Host $line -ForegroundColor Cyan }     # Divider lines
            default      { Write-Host $line -ForegroundColor White }    # Normal text
        }
    }
}

Set-Alias sjh Show-JasonHelp

$faq = "$GitHubpath\!PS-custom-faq-help.ps1"
