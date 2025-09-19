

$files =@(
    'subfolder1\file1.txt',
    'subfolder2\file2.txt'
   )

$filerserver = @(
'\\server1',
'\\server2',
)



foreach ($file in $files) {
    write-host $file

    foreach ($filer in $filerserver) {
    $fullfolder = Join-Path -Path $filer -ChildPath $file
        write-host $fullfolder " - " (test-path $fullfolder)

    }
    write-host .
}
