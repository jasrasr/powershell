<#
.SYNOPSIS
    Displays a custom text spinner while a simulated task runs.

.DESCRIPTION
    Cycles through the configured spinner frames for five seconds and then
    displays a completion message.

.EXAMPLE
    .\Show-CustomTextSpinner.ps1

.NOTES
    This script runs the demonstration when invoked directly.
#>

function Show-CustomSpinner {
    $frames = @('◤', '◥', '◢', '◣')
    $delay = 0.15
    $counter = 0

    Write-Host "Initializing script... " -NoNewline
    $endTime = (Get-Date).AddSeconds(5)

    try {
        while ((Get-Date) -lt $endTime) {
            $frame = $frames[$counter % $frames.Count]
            Write-Host "`rCooking context... $frame " -NoNewline
            Start-Sleep -Milliseconds ([int]($delay * 1000))
            $counter++
        }

        Write-Host "`rTask completed successfully! ✅ "
    }
    catch {
        Write-Host "`rProcess interrupted. ❌"
    }
}

Show-CustomSpinner
