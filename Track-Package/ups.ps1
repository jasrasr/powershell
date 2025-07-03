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
C:\Users\jason.lamb> ups 1ZX1615YD904086345
https://www.ups.com/track?track=yes&trackNums=1ZX1615YD904086345
