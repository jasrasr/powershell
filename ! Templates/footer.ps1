# Footer/finalization template.
try {
    # Main script work goes here.
    Write-Log -Message 'Script completed successfully.'
}
catch {
    $ErrorMessage = $_.Exception.Message

    if (Get-Command -Name Write-Log -ErrorAction SilentlyContinue) {
        Write-Log -Message $ErrorMessage -Level ERROR
    } else {
        Write-Host "ERROR: $ErrorMessage" -ForegroundColor Red
    }

    exit 1
}
