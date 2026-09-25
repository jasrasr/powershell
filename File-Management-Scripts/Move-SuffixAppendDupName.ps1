# Revision : 1.0
# Description : Move files to a destination folder and append a numeric suffix when a duplicate name exists
# Author : Jason Lamb
# Created Date : 2026-09-25
# Modified Date : 2026-09-25

$source      = 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Attachments\xerox scans\round 4\split-pdfs'
$destination = '.'

Get-ChildItem -LiteralPath $source -File | ForEach-Object {
    $destPath = Join-Path $destination $_.Name

    if (Test-Path -LiteralPath $destPath) {
        $baseName = $_.BaseName
        $ext      = $_.Extension
        $i = 1
        do {
            $newName  = "{0}_{1}{2}" -f $baseName, $i, $ext
            $destPath = Join-Path $destination $newName
            $i++
        } while (Test-Path -LiteralPath $destPath)
    }

    Move-Item -LiteralPath $_.FullName -Destination $destPath
}
