$TranscriptFolder = "$onedrivepath\Downloads\GRC_SN_Files\Transcriptions"
$OutputCSV = "$TranscriptFolder\transcript-index.csv"

# Create empty array for index
$IndexData = @()

# Loop through all .txt files
Get-ChildItem -Path $TranscriptFolder -Filter "*.txt" | Sort-Object Name | ForEach-Object {
    $File = $_.FullName
    $Content = Get-Content -Path $File -Raw

    # Extract Metadata
    $Episode = ($Content -match "EPISODE:\s+#(\d+)") ? $Matches[1] : ""
    $Date    = ($Content -match "DATE:\s+(.+?)\r?\n") ? $Matches[1].Trim() : ""
    $Title   = ($Content -match "TITLE:\s+(.+?)\r?\n") ? $Matches[1].Trim() : ""
    $Desc    = ($Content -match "DESCRIPTION:\s+(.+?)\r?\n") ? $Matches[1].Trim() : ""

    # Add to array
    $IndexData += [PSCustomObject]@{
        Episode = $Episode
        Date    = $Date
        Title   = $Title
        Description = $Desc
        FileName = $_.Name
    }
}

# Export as CSV
$IndexData | Export-Csv -Path $OutputCSV -NoTypeInformation -Encoding UTF8

Write-Host "Index completed. Output saved to: $OutputCSV"
