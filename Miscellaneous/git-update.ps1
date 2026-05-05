# Filename: git-update.ps1
# Revision : 1.0.0
# Description : Smart git pull/add/commit/push. Generates AI commit message from diff via OpenAI.
#               Use -Quick to skip AI and use a timestamped message instead.
# Author : Jason Lamb (with help from Claude Code CLI)
# Created Date : 2026-05-05
# Modified Date : 2026-05-05
# Changelog :
# 1.0.0 initial release

function git-update {
    param(
        [switch]$Quick
    )

    # Validate current directory is a git repo (use -Force to catch hidden .git folder)
    $gitDir = Get-ChildItem -Path (Get-Location).Path -Force -Filter '.git' -Directory -ErrorAction SilentlyContinue
    if (-not $gitDir) {
        Write-Host "Not a git repository. Navigate to a git repo folder first." -ForegroundColor Red
        return
    }

    $datetime = Get-Date -Format 'yyyy-MM-dd HH:mm'

    # Pull latest
    Write-Host "Pulling latest changes..." -ForegroundColor Cyan
    git pull

    # Stage all changes
    Write-Host "Staging all changes..." -ForegroundColor Cyan
    git add -A

    # Check if anything is staged
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Nothing to commit." -ForegroundColor Yellow
        return
    }

    # Determine commit message
    if ($Quick) {
        $commitMessage = "updated several files $datetime"
        Write-Host "Quick mode: using timestamped message." -ForegroundColor Cyan
    } else {
        if (-not $env:OPENAI_API_KEY) {
            Write-Host "OPENAI_API_KEY not set. Falling back to timestamped message." -ForegroundColor Yellow
            $commitMessage = "updated several files $datetime"
        } else {
            Write-Host "Generating AI commit message from diff..." -ForegroundColor Cyan

            $diff = git diff --cached
            $diffText = $diff -join "`n"

            # Truncate if too large
            if ($diffText.Length -gt 4000) {
                $diffText = $diffText.Substring(0, 4000) + "`n[diff truncated]"
            }

            $body = @{
                model    = "gpt-4o-mini"
                messages = @(
                    @{
                        role    = "system"
                        content = "You are a git commit message generator. Given a git diff, write a concise, meaningful commit message in present tense, under 72 characters. Return only the commit message, no explanation."
                    },
                    @{
                        role    = "user"
                        content = $diffText
                    }
                )
            } | ConvertTo-Json -Depth 6

            try {
                $response = Invoke-RestMethod `
                    -Uri "https://api.openai.com/v1/chat/completions" `
                    -Headers @{ Authorization = "Bearer $env:OPENAI_API_KEY" } `
                    -Method Post `
                    -ContentType "application/json" `
                    -Body $body

                $commitMessage = $response.choices[0].message.content.Trim()
                Write-Host "AI message: $commitMessage" -ForegroundColor Green
            } catch {
                Write-Host "OpenAI call failed: $_. Falling back to timestamped message." -ForegroundColor Yellow
                $commitMessage = "updated several files $datetime"
            }
        }
    }

    # Commit
    Write-Host "Committing..." -ForegroundColor Cyan
    git commit -m $commitMessage

    # Push
    Write-Host "Pushing..." -ForegroundColor Cyan
    git push

    Write-Host "Done." -ForegroundColor Green
}

# Example Usage:
#   .\git-update.ps1             # dot-source then call: git-update
#   git-update                   # after dot-sourcing via profile
#   git-update -Quick            # skip AI, use timestamped message
