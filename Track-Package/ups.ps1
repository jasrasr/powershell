# Revision : 1.0
# Description : Launches a UPS tracking URL in a new Chrome window and returns the URL for logging or further use
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-07-03
# Modified Date : 2025-07-03

function ups {
    param(
        [Parameter(Mandatory)][string]$TrackingNumber
    )

    # Construct the UPS tracking URL
    $url = "https://www.ups.com/track?track=yes&trackNums=$TrackingNumber"

    # Launch Chrome in a new window with the tracking page
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

# call with 'ups 1Z################'
# returns
# C:\> ups 1Z################
# https://www.ups.com/track?track=yes&trackNums=1Z################
# launches chrome in new window
