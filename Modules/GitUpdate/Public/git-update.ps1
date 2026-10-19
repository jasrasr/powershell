<#
.SYNOPSIS
Smart git pull/add/commit/push for the current repository.

.DESCRIPTION
Pulls with rebase and autostash, stages all changes, generates a commit message,
commits, and pushes to origin/main. The commit message is generated from the staged
diff via OpenAI (gpt-4o-mini) using the GIT_UPDATE_OPENAI_API_KEY environment
variable. If the key is missing, the API call fails, or -Quick is used, a timestamped
message is used instead. Stops without committing or pushing if the pull fails.

.PARAMETER Quick
Skip AI and use a timestamped commit message.

.EXAMPLE
git-update
Run from inside a git repository to pull, commit with an AI-generated message, and push.

.EXAMPLE
git-update -Quick
Same, but use a timestamped commit message instead of calling OpenAI.

.LINK
https://github.com/jasrasr/powershell/tree/main/Modules/GitUpdate

.LINK
git-update-all

.LINK
https://platform.openai.com/docs/api-reference/chat

.NOTES
Filename : Public\git-update.ps1 (part of the GitUpdate module)
Revision : 1.0.7
Author   : Jason Lamb (with help from Claude Code CLI)
Created  : 2026-05-05
Modified : 2026-10-19
Changelog:
  1.0.0 initial release
  1.0.1 bail out on pull failure instead of committing/pushing into a diverged state;
        switched pull to --rebase --autostash; added push-failure handling
  1.0.2 set GIT_ASK_YESNO=false so Git for Windows no longer prompts "Should I try
        again? (y/n)" when it can't delete a stale ref/object directory (usually
        because OneDrive or antivirus is briefly holding a lock on it)
  1.0.3 push explicitly to origin/main
  1.0.4 suppress CRLF-to-LF warnings on git add (core.safecrlf=false for that call only)
  1.0.5 converted header and usage examples to comment-based help (Get-Help git-update);
        copied unchanged into the GitUpdate module
  1.0.6 added .LINK entries (repository, git-update-all, OpenAI chat API) to the help
  1.0.7 first .LINK now points to the GitUpdate module folder on GitHub (used by Get-Help -Online)
#>
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

    # Git for Windows' mingw compat layer will interactively prompt
    # "Deletion of directory 'X' failed. Should I try again? (y/n)" when it can't
    # rmdir a stale ref/loose-object directory (common on OneDrive-synced repos,
    # where OneDrive briefly locks files it's indexing/uploading). Setting
    # GIT_ASK_YESNO to a command that always fails ("false") makes git treat every
    # such prompt as an automatic "no" instead of blocking on stdin.
    $env:GIT_ASK_YESNO = 'false'

    # Pull latest (rebase + autostash so uncommitted local changes don't block the pull)
    Write-Host "Pulling latest changes..." -ForegroundColor Cyan
    git pull --rebase --autostash
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Pull failed. Refusing to commit/push into a diverged state." -ForegroundColor Red
        if (Test-Path (Join-Path $gitDir.FullName 'rebase-merge')) {
            Write-Host "Aborting in-progress rebase..." -ForegroundColor Yellow
            git rebase --abort
        }
        Write-Host "Resolve manually (git status), then run git-update again." -ForegroundColor Yellow
        return
    }

    # Stage all changes
    Write-Host "Staging all changes..." -ForegroundColor Cyan
    # core.safecrlf=false hides the "CRLF will be replaced by LF" warning for working
    # files that are still CRLF on disk; .gitattributes already stores them as LF.
    git -c core.safecrlf=false add -A

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
        if (-not $env:GIT_UPDATE_OPENAI_API_KEY) {
            Write-Host "GIT_UPDATE_OPENAI_API_KEY not set. Falling back to timestamped message." -ForegroundColor Yellow
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
                        content = "You are a git commit message generator. Given a git diff, write a concise, meaningful commit message in present tense, under 72 characters. Return only the commit message, no explanation. Do not mention AI, artificial intelligence, or automation in the message."
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
                    -Headers @{ Authorization = "Bearer $env:GIT_UPDATE_OPENAI_API_KEY" } `
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
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit failed. Aborting before push." -ForegroundColor Red
        return
    }

    # Push
    Write-Host "Pushing..." -ForegroundColor Cyan
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Push failed. Local commit is preserved." -ForegroundColor Red
        Write-Host "Run git-update again, or resolve manually with git pull --rebase / git push." -ForegroundColor Yellow
        return
    }

    Write-Host "Done." -ForegroundColor Green
}
