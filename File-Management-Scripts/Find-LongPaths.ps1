# Find-LongPaths.ps1
# Finds all files with full paths exceeding 250 characters

$rootPath = 'D:\School Ministries Dropbox\School Ministries Dropbox\School Ministries Team Folder'
$threshold = 250

Write-Host "Scanning: $rootPath" -ForegroundColor Cyan
Write-Host "Threshold: $threshold characters`n"

$results = Get-ChildItem -Path $rootPath -Recurse -File -ErrorAction SilentlyContinue |
    Select-Object FullName, @{Name='PathLength'; Expression={ $_.FullName.Length }} |
    Where-Object { $_.PathLength -gt $threshold } |
    Sort-Object PathLength -Descending

if ($results.Count -eq 0) {
    Write-Host "No files found with paths longer than $threshold characters." -ForegroundColor Green
} else {
    Write-Host "Found $($results.Count) file(s) with paths longer than $threshold characters:`n" -ForegroundColor Yellow
    $results | Format-Table PathLength, FullName -AutoSize -Wrap
}

# Export to CSV
$csvPath = "$PSScriptRoot\LongPaths_Results.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "`nResults exported to: $csvPath" -ForegroundColor Cyan
