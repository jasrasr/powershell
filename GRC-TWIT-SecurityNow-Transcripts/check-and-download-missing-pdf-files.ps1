# Revision : 2.0
# Description : Combine local gap check for sn-###-notes.pdf and remote GRC download for any missing PDFs. Rev 2.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-10-09
# Modified Date : 2025-10-09

[CmdletBinding()]
param(
    [string]$FolderPath      = "$GitHubPath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\PDF-Show-Notes",
    [int]$StartNumber        = 595,
    [int]$EndNumber          = 1050,
    [string]$BaseUrl         = "https://www.grc.com/sn",
    [string]$LogFolder       = "C:\temp\powershell-exports",
    [switch]$OpenLogWhenDone
)

# Ensure folders
foreach ($p in @($FolderPath, $LogFolder)) {
    if (-not (Test-Path $p)) { New-Item -ItemType Directory -Path $p | Out-Null }
}

$TimeStamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$MissingLog = Join-Path $LogFolder "sn-missing-local-$TimeStamp.txt"
$ActionLog  = Join-Path $LogFolder "sn-pdf-check-download-$TimeStamp.log"
$UserAgent  = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) PowerShell/7 URLChecker"

Write-Host "Checking folder : $FolderPath" -ForegroundColor Cyan
Write-Host "Expected range : sn-$StartNumber-notes.pdf through sn-$EndNumber-notes.pdf" -ForegroundColor Yellow
Write-Host ""

# Build expected list
$expectedFiles = for ($i = $StartNumber; $i -le $EndNumber; $i++) { "sn-$i-notes.pdf" }

# Actual list
$actualFiles = Get-ChildItem -Path $FolderPath -Filter "sn-*-notes.pdf" -File -ErrorAction SilentlyContinue |
               Select-Object -ExpandProperty Name

# Determine local missing files
$missingFiles = $expectedFiles | Where-Object { $_ -notin $actualFiles }

if ($missingFiles.Count -eq 0) {
    Write-Host "✅ No gaps detected. All files from sn-$StartNumber to sn-$EndNumber are present." -ForegroundColor Green
    Write-Host "Nothing to download : local set is complete" -ForegroundColor Green
    return
}

Write-Host "⚠ Missing locally : " -ForegroundColor Red
$missingFiles | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }

# Save missing list
$missingFiles | Out-File -FilePath $MissingLog -Encoding utf8
Write-Host "Missing list saved to : $MissingLog" -ForegroundColor Gray
Write-Host ""

# --- Helper : URL existence check (HEAD with tiny GET fallback) ---
function Test-UrlExists {
    param([Parameter(Mandatory)][string]$Url)
    try {
        $resp = Invoke-WebRequest -Uri $Url -Method Head -Headers @{ 'User-Agent' = $UserAgent } -MaximumRedirection 5 -SkipHttpErrorCheck
        if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400) { return $true }
        if ($resp.StatusCode -in 405,501) {
            $headers = @{ 'Range' = 'bytes=0-0'; 'User-Agent' = $UserAgent }
            $resp2 = Invoke-WebRequest -Uri $Url -Method Get -Headers $headers -MaximumRedirection 5 -SkipHttpErrorCheck
            if ($resp2.StatusCode -ge 200 -and $resp2.StatusCode -lt 400) { return $true }
        }
        return $false
    } catch { return $false }
}

# Process each missing file: check remote, download if present
$foundRemote = 0
$notRemote   = 0
$downloaded  = 0

foreach ($file in $missingFiles) {
    $url = "$BaseUrl/$file"
    $out = Join-Path $FolderPath $file

    if (Test-UrlExists -Url $url) {
        $foundRemote++
        Write-Host "Remote exists : $url" -ForegroundColor Green
        try {
            Invoke-WebRequest -Uri $url -OutFile $out -Headers @{ 'User-Agent' = $UserAgent }
            $downloaded++
            Add-Content -Path $ActionLog -Value "[$(Get-Date -Format 'u')] DOWNLOADED : $url -> $out"
        }
        catch {
            Write-Host "Download failed : $url" -ForegroundColor Red
            Add-Content -Path $ActionLog -Value "[$(Get-Date -Format 'u')] DOWNLOAD-ERROR : $url : $_"
        }
    }
    else {
        $notRemote++
        Write-Host "Not found remote : $url" -ForegroundColor DarkYellow
        Add-Content -Path $ActionLog -Value "[$(Get-Date -Format 'u')] REMOTE-MISSING : $url"
    }
}

Write-Host ""
Write-Host "Summary : Local missing $($missingFiles.Count) | Remote available $foundRemote | Downloaded $downloaded | Remote missing $notRemote" -ForegroundColor Cyan
Write-Host "Logs saved to : $ActionLog" -ForegroundColor Gray

if ($OpenLogWhenDone) { Invoke-Item $ActionLog }
