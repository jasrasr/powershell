<#
.SYNOPSIS
    Runs a script block while displaying a colored text spinner.

.DESCRIPTION
    Executes the supplied task in a background job and updates a spinner until
    the task completes. Task output is returned to the caller.

.PARAMETER Task
    The script block to execute in the background.

.PARAMETER StatusText
    The text displayed beside the spinner.

.EXAMPLE
    .\Show-CustomTextSpinner1.ps1

.NOTES
    This script runs the demonstration at the bottom when invoked directly.
#>

function Invoke-WithColoredSpinner {
    param(
        [Parameter(Mandatory)]
        [scriptblock]$Task,
        [string]$StatusText = "Cooking context..."
    )

    $frames = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
    $colors = @('Cyan', 'Magenta', 'DarkCyan', 'DarkMagenta')
    $delay = 0.08
    $counter = 0
    $job = Start-Job -ScriptBlock $Task
    $cursorVisibilityChanged = $false

    try {
        try {
            [Console]::CursorVisible = $false
            $cursorVisibilityChanged = $true
        }
        catch {
            # Some hosts do not expose a console handle.
        }

        while ($job.State -eq 'Running') {
            $frame = $frames[$counter % $frames.Count]
            $color = $colors[$counter % $colors.Count]

            Write-Host "`r$StatusText " -NoNewline
            Write-Host $frame -ForegroundColor $color -NoNewline

            Start-Sleep -Milliseconds ([int]($delay * 1000))
            $counter++
            $job = Get-Job -Id $job.Id
        }

        $jobResult = Receive-Job -Job $job -ErrorAction Stop
        if ($job.State -eq 'Failed') {
            throw $job.ChildJobs[0].JobStateInfo.Reason
        }

        Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
        Write-Host "`rTask completed successfully! " -NoNewline
        Write-Host "✅" -ForegroundColor Green
        return $jobResult
    }
    catch {
        if ($job) {
            Stop-Job $job -ErrorAction SilentlyContinue
            Remove-Job $job -Force -ErrorAction SilentlyContinue
        }

        Write-Host "`rProcess interrupted. " -NoNewline
        Write-Host "❌" -ForegroundColor Red
        throw
    }
    finally {
        if ($cursorVisibilityChanged) {
            [Console]::CursorVisible = $true
        }
    }
}

Invoke-WithColoredSpinner -Task { Start-Sleep -Seconds 4 } -StatusText "Analyzing workspace..."
