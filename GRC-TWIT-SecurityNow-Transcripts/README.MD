# GRC Transcripts and Show Notes Download
This project is underway to download the transcripts and show notes. That is working using 'download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1' with a dynamic counter '/downloads/last-downloaded.json'. The download will attempt download until two failures in sequence. If the 'last-downloaded.json' has 

{
  "LastPDF": 1039,
  "LastTXT": 1038
}

then the next attempt download will be sn-1040-notes.pdf and sn-1040.txt. The script will attempt to download in sequence until 2 failures and will update the json file with the last successsful download.

### Folders Used
- **Transcripts:** $onedrivepath\Downloads\GRC_SN_Files\Transcriptions
-- change this to fit your needs
- **Show Notes:** $onedrivepath\Downloads\GRC_SN_Files\PDF Show Notes
-- change this to fit your needs

If you are starting without any downloaded PDFs or Transcripts then delete the 'download-log-20250922.txt' file. It will be created on the fly and updated as needed with every run of the script. 

I have added this script to my $profile so every time I run a new PowerShell session it runs to check for any new episodes. I also added a script that only checks one a day. YOu can find that located here: [run-once-daily.ps1](https://github.com/jasrasr/powershell/blob/main/Miscellaneous/run-once-daily.ps1
)
