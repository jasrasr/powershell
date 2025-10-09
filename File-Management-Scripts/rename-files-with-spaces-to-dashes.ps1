$folderpaths = @(
    "$GitHubPath\PowerShell",
    "$GitHubPath\PowerShell-private"
)

foreach ($rootFolder in $folderpaths) {
 

Get-ChildItem -Path $rootFolder -Recurse -Force | ForEach-Object {
    if ($_.Name -match '\s') {
        $baseName = $_.Name -replace '\s', '-'
        $directory = $_.DirectoryName
        $targetPath = Join-Path $directory $baseName

        # If it's a file, split name and extension
        if (-not $_.PSIsContainer) {
            $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
            $ext = [System.IO.Path]::GetExtension($baseName)

            # Add -dup until it's unique
            while (Test-Path $targetPath) {
                $nameNoExt += "-dup"
                $baseName = "$nameNoExt$ext"
                $targetPath = Join-Path $directory $baseName
            }
        }
        else {
            # It's a folder
            while (Test-Path $targetPath) {
                $baseName += "-dup"
                $targetPath = Join-Path $directory $baseName
            }
        }

        try {
            Rename-Item -Path $_.FullName -NewName $baseName -Force
            Write-Host "Renamed: '$($_.FullName)' → '$targetPath'"
        }
        catch {
            Write-Warning "Failed to rename: '$($_.FullName)' → '$targetPath' - $($_.Exception.Message)"
        }
    }
}
}

# output example:
# Renamed: '$GitHubPath\PowerShell\Folder\file with spaces.ps1' → '$GitHubPath\PowerShell\Folder\file-with-spaces.ps1'