# Filename: dell-service-tag-to-support-url.ps1
# Revision : 1.1.1
# Description : Launches Dell support pages for one or more service tags in new Chrome tabs and returns the URLs
# Author : Jason Lamb (with help from Claude Code)
# Created Date : 2025-08-20
# Modified Date : 2026-05-18
# Changelog :
# 1.0 initial release
# 1.1.0 changed to open in new tab of existing Chrome window instead of new window
# 1.1.1 added support for multiple service tags

function dell {
    param(
        [Parameter(Mandatory)][string[]]$ServiceTag
    )

    foreach ($tag in $ServiceTag) {
        # Construct the Dell support URL
        $url = "https://www.dell.com/support/home/en-us/product-support/servicetag/$tag"

        # Launch Chrome in a new tab with the support page
        Start-Process chrome.exe $url

        # Return the URL for logging or further use
        $url
    }
}

# Example Usage:
#   dell 7QBMYK3
#   dell 7QBMYK3 ABCD123
#   Opens the Dell support page in a new tab of an existing Chrome window and returns the URL
