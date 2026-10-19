@{
    RootModule            = 'GitUpdate.psm1'
    ModuleVersion         = '1.0.0'
    GUID                  = 'b6f0c1f4-5a1e-4c7e-9a3d-2f8e6d1c4a57'
    Author                = 'Jason Lamb'
    CompanyName           = 'Cooper Machinery Services'
    Description           = 'git-update (pull/add/commit/push with optional AI commit message) and git-update-all (runs git-update across the approved repository allowlist).'
    PowerShellVersion     = '5.1'
    CompatiblePSEditions  = @('Desktop', 'Core')
    FunctionsToExport     = @('git-update', 'git-update-all')
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @()

    PrivateData = @{
        PSData = @{
            Tags         = @('git', 'automation')
            # Newest first. List the file revisions shipped in each module version;
            # details live in each Public\*.ps1 file's .NOTES changelog.
            ReleaseNotes = @'
1.0.0 (2026-10-19) Initial module. Contains git-update 1.0.5 and git-update-all 1.2.0.
'@
        }
    }
}
