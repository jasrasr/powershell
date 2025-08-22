# Revision : 1.0
# Description : Compare two directories and export results to CSV # Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-20
# Modified Date : 2025-08-20

param(
    [Parameter(Mandatory)][string]$Dir1,
    [Parameter(Mandatory)][string]$Dir2,
    [string]$OutputCsv = "C:\temp\powershell-exports\dir-compare-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
)

# Collect files from both directories (recursive, with size and last write time)
$files1 = Get-ChildItem -Path $Dir1 -Recurse -File | 
    Select-Object @{n='RelativePath';e={$_.FullName.Substring($Dir1.Length)}}, 
                  @{n='Size';e={$_.Length}}, 
                  @{n='LastWriteTime';e={$_.LastWriteTime}}, 
                  @{n='Source';e={'Dir1'}}

$files2 = Get-ChildItem -Path $Dir2 -Recurse -File | 
    Select-Object @{n='RelativePath';e={$_.FullName.Substring($Dir2.Length)}}, 
                  @{n='Size';e={$_.Length}}, 
                  @{n='LastWriteTime';e={$_.LastWriteTime}}, 
                  @{n='Source';e={'Dir2'}}

# Merge lists and group by relative path
$allFiles = $files1 + $files2
$results = $allFiles | Group-Object RelativePath | ForEach-Object {
    $group = $_.Group
    if ($group.Count -eq 1) {
        # File exists only in one directory
        [PSCustomObject]@{
            RelativePath = $_.Name
            Status       = "Only in $($group.Source)"
            Dir1_Size    = if ($group.Source -eq 'Dir1') { $group.Size } else { $null }
            Dir2_Size    = if ($group.Source -eq 'Dir2') { $group.Size } else { $null }
            Dir1_Date    = if ($group.Source -eq 'Dir1') { $group.LastWriteTime } else { $null }
            Dir2_Date    = if ($group.Source -eq 'Dir2') { $group.LastWriteTime } else { $null }
        }
    } else {
        # File exists in both directories
        $f1 = $group | Where-Object Source -eq 'Dir1'
        $f2 = $group | Where-Object Source -eq 'Dir2'
        $status = if ($f1.Size -ne $f2.Size -or $f1.LastWriteTime -ne $f2.LastWriteTime) { "Different" } else { "Same" }

        [PSCustomObject]@{
            RelativePath = $_.Name
            Status       = $status
            Dir1_Size    = $f1.Size
            Dir2_Size    = $f2.Size
            Dir1_Date    = $f1.LastWriteTime
            Dir2_Date    = $f2.LastWriteTime
        }
    }
}

# Export to CSV
$results | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8

Write-Host "Directory comparison complete. Results saved to : $OutputCsv"
