# GRC Security Now! HTML Archive

This tool builds a searchable offline HTML viewer for Security Now! transcripts and show notes.

## Folders Used
- **Transcripts:** $onedrivepath\Downloads\GRC_SN_Files\Transcriptions
- **Show Notes:** $onedrivepath\Downloads\GRC_SN_Files\PDF Show Notes

## How to Add More Episodes
1. Add a new .txt transcript to the Transcripts folder.
2. Add the matching .pdf show notes file (using the same filename) to the PDF Show Notes folder (optional).
3. Run this script again.

## Tags
Tags are generated locally using keyword matching (simple AI-style logic). You can expand or modify the logic in the Get-AITags function as needed.

## Output
- **HTML Viewer:** grc_sn_searchable.html

