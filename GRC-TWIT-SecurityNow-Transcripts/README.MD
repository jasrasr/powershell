# GRC Transcripts and Show Notes Download
This project is underway to download the transcripts and show notes. That is working using 'download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1' with a dynamic counter '/downloads/last-downloaded.json'. The download will attempt download until two failures in sequence. If the 'last-downloaded.json' has 

{
  "LastPDF": 1039,
  "LastTXT": 1038
}

then the next attempt download will be sn-1040-notes.pdf and sn-1040.txt. The script will attempt to download in sequence until 2 failures and will update the json file with the last successsful download.

The below section is still in testing.

## GRC Security Now! HTML Archive

This tool builds a searchable offline HTML viewer for Security Now! transcripts and show notes.

### Folders Used
- **Transcripts:** $onedrivepath\Downloads\GRC_SN_Files\Transcriptions
- **Show Notes:** $onedrivepath\Downloads\GRC_SN_Files\PDF Show Notes

### How to Add More Episodes
1. Add a new .txt transcript to the Transcripts folder.
2. Add the matching .pdf show notes file (using the same filename) to the PDF Show Notes folder (optional).
3. Run this script again.

### Tags
Tags are generated locally using keyword matching (simple AI-style logic). You can expand or modify the logic in the Get-AITags function as needed.

### Output
- **HTML Viewer:** grc_sn_searchable.html

