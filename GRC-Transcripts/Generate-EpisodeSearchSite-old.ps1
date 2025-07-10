
# Load the AI tagging helper
. ".\Get-TagsFromText.ps1"

# Set input and output paths
$TranscriptFolder = "$onedrivepath\Downloads\GRC_SN_Files\Transcriptions"
$OutputFolder = ".\TranscriptSite"
$JsonFolder = "$OutputFolder\episodes"
$htmlFile = "$OutputFolder\index.html"

# Ensure output folders exist
New-Item -ItemType Directory -Force -Path $OutputFolder, $JsonFolder | Out-Null

# Load episode summaries if you have them
$EpisodeSummaries = @{}
$summaryFiles = Get-ChildItem "$TranscriptFolder\*.pdf"
foreach ($pdf in $summaryFiles) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($pdf.Name)
    $EpisodeSummaries[$baseName] = $pdf.FullName
}

# Template array for episode data
$episodes = @()

# Process each transcript
Get-ChildItem "$TranscriptFolder\*.txt" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $filename = $_.BaseName
    $tags = Get-TagsFromText -text $content

    # Create JSON for this episode
    $episodeJson = [PSCustomObject]@{
        id        = $filename
        title     = "Security Now! - $filename"
        content   = $content
        tags      = $tags
        summary   = if ($EpisodeSummaries[$filename]) { "Linked PDF: $($EpisodeSummaries[$filename])" } else { "" }
    }

    # Save per-episode JSON
    $jsonPath = Join-Path $JsonFolder "$filename.json"
    $episodeJson | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath -Encoding UTF8

    $episodes += $episodeJson
}

# Generate a searchable HTML file
@"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Security Now! Search</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        input { padding: 8px; width: 100%; font-size: 16px; margin-bottom: 10px; }
        .episode { margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .tags { font-size: 12px; color: #555; margin-top: 5px; }
    </style>
</head>
<body>
    <h1>Search Security Now! Transcripts</h1>
    <input type="text" id="searchBox" placeholder="Search by text or tag...">

    <div id="results"></div>

    <script>
        const episodes = $(@($episodes | ConvertTo-Json -Depth 10))

        function render(episodesToShow) {
            const container = document.getElementById("results");
            container.innerHTML = '';
            episodesToShow.forEach(e => {
                const div = document.createElement("div");
                div.className = "episode";
                div.innerHTML = \`
                    <strong>\${e.title}</strong><br>
                    <div class="tags">Tags: \${e.tags.join(', ')}</div>
                    <p>\${e.content.slice(0, 400)}...</p>
                \`;
                container.appendChild(div);
            });
        }

        document.getElementById("searchBox").addEventListener("input", function() {
            const val = this.value.toLowerCase();
            const filtered = episodes.filter(e =>
                e.content.toLowerCase().includes(val) ||
                e.tags.some(tag => tag.toLowerCase().includes(val))
            );
            render(filtered);
        });

        render(episodes);
    </script>
</body>
</html>
"@ | Set-Content -Path $htmlFile -Encoding UTF8
