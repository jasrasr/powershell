# Revision : 1.1
# Description : Unified FedEx, UPS, USPS tracking function with updated regex detection. Rev 1.1
# call with track-package ###
# the script should recognize the format of the 3 carriers tracking numbers
# Author : Jason Lamb
# Created Date : 2025-07-03
# Modified Date : 2025-07-03

function Get-Carrier {
    param([string]$tn)
    switch -regex ($tn) {
        '^(1Z[0-9A-Z]{16})$'                                     { return 'UPS' }
        '^(?:\d{12}|\d{15}|\d{20}|\d{22})$'                       { return 'FedEx' }
        '^(?:(94|93|92|95)[0-9]{20,22}|[A-Z]{2}[0-9]{9}[A-Z]{2})$' { return 'USPS' }
        default                                                  { return $null }
    }
}

function Track-Package {
    param([Parameter(Mandatory)][string]$TrackingNumber)

    $carrier = Get-Carrier $TrackingNumber
    if (-not $carrier) {
        Write-Warning "Unrecognized tracking number format : $TrackingNumber"
        return
    }

    switch ($carrier) {
        'UPS'   { $url = "https://www.ups.com/track?track=yes&trackNums=$TrackingNumber" }
        'FedEx' { $url = "https://www.fedex.com/fedextrack/?trknbr=$TrackingNumber" }
        'USPS'  { $url = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=$TrackingNumber" }
    }

    Write-Host "Carrier detected : $carrier"
    Write-Host "Tracking URL : $url"

    Start-Process chrome.exe "--new-window $url"
}
