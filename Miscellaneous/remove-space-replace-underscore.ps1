    # ask for user input text
    $text0 = read-host("enter some text:")

    # $text1 = 'this is some test-text'

    # replace space with _
    $text2 = $text0 -replace ' ', '_'
    
    # replace - with _
    $text3 = $text2 -replace '-', '_'
    
    # replace multiple _ with single _
    $text4 = $text3 -replace '_+', '_'
    
    # output final result
    $text4
    
    # add to clipboard
    $text4 | Set-Clipboard
