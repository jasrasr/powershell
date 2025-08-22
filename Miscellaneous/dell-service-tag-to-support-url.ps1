# Revision : 1.0
# Description : Launches Dell support page for a given service tag in a new Chrome window and returns the URL
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-08-20
# Modified Date : 2025-08-20

function dell {
    param(
        [Parameter(Mandatory)][string]$ServiceTag
    )

    # Construct the Dell support URL
    $url = "https://www.dell.com/support/home/en-us/product-support/servicetag/$ServiceTag"

    # Launch Chrome in a new window with the support page
    Start-Process chrome.exe "--new-window $url"

    # Return the URL for logging or further use
    return $url
}

# call with 'dell 7QBMYK3'
# returns
# C:\> dell 7QBMYK3
# https://www.dell.com/support/home/en-us/product-support/servicetag/7QBMYK3
# launches chrome in new window
