# Get the current UTC time
$currentUtcTime = (Get-Date).ToUniversalTime()

# Function to find a location where the current local time is 5 PM
function Get-5PMLocation {
    $timezones = [System.TimeZoneInfo]::GetSystemTimeZones()
    
    foreach ($timezone in $timezones) {
        $localTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($currentUtcTime, $timezone)
        
        # Check if the local time is 5 PM
        if ($localTime.Hour -eq 17 -and $localTime.Minute -eq 0) {
            return $timezone.DisplayName
        }
    }
    return "No location is currently experiencing 5 PM at this moment."
}

# Call the function and output the result
$location = Get-5PMLocation
Write-Output "The current location where it is 5 PM: $location"
