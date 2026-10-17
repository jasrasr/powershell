[CmdletBinding()]
param(
    [string]$WebsitePath = 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\website',
    [string]$Branch = 'review-fix-ios-sound',
    [int]$Port = 0,
    [string]$Page = '',
    [ValidateSet('Auto', 'Static', 'Php')]
    [string]$ServerType = 'Auto'
)

<#
.SYNOPSIS
    Starts a local static or PHP website for testing from a mobile device.

.NOTES
    Both the PC and mobile device must be connected to the same Wi-Fi/network.
    Windows Firewall may ask for permission the first time Python listens on the port.
    Keep this window open while testing. Press Ctrl+C to stop the server.

    Static sites use Python's HTTP server. PHP sites use PHP's built-in server so
    PHP files execute instead of being served as source text. Use -ServerType to
    override automatic selection.

    Manual static equivalent:
        git -C 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\website' fetch origin
        git -C 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\website' switch review-fix-ios-sound
        py -m http.server <RANDOM-PORT> --bind 0.0.0.0 --directory 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github\website'

    On the PC, find the address shown below. Then on iOS Chrome, open:
        http://YOUR-PC-IP:<RANDOM-PORT>/<OPTIONAL-FILE>
#>

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $WebsitePath -PathType Container)) {
    throw "Website directory was not found: $WebsitePath"
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git was not found on PATH.'
}

if (-not (Get-Command py -ErrorAction SilentlyContinue)) {
    throw 'The Python launcher (py) was not found on PATH.'
}

if ($Port -eq 0) {
    do {
        # Use the full non-system range. Get-Random's maximum is exclusive.
        $Port = Get-Random -Minimum 1024 -Maximum 65536
        $portInUse = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    } while ($portInUse)
}

if ($Port -lt 1 -or $Port -gt 65535) {
    throw 'Port must be between 1 and 65535, or 0 to select a random port.'
}

$selectedServerType = $ServerType
if ($selectedServerType -eq 'Auto') {
    $phpTarget = if ([string]::IsNullOrWhiteSpace($Page)) {
        Join-Path $WebsitePath 'index.php'
    } else {
        Join-Path $WebsitePath ($Page.TrimStart('/'))
    }
    $selectedServerType = if ($Page -match '(?i)\.php(?:/|$)' -or (Test-Path -LiteralPath $phpTarget -PathType Leaf)) { 'Php' } else { 'Static' }
}

if ($selectedServerType -eq 'Php' -and -not (Get-Command php -ErrorAction SilentlyContinue)) {
    throw 'PHP was not found on PATH. Install PHP or use -ServerType Static for non-PHP files.'
}

Write-Host "Fetching origin and switching to '$Branch'..." -ForegroundColor Cyan
git -C $WebsitePath fetch origin
if ($LASTEXITCODE -ne 0) { throw 'git fetch failed.' }

git -C $WebsitePath switch $Branch
if ($LASTEXITCODE -ne 0) { throw "Could not switch to branch '$Branch'." }

$addresses = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
    Where-Object {
        $_.IPAddress -notlike '127.*' -and
        $_.IPAddress -notlike '169.254.*'
    } |
    Select-Object IPAddress, InterfaceAlias)

if ($addresses.Count -eq 0) {
    Write-Warning 'No non-loopback IPv4 address was found. Connect the PC to Wi-Fi or a network and try again.'
} else {
    Write-Host "`nUse one of these PC addresses from the mobile device:" -ForegroundColor Green
    $addresses | Format-Table -AutoSize
    Write-Host "Open: http://<PC-IP>:$Port/$Page`n" -ForegroundColor Green
}

Write-Host "Serving '$WebsitePath' with the $selectedServerType server on port $Port. Press Ctrl+C to stop." -ForegroundColor Cyan
if ($selectedServerType -eq 'Php') {
    $server = Start-Process -FilePath 'php' -ArgumentList @(
        '-S', "0.0.0.0:$Port", '-t', $WebsitePath
    ) -PassThru
} else {
    $server = Start-Process -FilePath 'py' -ArgumentList @(
        '-m', 'http.server', $Port, '--bind', '0.0.0.0', '--directory', $WebsitePath
    ) -PassThru
}

try {
    Start-Sleep -Milliseconds 750
    $pagePath = if ([string]::IsNullOrWhiteSpace($Page)) { '' } else { '/' + $Page.TrimStart('/') }
    $localUrl = "http://localhost:$Port$pagePath"
    Write-Host "Opening $localUrl in the default browser..." -ForegroundColor Green
    Start-Process $localUrl
    Wait-Process -Id $server.Id
} finally {
    if ($server -and -not $server.HasExited) {
        Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
    }
}
