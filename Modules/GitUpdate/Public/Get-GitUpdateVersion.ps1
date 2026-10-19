<#
.SYNOPSIS
Shows the GitUpdate module version and the revision of each function in it.

.DESCRIPTION
Returns one row for the module (its ModuleVersion from GitUpdate.psd1) and one row for
each exported function (the Revision and Modified date from that function's .NOTES help
section). Use -ReleaseNotes to show the module's release notes instead.

.PARAMETER ReleaseNotes
Return the module's release notes text instead of the version table.

.EXAMPLE
Get-GitUpdateVersion
Show the module version and each function's revision.

.EXAMPLE
Get-GitUpdateVersion -ReleaseNotes
Show the module's release notes, newest first.

.LINK
https://github.com/jasrasr/powershell

.LINK
git-update

.LINK
git-update-all

.NOTES
Filename : Public\Get-GitUpdateVersion.ps1 (part of the GitUpdate module)
Revision : 1.0.0
Author   : Jason Lamb
Created  : 2026-10-19
Modified : 2026-10-19
Changelog:
  1.0.0 initial release
#>
function Get-GitUpdateVersion {
    [CmdletBinding()]
    param(
        [switch]$ReleaseNotes
    )

    $module = $MyInvocation.MyCommand.Module

    if ($ReleaseNotes) {
        return $module.PrivateData.PSData.ReleaseNotes
    }

    [pscustomobject]@{
        Name     = $module.Name
        Type     = 'Module'
        Version  = $module.Version.ToString()
        Modified = ''
    }

    foreach ($name in ($module.ExportedFunctions.Keys | Sort-Object)) {
        $notes    = (Get-Help $name -Full).alertSet.alert.Text
        $revision = [regex]::Match($notes, 'Revision\s*:\s*(\S+)').Groups[1].Value
        $modified = [regex]::Match($notes, 'Modified\s*:\s*(\S+)').Groups[1].Value

        [pscustomobject]@{
            Name     = $name
            Type     = 'Function'
            Version  = $revision
            Modified = $modified
        }
    }
}
