# Revision : 1.0
# Description : Check for missing PDF show notes (sn-###-notes.pdf) on GRC site and download any that exist. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

# --- Config ---
$DownloadFolder = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\PDF-Show-Notes"
$LogFolder      = "C:\temp\powershell-exports"
$UserAgent      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) PowerShell/7 URLChecker"

# Create folders if needed
foreach ($p in @($DownloadFolder, $LogFolder)) {
    if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p | Out-Null }
}

$TimeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$LogFile   = Join-Path $LogFolder "sn-pdf-url-check-$TimeStamp.log"

# --- Input URLs ---
$pdfFiles = @(
    'https://www.grc.com/sn/sn-643-notes.pdf',
    'https://www.grc.com/sn/sn-747-notes.pdf',
    'https://www.grc.com/sn/sn-851-notes.pdf',
    'https://www.grc.com/sn/sn-954-notes.pdf',
    'https://www.grc.com/sn/sn-1006-notes.pdf',
    'https://www.grc.com/sn/sn-1044-notes.pdf',
    'https://www.grc.com/sn/sn-1045-notes.pdf',
    'https://www.grc.com/sn/sn-1046-notes.pdf',
    'https://www.grc.com/sn/sn-1047-notes.pdf',
    'https://www.grc.com/sn/sn-1048-notes.pdf',
    'https://www.grc.com/sn/sn-1049-notes.pdf',
    'https://www.grc.com/sn/sn-1050-notes.pdf'
)

# --- Helper : HEAD check with fallback to tiny GET ---
function Test-UrlExists {
    param(
        [Parameter(Mandatory)]
        [string]$Url
    )
    try {
        # Try HEAD first
        $resp = Invoke-WebRequest -Uri $Url -Method Head -Headers @{ 'User-Agent' = $UserAgent } -MaximumRedirection 5 -SkipHttpErrorCheck
        if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400) { return $true }
        if ($resp.StatusCode -eq 405 -or $resp.StatusCode -eq 501) {
            # HEAD not allowed → fallback to lightweight GET
            $headers = @{ 'Range' = 'bytes=0-0'; 'User-Agent' = $UserAgent }
            $resp2 = Invoke-WebRequest -Uri $Url -Method Get -Headers $headers -MaximumRedirection 5 -SkipHttpErrorCheck
            if ($resp2.StatusCode -ge 200 -and $resp2.StatusCode -lt 400) { return $true }
        }
        return $false
    }
    catch {
        return $false
    }
}

# --- Process ---
$found = 0
$missing = 0
$downloaded = 0

foreach ($pdf in $pdfFiles) {
    $fileName = ($pdf -split '/') | Select-Object -Last 1
    $output   = Join-Path $DownloadFolder $fileName

    if (Test-UrlExists -Url $pdf) {
        $found++
        Write-Host "File exists : $pdf" -ForegroundColor Green
        try {
            Invoke-WebRequest -Uri $pdf -OutFile $output -Headers @{ 'User-Agent' = $UserAgent }
            $downloaded++
            Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'u')] DOWNLOADED : $pdf -> $output"
        }
        catch {
            Write-Host "Download failed : $pdf" -ForegroundColor Red
            Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'u')] DOWNLOAD-ERROR : $pdf : $_"
        }
    }
    else {
        $missing++
        Write-Host "File does not exist : $pdf" -ForegroundColor Yellow
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'u')] MISSING : $pdf"
    }
}

Write-Host ""
Write-Host "Summary : Found $found, Missing $missing, Downloaded $downloaded" -ForegroundColor Cyan
Write-Host "Log path : $LogFile" -ForegroundColor Gray
Invoke-Item $LogFile
