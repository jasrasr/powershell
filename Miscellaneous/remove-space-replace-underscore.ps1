$text1 = 'this is some test-text'
# replace space with _
$text2 = $text1 -replace ' ', '_'
# replace - with _
$text3 = $text2 -replace '-', '_'
# replace multiple _ with single _
$text4 = $text3 -replace '_+', '_'
# output final result
$text4
