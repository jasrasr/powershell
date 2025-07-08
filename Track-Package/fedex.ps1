# Revision : 1.0
# Description : Launches a FedEx tracking URL in a new Chrome window and returns the URL for logging or further use
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-03
# Modified Date : 2025-07-03

function fedex {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the FedEx tracking URL
    $url = "https://www.fedex.com/fedextrack/?trknbr=$TrackingNumber"

    # Launch Chrome in a new window pointing to the tracking URL
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

# call with 'fedex 881234567890' 
# returns URL
# C:\> fedex 881234567890
# https://www.fedex.com/fedextrack/?trknbr=881234567890
# launches chrome in new window
