# Filename: generate-qr-code-to-html.ps1
# Revision : 1.4
# Description : Generate a QR code as SVG or PNG for a website URL using a web QR service, with $psexports as the default export folder
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2026-03-21
# Modified Date : 2026-03-21
# Changelog :
# 1.0 initial release
# 1.1 replaced unavailable QRCoder module with direct web-based PNG download, added high resolution default
# 1.2 switched to SVG output for true print-quality scaling and added PNG fallback
# 1.3 changed default export folder to $psexports, added validation for $psexports, changed default size to 4000, updated examples to use qr10
# 1.4 fixed missing -Format parameter issue, added backward-safe $psexports handling, improved output details

function New-WebsiteQrCode {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter()]
        [ValidateSet('SVG','PNG')]
        [string]$Format = 'SVG',

        [Parameter()]
        [ValidateRange(100,4000)]
        [int]$Size = 4000,

        [Parameter()]
        [string]$OutputPath
    )

    try {
        if (-not $psexports) {
            throw "`$psexports is not defined. Make sure your profile is loaded."
        }

        if (-not ($Url -match '^https?://')) {
            throw "URL must start with http:// or https://"
        }

        if (-not $OutputPath) {
            $defaultExtension = if ($Format -eq 'PNG') { 'png' } else { 'svg' }
            $OutputPath = Join-Path $psexports "website-qr-$(Get-Date -Format 'yyyyMMdd-HHmmss').$defaultExtension"
        }

        $outputFolder = Split-Path -Path $OutputPath -Parent
        if (-not (Test-Path $outputFolder)) {
            New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
        }

        $encodedUrl = [System.Uri]::EscapeDataString($Url)

        switch ($Format) {
            'SVG' {
                if (-not $OutputPath.ToLower().EndsWith('.svg')) {
                    $OutputPath = [System.IO.Path]::ChangeExtension($OutputPath, '.svg')
                }
                $qrRequestUrl = "https://quickchart.io/qr?text=$encodedUrl&size=$Size&format=svg&margin=4&ecLevel=H"
            }

            'PNG' {
                if (-not $OutputPath.ToLower().EndsWith('.png')) {
                    $OutputPath = [System.IO.Path]::ChangeExtension($OutputPath, '.png')
                }
                $qrRequestUrl = "https://quickchart.io/qr?text=$encodedUrl&size=$Size&format=png&margin=4&ecLevel=H"
            }
        }

        Invoke-WebRequest -Uri $qrRequestUrl -OutFile $OutputPath

        if (-not (Test-Path $OutputPath)) {
            throw "QR code file was not created"
        }

        $file = Get-Item $OutputPath

        Write-Host ""
        Write-Host "QR code created successfully" -ForegroundColor Green
        Write-Host "URL         : $Url"
        Write-Host "Format      : $Format"
        Write-Host "Requested   : $Size"
        Write-Host "Output file : $($file.FullName)"
        Write-Host "File size   : $([math]::Round($file.Length / 1KB, 2)) KB"
        Write-Host ""

        Start-Process $file.FullName
    }
    catch {
        Write-Host "Error generating QR code : $_" -ForegroundColor Red
    }
}

# What changed in Revision 1.4
# - fixed the parameter layout so -Format is definitely available
# - moved $OutputPath after $Format and $Size for cleaner function binding
# - made default extension follow the selected format
# - kept $psexports as the default export location
# - improved revision notes and output consistency

# Example usage
# . .\generate-qr-code-to-html.ps1
# New-WebsiteQrCode -Url "https://jasr.me/qr10"

# Example usage with explicit SVG output
# . .\generate-qr-code-to-html.ps1
# New-WebsiteQrCode -Url "https://jasr.me/qr10" -Format SVG -OutputPath (Join-Path $psexports "jasr-qr10.svg")

# Example usage with PNG output
# . .\generate-qr-code-to-html.ps1
# New-WebsiteQrCode -Url "https://jasr.me/qr10" -Format PNG -OutputPath (Join-Path $psexports "jasr-qr10.png")

# Example usage with custom size
# . .\generate-qr-code-to-html.ps1
# New-WebsiteQrCode -Url "https://jasr.me/qr10" -Format PNG -OutputPath (Join-Path $psexports "jasr-qr10.png") -Size 4000