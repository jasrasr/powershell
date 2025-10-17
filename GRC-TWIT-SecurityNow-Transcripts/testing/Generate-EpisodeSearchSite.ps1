# generate-episodesearchsite.ps1

# Directories for transcripts and PDF show notes
$TranscriptsDir = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\TXT-Transcriptions"
$PdfNotesDir    = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\PDF-Show-Notes"

# Output folders and files
$OutputFolder   = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\testing\Output\101625"
$EpisodesJsonDir = Join-Path $OutputFolder 'episodes'
$IndexJsonFile  = Join-Path $OutputFolder 'index.json'
$OutputHtml     = Join-Path $OutputFolder 'grc_sn_searchable.html'
$ReadmeFile     = Join-Path $OutputFolder 'README.md'

# Ensure output folders exist
New-Item -ItemType Directory -Force -Path $OutputFolder, $EpisodesJsonDir | Out-Null

#########################################
# Function: Get-AITags
# Uses simple keyword matching to produce tags.
function Get-AITags {
    param ([string]$Text)
    $tags = @()
    $textLower = $Text.ToLower()
    if ($textLower -match 'rsa') { $tags += 'RSA' }
    if ($textLower -match 'quantum') { $tags += 'Quantum Computing' }
    if ($textLower -match 'drone') { $tags += 'Drones' }
    if ($textLower -match 'credential exchange') { $tags += 'Credential Exchange Protocol' }
    if ($textLower -match 'deepfake') { $tags += 'Deepfake' }
    return $tags
}

#########################################
# Function: Process each transcript into its own JSON file.
function Process-Episodes {
    $indexList = @()

    Get-ChildItem -Path $TranscriptsDir -Filter *.txt | Sort-Object Name | ForEach-Object {
        $baseName = $_.BaseName
        $transcriptPath = $_.FullName
        $pdfPath = Join-Path $PdfNotesDir ($baseName + '.pdf')
        $hasPdf = Test-Path $pdfPath

        $content = Get-Content $transcriptPath -Raw
        $tags = Get-AITags -Text $content

        # Create a preview: first 1000 characters (if content is shorter, use full)
        $preview = $content.Substring(0, [Math]::Min(1000, $content.Length)) + '...'

        # Build an object for the episode
        $epData = [PSCustomObject]@{
            Title       = "Episode $baseName"
            Transcript  = $transcriptPath
            NotesPdf    = if ($hasPdf) { $pdfPath } else { $null }
            Tags        = $tags
            Preview     = $preview
            FullContent = $content
        }

        # Save the full episode data to its own JSON file in the EpisodesJsonDir
        $jsonFilename = "$baseName.json"
        $jsonFilePath = Join-Path $EpisodesJsonDir $jsonFilename
        $epData | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFilePath -Encoding UTF8

        # Add metadata for the index JSON (only preview, title, tags, and reference to JSON file)
        $indexList += [PSCustomObject]@{
            Title      = $epData.Title
            Preview    = $epData.Preview
            Tags       = $epData.Tags
            JsonFile   = "episodes/$jsonFilename"
        }
    }

    # Save the index JSON
    $indexList | ConvertTo-Json -Depth 5 | Out-File -FilePath $IndexJsonFile -Encoding UTF8

    return $indexList
}

#########################################
# Function: Generate searchable HTML file.
function Generate-HTML {
    # The HTML page will load index.json via fetch.
    $html = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset='UTF-8'>
  <title>Security Now! Archive</title>
  <style>
    body { font-family: sans-serif; padding: 20px; }
    .episode { border: 1px solid #ccc; padding: 10px; margin: 10px 0; }
    .fullTranscript { display: none; white-space: pre-wrap; margin-top: 10px; }
    button { margin-top: 5px; }
    input[type=text] { width: 100%; padding: 8px; margin-bottom: 20px; font-size: 16px; }
  </style>
</head>
<body>
  <h1>Security Now! Episodes Archive</h1>
  <input type='text' id='searchBox' onkeyup='searchEpisodes()' placeholder='Search transcripts or tags...'>
  <div id='episodesContainer'></div>

  <script>
    // Fetch the index JSON and render episode previews
    fetch('index.json')
      .then(response => response.json())
      .then(data => {
        window.episodesIndex = data;
        renderEpisodes(data);
      })
      .catch(err => console.error('Error loading index.json:', err));

    function renderEpisodes(episodes) {
      const container = document.getElementById('episodesContainer');
      container.innerHTML = '';
      episodes.forEach((ep, index) => {
        const epDiv = document.createElement('div');
        epDiv.className = 'episode';
        epDiv.setAttribute('data-tags', ep.Tags.join(','));
        epDiv.setAttribute('data-preview', ep.Preview.toLowerCase());
        epDiv.innerHTML = `
          <h2>${ep.Title}</h2>
          <p>${ep.Preview}</p>
          <p>Tags: ${ep.Tags.join(', ')}</p>
          $`{ ep.JsonFile ? `<button onclick="loadFull(${index})" id="btn_${index}">Show Full Transcript</button>` : '' }
          <div class="fullTranscript" id="full_${index}"></div>
          $`{ ep.JsonFile && ep.NotesPdf ? `<p><a href="${ep.NotesPdf}">PDF Show Notes</a></p>` : '' }
        `;
        container.appendChild(epDiv);
      });
    }

    function searchEpisodes() {
      const query = document.getElementById('searchBox').value.toLowerCase();
      const episodes = document.getElementsByClassName('episode');
      for (let i = 0; i < episodes.length; i++) {
        const preview = episodes[i].getAttribute('data-preview');
        const tags = episodes[i].getAttribute('data-tags').toLowerCase();
        episodes[i].style.display = (preview.includes(query) || tags.includes(query)) ? 'block' : 'none';
      }
    }

    function loadFull(index) {
      const ep = window.episodesIndex[index];
      const fullDiv = document.getElementById('full_' + index);
      const btn = document.getElementById('btn_' + index);
      
      // Check if full text is already loaded
      if (fullDiv.innerHTML) {
        // Toggle visibility
        if (fullDiv.style.display === 'none' || fullDiv.style.display === '') {
          fullDiv.style.display = 'block';
          btn.innerText = 'Hide Full Transcript';
        } else {
          fullDiv.style.display = 'none';
          btn.innerText = 'Show Full Transcript';
        }
        return;
      }
      
      // Otherwise, fetch the individual JSON file
      fetch(ep.JsonFile)
        .then(response => response.json())
        .then(data => {
          fullDiv.innerHTML = data.FullContent.replace(/\r?\n/g, '<br/>');
          fullDiv.style.display = 'block';
          btn.innerText = 'Hide Full Transcript';
        })
        .catch(err => {
          console.error('Error loading episode JSON:', err);
          fullDiv.innerHTML = 'Error loading transcript.';
        });
    }
  </script>
</body>
</html>
"@

    Set-Content -Path $OutputHtml -Value $html -Encoding UTF8
}

#########################################
# Function: Generate README.md with instructions.
function Generate-Readme {
    $readmeContent = @"
# GRC Security Now! HTML Archive

This tool builds a searchable offline HTML viewer for Security Now! transcripts and show notes.

## Folders Used
- **Transcripts:** $TranscriptsDir
- **Show Notes:** $PdfNotesDir
- **Generated Episodes JSON:** $EpisodesJsonDir

## How to Add More Episodes
1. Add a new `.txt` transcript to the Transcripts folder.
2. Add the matching `.pdf` show notes file (using the same filename) to the PDF Show Notes folder (optional).
3. Run this script again to update the archive.

## Tags
Tags are generated locally using keyword matching (simple AI-style logic). You can modify the logic in the `Get-AITags` function as needed.

## Output
- **Index JSON:** $IndexJsonFile
- **HTML Viewer:** $OutputHtml

**Note:** To load full transcripts, the HTML uses the Fetch API to load each episode's JSON file separately. For best results, run this HTML file from a local server.
"@
    Set-Content -Path $ReadmeFile -Value $readmeContent -Encoding UTF8
}

#########################################
# Main Execution
$indexData = Process-Episodes
Generate-HTML -Episodes $indexData
Generate-Readme

Write-Host "`n✅ Archive updated!`n- Index JSON saved to: $IndexJsonFile`n- HTML Viewer saved to: $OutputHtml`n- README saved to: $ReadmeFile"
