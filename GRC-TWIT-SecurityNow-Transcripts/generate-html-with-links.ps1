# Revision : 1.7
# Description : Split Export-MarkdownIndex from HTML export. Markdown index now only creates README.md, separate Export-HtmlIndex will handle HTML table layout
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-18
# Modified Date : 2025-08-18

function Export-MarkdownIndex {
    $global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
    $txtFolder = Join-Path $global:downloadbase 'TXT-Transcriptions'
    $pdfFolder = Join-Path $global:downloadbase 'PDF-Show-Notes'
    $outputPath = Join-Path $global:downloadbase 'README.md'

    $txtFiles = Get-ChildItem -Path $txtFolder -Filter 'sn-*.txt' | Where-Object { $_.Name -match 'sn-(\d+)\.txt' }
    $pdfFiles = Get-ChildItem -Path $pdfFolder -Filter 'sn-*-notes.pdf' | Where-Object { $_.Name -match 'sn-(\d+)-notes\.pdf' }

    $allEpisodes = @{}

    foreach ($txt in $txtFiles) {
        if ($txt.Name -match 'sn-(\d+)\.txt') {
            $ep = [int]$matches[1]
            if (-not $allEpisodes.ContainsKey($ep)) {
                $allEpisodes[$ep] = @{}
            }
            $allEpisodes[$ep].TXT = $txt.Name
        }
    }

    foreach ($pdf in $pdfFiles) {
        if ($pdf.Name -match 'sn-(\d+)-notes\.pdf') {
            $ep = [int]$matches[1]
            if (-not $allEpisodes.ContainsKey($ep)) {
                $allEpisodes[$ep] = @{}
            }
            $allEpisodes[$ep].PDF = $pdf.Name
        }
    }

    $sortedEpisodes = $allEpisodes.Keys | Sort-Object -Descending
    $grouped = $sortedEpisodes | Group-Object { [math]::Floor($_ / 100) * 100 }

    $md = @()
    $md += "# Security Now! Transcripts and Show Notes"
    $md += "Quick access to downloaded TXT and PDF files for each episode."
    $md += ""
    $md += "---"
    $md += ""

    foreach ($group in $grouped) {
        $range = "$($group.Name)-$($group.Name + 99)"
        $md += "## Episodes $range"

        foreach ($ep in $group.Group) {
            $epData = $allEpisodes[$ep]
            $txtLink = if ($epData.TXT) { "[TXT](TXT-Transcriptions/${epData.TXT})" } else { "" }
            $pdfLink = if ($epData.PDF) { "[PDF](PDF-Show-Notes/${epData.PDF})" } else { "" }
            $md += "- Episode $ep : $txtLink $pdfLink"
        }

        $md += ""
    }

    $generated = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $md += "---"
    $md += "Generated on $generated"
    $md | Set-Content -Path $outputPath -Encoding UTF8

    
}

function Export-HtmlIndex {
    $githubpath = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub"
    $global:downloadbase = "$githubpath\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads"
    $txtFolder = Join-Path $global:downloadbase 'TXT-Transcriptions'
    $pdfFolder = Join-Path $global:downloadbase 'PDF-Show-Notes'
    $outputPath = Join-Path $global:downloadbase 'index.html'

    $txtFiles = Get-ChildItem -Path $txtFolder -Filter 'sn-*.txt' | Where-Object { $_.Name -match 'sn-(\d+)\.txt' }
    $pdfFiles = Get-ChildItem -Path $pdfFolder -Filter 'sn-*-notes.pdf' | Where-Object { $_.Name -match 'sn-(\d+)-notes\.pdf' }

    $allEpisodes = @{}

    foreach ($txt in $txtFiles) {
        if ($txt.Name -match 'sn-(\d+)\.txt') {
            $ep = [int]$matches[1]
            if (-not $allEpisodes.ContainsKey($ep)) {
                $allEpisodes[$ep] = @{}
            }
            $allEpisodes[$ep].TXT = $txt.Name
        }
    }

    foreach ($pdf in $pdfFiles) {
        if ($pdf.Name -match 'sn-(\d+)-notes\.pdf') {
            $ep = [int]$matches[1]
            if (-not $allEpisodes.ContainsKey($ep)) {
                $allEpisodes[$ep] = @{}
            }
            $allEpisodes[$ep].PDF = $pdf.Name
        }
    }

    $sortedEpisodes = $allEpisodes.Keys | Sort-Object -Descending
    $grouped = $sortedEpisodes | Group-Object { [math]::Floor($_ / 100) * 100 }

    $html = @()
    $html += "<!DOCTYPE html>"
    $html += "<html>"
    $html += "<head>"
    $html += "    <meta charset='utf-8'>"
    $html += "    <meta name='viewport' content='width=device-width, initial-scale=1'>"
    $html += "    <title>Security Now Transcript Index</title>"
    $html += "    <style>"
    $html += "        body { font-family: Segoe UI, sans-serif; padding: 20px; }"
    $html += "        h1 { color: #2a5d84; }"
    $html += "        table { width: 100%; border-collapse: collapse; }"
    $html += "        th, td { border-bottom: 1px solid #ccc; padding: 8px; text-align: left; }"
    $html += "        a { text-decoration: none; color: #1d4e89; }"
    $html += "        a:hover { text-decoration: underline; }"
    $html += "        @media (max-width: 600px) { td, th { font-size: 14px; } }"
    $html += "    </style>"
    $html += "</head>"
    $html += "<body>"
    $html += "    <h1>Security Now Transcript Index</h1>"

    foreach ($group in $grouped) {
        $range = "$($group.Name)-$($group.Name + 99)"
        $html += "    <h2>Episodes $range</h2>"
        $html += "    <table>"
        $html += "        <tr><th>Episode</th><th>TXT</th><th>PDF</th></tr>"

        foreach ($ep in $group.Group) {
            $epData = $allEpisodes[$ep]
            $txtLink = if ($epData.TXT) { "<a href='TXT-Transcriptions/${epData.TXT}'>TXT</a>" } else { "" }
            $pdfLink = if ($epData.PDF) { "<a href='PDF-Show-Notes/${epData.PDF}'>PDF</a>" } else { "" }
            $html += "        <tr><td>$ep</td><td>$txtLink</td><td>$pdfLink</td></tr>"
        }

        $html += "    </table>"
    }

    $generated = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $html += "    <p>Generated on $generated</p>"
    $html += "</body>"
    $html += "</html>"

    $html | Set-Content -Path $outputPath -Encoding UTF8

}
Write-Host "Markdown index exported to : $outputPath" -ForegroundColor Green
Write-Host "HTML index exported to : $outputPath" -ForegroundColor Cyan