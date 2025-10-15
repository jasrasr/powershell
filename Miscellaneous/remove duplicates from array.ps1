$dups = @(
    'thing1',
    'thing2',
    'thing3',
    'thing1'
    )
# remove duplicates
$dups = $dups | Sort-Object -Unique
$dups