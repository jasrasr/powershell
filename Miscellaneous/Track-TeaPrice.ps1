# Filename: Track-TeaPrice.ps1
# Revision : 1.0
# Description : Logs a tea price to CSV on each run and warns when it moves past a threshold. Pulls from a web page by regex, or accepts a manual price.
# Author : Jason Lamb (with help from Claude)
# Created Date : 2026-10-06
# Modified Date : 2026-10-06
# Changelog :
#   1.0 initial release

[CmdletBinding()]
param(
    # Page to read the price from. Default is the Trading Economics tea page.
    # NOTE: that page tracks Indian CTC tea (INR/Kg), NOT China. Point -Url and -Pattern
    # at a China-specific source (or use -ManualPrice) if you need China pricing.
    [string]$Url = 'https://tradingeconomics.com/commodity/tea',

    # Regex with ONE capture group around the number. First match in the page text wins.
    [string]$Pattern = '([0-9][0-9,]*\.?[0-9]*)\s*INR/Kgs',

    [string]$Currency = 'INR',
    [string]$Unit = 'Kg',
    [string]$SourceName = 'TradingEconomics-Tea (India CTC)',

    # Skip the web request and log a price you looked up yourself.
    [double]$ManualPrice,

    # Warn when the change vs the previous logged price is at least this many percent.
    [double]$AlertPercent = 2.0,

    # Show what would be logged without writing the CSV.
    [switch]$TestOnly
)

$ErrorActionPreference = 'Stop'

# Export path: use $PSExports from profile if set, otherwise fall back to Documents
if (-not $PSExports) { $PSExports = Join-Path $env:USERPROFILE 'Documents\PSExports' }
if (-not (Test-Path $PSExports)) { New-Item -ItemType Directory -Path $PSExports -Force | Out-Null }
$LogPath = Join-Path $PSExports 'TeaPriceLog.csv'

# All-hyphen timestamp (filename safe)
$stamp = Get-Date -Format 'yyyy-MM-dd-HH-mm-ss'

# --- Get the price ---
if ($PSBoundParameters.ContainsKey('ManualPrice')) {
    $price = $ManualPrice
    $SourceName = 'Manual entry'
}
else {
    $headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) TeaPriceTracker/1.0' }
    try {
        $response = Invoke-WebRequest -Uri $Url -Headers $headers -UseBasicParsing -TimeoutSec 30
    }
    catch {
        throw ('Request to ' + $Url + ' failed. The site may block scripted requests. Details: ' + $_.Exception.Message)
    }
    # Strip tags so the regex runs against readable text
    $text = [regex]::Replace($response.Content, '<[^>]+>', ' ')
    $m = [regex]::Match($text, $Pattern)
    if (-not $m.Success) {
        throw 'Pattern did not match anything on the page. The layout may have changed. Check -Pattern before trusting any data.'
    }
    $price = [double]($m.Groups[1].Value -replace ',', '')
}

# --- Compare to previous entry ---
$previous = $null
if (Test-Path $LogPath) {
    $previous = Import-Csv $LogPath | Select-Object -Last 1
}

$changePct = $null
if ($previous -and [double]$previous.Price -ne 0) {
    $changePct = [math]::Round((($price - [double]$previous.Price) / [double]$previous.Price) * 100, 2)
}

$row = [pscustomobject]@{
    Timestamp = $stamp
    Source    = $SourceName
    Price     = $price
    Currency  = $Currency
    Unit      = $Unit
    ChangePct = $changePct
}

if ($TestOnly) {
    Write-Host 'TEST ONLY - nothing written.' -ForegroundColor Yellow
    $row | Format-List
}
else {
    $row | Export-Csv -Path $LogPath -Append -NoTypeInformation
    Write-Host ('Logged ' + $price + ' ' + $Currency + '/' + $Unit + ' to ' + $LogPath) -ForegroundColor Green
}

# --- Alert ---
if ($null -ne $changePct -and [math]::Abs($changePct) -ge $AlertPercent) {
    $dir = if ($changePct -gt 0) { 'UP' } else { 'DOWN' }
    Write-Warning ('Tea price is ' + $dir + ' ' + [math]::Abs($changePct) + '% since the last entry (' + $previous.Price + ' to ' + $price + ').')
}

# Example usage:
#   .\Track-TeaPrice.ps1 -TestOnly
#   .\Track-TeaPrice.ps1
#   .\Track-TeaPrice.ps1 -ManualPrice 85.5 -Currency CNY -Unit 500g -AlertPercent 5
#   .\Track-TeaPrice.ps1 -Url 'https://example.com/china-tea' -Pattern '¥\s*([0-9.]+)' -Currency CNY