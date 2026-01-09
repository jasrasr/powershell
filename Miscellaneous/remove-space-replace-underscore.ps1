    function Remove-Spaces {
        param(
            [Parameter(Mandatory=$false, Position=0)]
            [string]$Text
        )
        
        # Prompt for input if no parameter given
        if ([string]::IsNullOrEmpty($Text)) {
            $Text = Read-Host "Enter text to process"
        }
        
        # replace space with _
        $result = $Text -replace ' ', '_'
        # replace - with _
        $result = $result -replace '-', '_'
        # replace multiple _ with single _
        $result = $result -replace '_+', '_'
        
        # output final result
        $result
        # add to clipboard
        $result | Set-Clipboard
    }

# Example Usage:
# & { . "$githubpath\PowerShell\Miscellaneous\remove-space-replace-underscore.ps1"; Remove-Spaces "my text here 2" }
