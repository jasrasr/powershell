Get-ChildItem -Path C:\ -Recurse -File | 
    Sort-Object -Property Length -Descending | 
    Select-Object -First 10 FullName, Length


try {
    # Display a message indicating the start of the search
    Write-Host "Searching for the top 10 largest files on C: drive..." -ForegroundColor Green

    # Find and display the top 10 largest files
    Get-ChildItem -Path C:\ -Recurse -File -ErrorAction Stop | 
        Sort-Object -Property Length -Descending | 
        Select-Object -First 10 FullName, Length

    Write-Host "Search completed successfully." -ForegroundColor Green
}
catch {
    # Report any errors that occurred during the search
    Write-Host "An error occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
