# GitUpdate

PowerShell module for keeping Git repositories in sync with one command.

| Command | What it does |
|---|---|
| [`git-update`](Public/git-update.ps1) | In the current repo: pull (rebase + autostash), stage all, commit, push to `origin/main`. Writes the commit message with OpenAI from the staged diff, or uses a timestamped message with `-Quick`. |
| [`git-update-all`](Public/git-update-all.ps1) | Runs `git-update` in every repository on an allowlist under `$githubpath`. Prints a total of the AI model and tokens used at the end. |
| `Get-GitUpdateVersion` | Shows the module version and each function's revision. `-ReleaseNotes` shows the release history. |

Works in Windows PowerShell 5.1 and PowerShell 7.

## Layout

```
Modules\GitUpdate\
  GitUpdate.psd1                 manifest: ModuleVersion, exported functions, ReleaseNotes
  GitUpdate.psm1                 loads Public\*.ps1 and exports the commands
  Public\git-update.ps1          one function per file, each with its own help and revision
  Public\git-update-all.ps1
  Public\Get-GitUpdateVersion.ps1
  README.md
```

Source files: [`Public/git-update.ps1`](Public/git-update.ps1) and [`Public/git-update-all.ps1`](Public/git-update-all.ps1). Each of them has a comment at the top that links back to this README.

`git-update-all` depends on `git-update`: it runs no git commands and makes no OpenAI calls itself. If `git-update` is missing, `git-update-all` fails for every repository.

## Requirements

- Git on the PATH, and repositories whose default branch is `main` with an `origin` remote (`git-update` pushes to `origin/main`).
- `$githubpath` defined in the PowerShell profile: the folder that contains your repositories. `git-update-all` uses it as the default `-ParentPath`.
- Optional, for AI commit messages: an OpenAI API key, from either source below. Without a key, or with `-Quick`, a timestamped message is used. Keep the key out of scripts, the profile, and Git. Never paste it into chat or commit it.
  1. The `GIT_UPDATE_OPENAI_API_KEY` environment variable (set at User scope).
  2. Bitwarden, if the variable is not set: the [Bitwarden CLI](https://bitwarden.com/help/cli/) (`bw`) installed, and unlocked in the current terminal (`BW_SESSION` set). `git-update` reads the key with `bw get password` from the item named by `GIT_UPDATE_BW_ITEM` (default `OpenAI - git-update`) into a local variable. It never unlocks the vault, never prompts, and never prints the key. If `bw` is missing or locked, it falls back to the timestamped message.

  To use Bitwarden, unlock it only in your own terminal, then run `git-update`:

  ```powershell
  $env:BW_SESSION = bw unlock --raw
  git-update
  bw lock
  ```

  Do not unlock the vault in a terminal that an AI coding tool can run commands in, and do not set `BW_SESSION` in the profile or at User scope. Whether Bitwarden is approved for storing company API keys is a decision for Cooper IT / InfoSec.

## Loading the module

The shared profile adds this repo's `Modules` folder to `PSModulePath` and imports the module. Equivalent manual steps:

```powershell
$env:PSModulePath += ";$githubpath\powershell\Modules"
Import-Module GitUpdate -Force -DisableNameChecking
```

`-DisableNameChecking` silences the unapproved-verb warning for the `git-update` names. `-Force` re-reads the files from disk, which is how `reload-profile` picks up edits. Without it, an already-loaded module is not reloaded.

If `$githubpath` is not defined or the module folder is missing, the profile prints an info message instead of failing.

## Usage

```powershell
git-update                    # AI commit message
git-update -Quick             # timestamped message, no OpenAI call
git-update-all                # every allowlisted repo under $githubpath
git-update-all -Quick
git-update-all -ParentPath 'D:\Repos'
Get-GitUpdateVersion
Get-GitUpdateVersion -ReleaseNotes
Get-Help git-update-all -Full
Get-Help git-update-all -Online     # opens this folder on GitHub
```

The repository allowlist is the `$repositoryNames` list in `Public\git-update-all.ps1`. Repositories not found under `-ParentPath` are skipped with a message.

## Versions

- **Module version:** `ModuleVersion` in `GitUpdate.psd1`. This is what `Get-Command` and `Get-Module` show. It goes up for any change to the module.
- **File revisions:** the `Revision` and `Modified` lines and the changelog in each function's `.NOTES`. PowerShell does not track these; `Get-GitUpdateVersion` reads them from the help text, so keep the `Revision :` and `Modified :` format.
- **Release notes:** `PrivateData.PSData.ReleaseNotes` in the manifest, newest first, each line listing the file revisions shipped.

## Release routine

1. Edit the function file. In its `.NOTES`, bump `Revision`, set `Modified`, and add a changelog line.
2. Bump `ModuleVersion` in `GitUpdate.psd1`: patch for a fix or docs change, minor for a new feature or parameter, major for a breaking change.
3. Add a line at the top of `ReleaseNotes`: `<module version> (<date>) <function> <revision>, ...` plus a short description.
4. Reload and check: `reload-profile` (or `Import-Module GitUpdate -Force -DisableNameChecking`), then `Get-GitUpdateVersion`.
5. Test before pushing. Use a throwaway repo with a local bare remote, not real repositories, for anything that touches the commit or push path.
6. Commit and push (`git-update`).

Adding a new command: create `Public\<Name>.ps1` with comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE`, `.LINK`, `.NOTES` with `Revision` and `Modified`), then add the name to `Export-ModuleMember` in `GitUpdate.psm1` and to `FunctionsToExport` in `GitUpdate.psd1`.

## Related

The standalone scripts [`Miscellaneous/git-update.ps1`](../../Miscellaneous/git-update.ps1) and [`Miscellaneous/git-update-all.ps1`](../../Miscellaneous/git-update-all.ps1) in this repo are the original dot-source versions. They are kept for reference and for anyone who does not want a module. They are separate from this module and are not updated with it.
