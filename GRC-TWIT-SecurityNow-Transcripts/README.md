# GRC-TWIT-SecurityNow-Transcripts

Downloads TXT transcripts, PDF show notes, and JPG episode images from the [Security Now](https://www.grc.com/securitynow.htm) podcast hosted by Steve Gibson at GRC.com.

---

## Main Script

**`download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1`**

Run this script weekly (or on every new PowerShell session) to pick up any new episodes. It handles both fresh installs and ongoing updates automatically.

### How to Run

```powershell
# Option 1 - run directly
.\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1

# Option 2 - dot-source then run
. .\download-next-security-now-txt-transcriptions-and-pdf-show-notes-from-grc_com.ps1
```

> Requires the `$githubpath` environment variable to be set (e.g. `C:\Users\You\Documents\Github`). The script builds all paths from that variable.

---

## What It Does

The script downloads three file types for each episode, independently:

| Type | URL Pattern | Filename Pattern | Earliest Episode |
|------|------------|-----------------|-----------------|
| TXT transcript | `https://www.grc.com/sn/sn-NNN.txt` | `sn-001.txt` | Episode 1 |
| PDF show notes | `https://www.grc.com/sn/sn-NNN-notes.pdf` | `sn-432-notes.pdf` | Episode 432 |
| JPG episode image | `https://www.grc.com/sn/NNN.jpg` | `980.jpg` | Episode 980 |

Each file type runs its own independent loop and tracks its own progress. A file is skipped if it already exists on disk.

---

## Stop Logic

The script uses different behavior depending on whether it is in the known archive range or the new episode range:

| Episode Range | Behavior |
|---|---|
| Below episode 1070 | Never stops on failures — known archive, gaps are skipped and the loop keeps going |
| Episode 1070 and above | Stops after **2 consecutive failures** per file type — signals the edge of released episodes |

Each file type (TXT, PDF, JPG) stops independently. A failure on TXT does not stop PDF or JPG.

---

## Folder Structure

```
Downloads\
├── last-downloaded.json          <- Tracks the last successfully downloaded episode for each type
├── TXT-Transcriptions\
│   ├── sn-001.txt
│   ├── sn-002.txt
│   └── ...
├── PDF-Show-Notes\
│   ├── sn-432-notes.pdf
│   ├── sn-433-notes.pdf
│   └── ...
├── JPG-Episode-Images\
│   ├── 980.jpg
│   ├── 981.jpg
│   └── ...
└── Download-Logs\
    ├── download-log-20260101.txt
    └── ...
```

---

## Tracking File — `last-downloaded.json`

After each run the script saves the last successfully downloaded episode number for each file type:

```json
{
  "LastTXT": 1069,
  "LastPDF": 1070,
  "LastJPG": 1070
}
```

On the next run, it reads this file and resumes from `Last* + 1` for each type.

---

## Scenarios

### Fresh Install (No Files, No JSON)

1. Script creates all download folders automatically
2. No `last-downloaded.json` found — no files found on disk
3. Each type starts from its hardcoded starting point:
   - TXT: episode 001
   - PDF: episode 432
   - JPG: episode 980
4. All three loops run through every episode number without stopping on failures until reaching episode 1070
5. At episode 1070 and beyond, each type stops after 2 consecutive failures
6. `last-downloaded.json` is created with the last successful episode for each type
7. The log file for today is opened automatically when the run completes

### Continual Runs (Files and JSON Exist)

1. Script reads `last-downloaded.json`
2. Each type resumes from `Last* + 1` — already-downloaded files are skipped instantly
3. If already past episode 1070, the 2-consecutive-failure stop rule applies immediately
4. Any new episodes released since the last run are downloaded
5. `last-downloaded.json` is updated with the new last successful episode numbers

### Files Exist but No JSON (e.g. Files Copied to a New Computer)

1. No `last-downloaded.json` found
2. Script scans each folder for the highest existing episode number
3. Each type resumes from the highest file found + 1 — no re-downloading
4. Continues forward with the normal stop logic

---

## Other Scripts

| Script | Description |
|--------|-------------|
| `check-and-download-missing-pdf-files.ps1` | Checks for and downloads any missing PDF files |
| `check-download-pdf-txt-jpg.ps1` | Checks download status for all three file types |
| `check-for-missing-pdf-files.ps1` | Reports missing PDF files |
| `check-for-missing-txt-files.ps1` | Reports missing TXT files |
| `download-missing-pdf-files.ps1` | Downloads any missing PDF files |
| `download-missing-txt-files.ps1` | Downloads any missing TXT files |

---

## Tips

- Add the main script to your `$profile` so it runs automatically on every new PowerShell session and picks up new episodes as they are released.
- A separate run-once-daily wrapper is available at [run-once-daily.ps1](https://github.com/jasrasr/powershell/blob/main/Miscellaneous/run-once-daily.ps1) to avoid running more than once per day.
- The log file for each run is saved as `download-log-YYYYMMDD.txt` and opened automatically when the script finishes.
