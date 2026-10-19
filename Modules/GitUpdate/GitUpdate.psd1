@{
    RootModule            = 'GitUpdate.psm1'
    ModuleVersion         = '1.3.0'
    GUID                  = 'b6f0c1f4-5a1e-4c7e-9a3d-2f8e6d1c4a57'
    Author                = 'Jason Lamb'
    CompanyName           = 'Cooper Machinery Services'
    Description           = 'git-update (pull/add/commit/push with optional AI commit message) and git-update-all (runs git-update across the approved repository allowlist).'
    PowerShellVersion     = '5.1'
    CompatiblePSEditions  = @('Desktop', 'Core')
    FunctionsToExport     = @('git-update', 'git-update-all', 'Get-GitUpdateVersion')
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @()

    PrivateData = @{
        PSData = @{
            Tags         = @('git', 'automation')
            # Newest first. List the file revisions shipped in each module version;
            # details live in each Public\*.ps1 file's .NOTES changelog.
            ReleaseNotes = @'
1.3.0 (2026-10-19) git-update 1.1.0, git-update-all 1.4.0, Get-GitUpdateVersion 1.0.1. git-update shows the model and token usage for AI commit messages; git-update-all prints a usage total at the end.
1.2.2 (2026-10-19) git-update 1.0.7, git-update-all 1.3.3, Get-GitUpdateVersion 1.0.1. git-update-all help now states its dependency on git-update.
1.2.1 (2026-10-19) git-update 1.0.7, git-update-all 1.3.2, Get-GitUpdateVersion 1.0.1. Get-Help -Online now opens the GitUpdate module folder on GitHub.
1.2.0 (2026-10-19) git-update 1.0.6, git-update-all 1.3.1, Get-GitUpdateVersion 1.0.0. Added Get-GitUpdateVersion to show the module version, function revisions, and release notes.
1.1.1 (2026-10-19) git-update 1.0.6, git-update-all 1.3.1. Added .LINK (Related Links) entries to the help.
1.1.0 (2026-10-19) git-update 1.0.5, git-update-all 1.3.0. git-update-all no longer hard-codes user paths; it resolves the allowlist under -ParentPath (default $githubpath) and shows info messages when the folder is missing.
1.0.0 (2026-10-19) Initial module. Contains git-update 1.0.5 and git-update-all 1.2.0.
'@
        }
    }
}
