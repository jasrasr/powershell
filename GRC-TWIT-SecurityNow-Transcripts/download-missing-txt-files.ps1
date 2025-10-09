$txtfiles =@(
 'https://www.grc.com/sn/sn-436.txt',
 'https://www.grc.com/sn/sn-487.txt',
 'https://www.grc.com/sn/sn-540.txt',
 'https://www.grc.com/sn/sn-592.txt',
 'https://www.grc.com/sn/sn-643.txt',
 'https://www.grc.com/sn/sn-695.txt',
 'https://www.grc.com/sn/sn-747.txt',
 'https://www.grc.com/sn/sn-798.txt',
 'https://www.grc.com/sn/sn-851.txt',
 'https://www.grc.com/sn/sn-903.txt',
 'https://www.grc.com/sn/sn-954.txt',
 'https://www.grc.com/sn/sn-963.txt',
 'https://www.grc.com/sn/sn-1046.txt',
 'https://www.grc.com/sn/sn-1047.txt',
'https://www.grc.com/sn/sn-1048.txt',
'https://www.grc.com/sn/sn-1049.txt',
'https://www.grc.com/sn/sn-1050.txt'
)

foreach ($txt in $txtfiles) {
  
    if (test-path $txt) {
        Write-Host "File exists: $txt" -ForegroundColor Green
        # download the file
        $output = "C:\Users\jason.lamb\OneDrive - middough\Documents\GitHub\PowerShell\GRC-TWIT-SecurityNow-Transcripts\Downloads\txt-transcriptions\" + ($txt -split '/' | Select-Object -Last 1)
        Invoke-WebRequest -Uri $txt -OutFile $output
    } else {
        Write-Host "File does not exist: $txt" -ForegroundColor Red
    }
}

