# Requires: PowerShell 7+, optional: pdftotext.exe or similar to extract PDF text

$TranscriptFolder = "$onedrivepath\Downloads\GRC_SN_Files\Transcriptions"
$JsonOutputFolder = "$TranscriptFolder\data"
$IndexFile = "$JsonOutputFolder\index.json"

# Optional: function to extract tags using OpenAI (or simulate locally)
function Get-TagsFromText {
    param ($text, $maxTags = 10)

    # Simulated tags for now – replace with AI API if needed
    $keywords = @()
    if ($text -match "FIDO") { $keywords += "FIDO" }
    if ($text -match "RSA") { $keywords += "Encryption" }
    if ($text -match "Microsoft") { $keywords += "Microsoft" }
    if ($text -match "Passkeys") { $keywords += "Passkeys" }
    if ($text -match "Security") { $keywords += "Security" }
    if ($text -match "Quantum") { $keywords += "Quantum" }

    return $keywords | Select-Object -First $maxTags
}

# Ensure output folder exists
New-Item -ItemType Directory -Force -Path $JsonOutputFolder | Out-Null
$episodeList = @()

# Loop through all transcripts
Get-ChildItem "$TranscriptFolder\*.txt" | ForEach-Object {
    $file = $_.FullName
    $text = Get-Content $file -Raw

    # Try to parse metadata from header
    $episode = @{
        file_name     = $_.Name
        episode_number = if ($text -match 'EPISODE:\s+#(\d+)') { $matches[1] } else { $null }
        title          = if ($text -match 'TITLE:\s+(.+)') { $matches[1] } else { $null }
        date           = if ($text -match 'DATE:\s+(.+)') { $matches[1] } else { $null }
        participants   = if ($text -match 'HOSTS?:\s+(.+)') { $matches[1] } else { $null }
        full_text      = $text
        tags           = Get-TagsFromText -text $text
        show_notes     = $null
    }
    
    

    # Optional: Check for matching PDF show notes (same name with .pdf)
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $pdfPath = "$TranscriptFolder\$baseName-notes.pdf"
    if (Test-Path $pdfPath) {
        try {
            $notesText = & 'pdftotext.exe' -layout -nopgbrk -q $pdfPath - 2>$null
            if ($notesText) {
                $episode.show_notes = $notesText.Trim()
            }
        } catch {
            Write-Warning "Could not extract PDF notes from $pdfPath"
        }
    }

    # Save individual JSON file
    $jsonFile = "$JsonOutputFolder\$($baseName).json"
    $episode | ConvertTo-Json -Depth 10 | Set-Content $jsonFile -Encoding UTF8

    # Add to global index
    $episodeList += [PSCustomObject]@{
        episode_number = $episode.episode_number
        title          = $episode.title
        date           = $episode.date
        tags           = $episode.tags
        file           = "$($baseName).json"
    }
}

# Save index.json
$episodeList | ConvertTo-Json -Depth 5 | Set-Content $IndexFile -Encoding UTF8
Write-Host "Done! JSON files saved to $JsonOutputFolder"
