# Define the root folder to search
$rootFolder = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell"

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


# Define the root folder to search
$rootFolder = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell-private"

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
