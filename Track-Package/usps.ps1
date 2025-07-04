# Revision : 1.0
# Description : Launches a USPS tracking URL in a new Chrome window and returns the URL for logging or further use
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-03
# Modified Date : 2025-07-03

function usps {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the USPS tracking URL using the qtc_tLabels1 parameter
    $url = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=$TrackingNumber"

    # Launch Chrome in a new window with the constructed URL
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or future use
    return $url
}

# call with usps 9361289698021234567890 
# returns URL
# C:\> usps 9361289698021234567890
# https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=9361289698021234567890
# launches chrome in new window
