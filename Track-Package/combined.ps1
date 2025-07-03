function Get-Carrier {
    param([string]$tn)
    switch -regex ($tn) {
        '^(?i)1Z[0-9A-Z]{16}$'                { return 'UPS' }
        '^(?i)\d{12}$'                        { return 'FedEx' }
        '^(?i)9[0-9]{21}$'                    { return 'USPS' }
        default                               { return $null }
    }
}

function Track-Package {
    param([Parameter(Mandatory)][string]$TrackingNumber)

    $carrier = Get-Carrier $TrackingNumber
    if (-not $carrier) {
        Write-Warning "Unrecognized tracking number format: $TrackingNumber"; return
    }

    switch ($carrier) {
        'UPS'   { $url = "https://www.ups.com/track?track=yes&trackNums=$TrackingNumber" }
        'FedEx' { $url = "https://www.fedex.com/fedextrack/?trknbr=$TrackingNumber" }
        'USPS'  { $url = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=$TrackingNumber" }
    }

    Write-Output "Carrier detected: $carrier"
    Write-Output "Tracking URL: $url"

    Start-Process chrome.exe "--new-window $url"
}
