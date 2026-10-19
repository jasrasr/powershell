# Filename: GitUpdate.psm1
# Loads every function file in Public\ and exports the public commands.
# Per-function revisions live in each file's .NOTES; the module version is in GitUpdate.psd1.

$publicFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1' -File -ErrorAction Stop

foreach ($file in $publicFiles) {
    . $file.FullName
}

Export-ModuleMember -Function 'git-update', 'git-update-all'
