# git-update.ps1 Design Spec
Date: 2026-05-05

## Overview
A PowerShell script that performs a smart git pull/add/commit/push workflow. In default mode, it sends the staged diff to OpenAI to generate a meaningful commit message. A `-Quick` switch bypasses AI and uses a timestamped fallback message. Only pushes if there are actual staged changes.

## Files Changed
| File | Change |
|------|--------|
| `Miscellaneous\git-update.ps1` | Create — defines `git-update` function |
| `!commonpowershellprofilepath.ps1` | Edit — append dot-source line |

## Script: git-update.ps1

### Parameters
- `-Quick` [switch] — skips OpenAI call, uses `"updated several files yyyy-MM-dd HH:mm"` as commit message

### Function Name
`git-update` — callable from terminal after dot-sourcing via profile

### Flow
1. Validate current directory is a git repo using `Get-ChildItem -Force -Filter '.git'` (handles hidden `.git` folders)
2. `git pull`
3. `git add -A`
4. `git diff --cached --quiet` — if exit code 0, nothing staged → print "Nothing to commit" and exit cleanly
5. **If `-Quick`:** message = `"updated several files $(Get-Date -Format 'yyyy-MM-dd HH:mm')"`
6. **If default:** get `git diff --cached` output → truncate to 4000 chars if needed → send to OpenAI → receive commit message
7. `git commit -m "<message>"`
8. `git push`

### OpenAI Call
- Endpoint: `https://api.openai.com/v1/chat/completions`
- Model: `gpt-4o-mini`
- API Key: `$env:OPENAI_API_KEY`
- System prompt: `"You are a git commit message generator. Given a git diff, write a concise, meaningful commit message in present tense, under 72 characters. Return only the commit message, no explanation."`
- Diff truncated at 4000 chars if needed
- On API failure: falls back to timestamped message and continues

### .git Detection
```powershell
$gitDir = Get-ChildItem -Path (Get-Location).Path -Force -Filter '.git' -Directory -ErrorAction SilentlyContinue
if (-not $gitDir) { Write-Host "Not a git repository." -ForegroundColor Red; return }
```

### Script Structure
Wraps all logic in `function git-update { param([switch]$Quick) ... }` so dot-sourcing the file defines the function without executing it.

## Profile Edit: !commonpowershellprofilepath.ps1
Append this line:
```powershell
. "$githubpath\powershell\Miscellaneous\git-update.ps1"
```

## Header/Footer
Follows standard CLAUDE.md header format with revision 1.0.0, and includes example usage footer:
```
.\git-update.ps1        # AI-generated commit message
.\git-update.ps1 -Quick # Timestamped message, no AI
git-update              # After dot-sourcing via profile
git-update -Quick
```
