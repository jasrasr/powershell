# GRC Security Now! HTML Archive

This tool builds a searchable offline HTML viewer for Security Now! transcripts and show notes.

## Folders Used
- **Transcripts:** C:\users\jason.lamb\OneDrive - middough\documents\github\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\TXT-Transcriptions
- **Show Notes:** C:\users\jason.lamb\OneDrive - middough\documents\github\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\PDF-Show-Notes
- **Generated Episodes JSON:** C:\users\jason.lamb\OneDrive - middough\documents\github\PowerShell\GRC-TWIT-SecurityNow-Transcripts\testing\Output\101625\episodes

## How to Add More Episodes
1. Add a new .txt transcript to the Transcripts folder.
2. Add the matching .pdf show notes file (using the same filename) to the PDF Show Notes folder (optional).
3. Run this script again to update the archive.

## Tags
Tags are generated locally using keyword matching (simple AI-style logic). You can modify the logic in the Get-AITags function as needed.

## Output
- **Index JSON:** C:\users\jason.lamb\OneDrive - middough\documents\github\PowerShell\GRC-TWIT-SecurityNow-Transcripts\testing\Output\101625\index.json
- **HTML Viewer:** C:\users\jason.lamb\OneDrive - middough\documents\github\PowerShell\GRC-TWIT-SecurityNow-Transcripts\testing\Output\101625\grc_sn_searchable.html

**Note:** To load full transcripts, the HTML uses the Fetch API to load each episode's JSON file separately. For best results, run this HTML file from a local server.
