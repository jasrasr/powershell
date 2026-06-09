$text1 = 'this is-a sample--text'
# replace space with _
$text2 = $text1 -replace ' ', '_'
# replace - with _
$text3 = $text2 -replace '-', '_'
# replace multiple _ with single _
$text4 = $text3 -replace '_+', '_'
Write-Output $text4
# copy to clipboard
Set-Clipboard -Value $text4
Write-Output "Modified text copied to clipboard."
