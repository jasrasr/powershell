# Filename: dell-service-tag-to-support-url.ps1
# Revision : 1.1.0
# Description : Launches Dell support page for a given service tag in a new Chrome tab and returns the URL
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2025-08-20
# Modified Date : 2026-05-11
# Changelog :
# 1.0 initial release
# 1.1.0 changed to open in new tab of existing Chrome window instead of new window

function dell {
    param(
        [Parameter(Mandatory)][string]$ServiceTag
    )

    # Construct the Dell support URL
    $url = "https://www.dell.com/support/home/en-us/product-support/servicetag/$ServiceTag"

    # Launch Chrome in a new tab with the support page
    Start-Process chrome.exe $url

    # Return the URL for logging or further use
    return $url
}

# Example Usage:
#   dell 7QBMYK3
#   Opens the Dell support page in a new tab of an existing Chrome window and returns the URL
