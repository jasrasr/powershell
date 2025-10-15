$txtinput = 'txttoparse.txt'
$txtoutput = 'txttoparse-output.txt'
$txtoutputclean = 'txttoparse-output-clean.txt'
$filter = 'AKS0631'

# remove row a row that matches "x" to $txtoutput
#New-Item -Path $txtoutput -ItemType File -Force
# remove duplicate lines
#Get-Content $txtinput | Sort-Object -Unique | Set-Content $txtinput

# create output file
# step 1 - filter the match into a new txt file - $txtoutput
$filter1 = Get-Content $txtinput | Where-Object { $_ -match "\\12\.0 Document Control" }
Set-Content -path $txtoutput -Value $filter1

# step 2 - filter the non-matching lines back into the original file
$filter2 = Get-Content $txtinput | Where-Object { $_ -notmatch "\\12\.0 Document Control" }
Set-Content -Path $txtinput -Value $filter2

# step 3 - clean the output file by removing lines that start with "X" and send to $txtoutputclean
$filter3 = Get-Content $txtoutput | Where-Object { $_ -notmatch "\\12\.0 Document Control\\" }
Set-Content -Path $txtoutputclean -Value $filter3


<#
$text = '\\server.local\folder1\folder2\folder3\file.ext'
#count how many back slashes
$backslashCount = [regex]::Matches($text, '\\').Count
Write-Host "Backslash count in text: $backslashCount"
#>
$mapclecantonmacdir = 'c:\temp\file.txt'
$mapclecantonmacdirclean = 'c:\temp\file-clean.txt'
# remove any row with quantity eleven or more '\' back slashes
Get-Content $mapclecantonmacdir |
    Where-Object { ([regex]::Matches($_, '\\').Count) -le 9 } |
    Set-Content $mapclecantonmacdirclean


#Get-Content $txtoutput | Where-Object { $_ -notmatch "\\6\.0 Estimate\\.*" } | Set-Content $txtoutputclean
#Get-Content $txtoutput | Where-Object { $_ -notmatch "\\5\.0 TQP\\.*" } | Set-Content $txtoutputclean

notepad $txtoutput
