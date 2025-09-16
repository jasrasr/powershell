$filestodelete = @(
    '\\server\share\path\to\file1.txt',
    '\\server\share\path\to\file2.txt',
    '\\server\share\path\to\file3.txt' 
)

foreach ($file in $filestodelete) {
    if (Test-Path -Path $file) {
        Remove-Item -Path $file -Force
        Write-Host "Deleted file: $file"
    } else {
        Write-Host "File not found: $file"
    }
}