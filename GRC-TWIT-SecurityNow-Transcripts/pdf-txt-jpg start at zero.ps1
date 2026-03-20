# start with https://www.grc.com/sn/1.jpg and go to https://www.grc.com/sn/998.jpg to see if file exist and then download to $githubpath\powershell\GRC-TWIT-SecurityNow-Transcripts\Downloads\JPG-Episode-Images\

$githubpath = 'C:\Users\Jason.Lamb\OneDrive - Cooper Machinery Services\Documents\Github'
$downloadbase = Join-Path $githubpath 'powershell\GRC-TWIT-SecurityNow-Transcripts\Downloads'
$jpgDownloadPath = Join-Path $downloadbase 'JPG-Episode-Images' 
$pdfDownloadPath = Join-Path $downloadbase 'PDF-Transcripts'
$txtDownloadPath = Join-Path $downloadbase 'TXT-Transcripts'    

# Download JPG files from grc.com/sn/1.jpg to 998.jpg
$baseUrl = 'https://www.grc.com/sn'

for ($i = 1; $i -le 998; $i++) {
    $url = "$baseUrl/$i.jpg"
    $outputPath = Join-Path $jpgDownloadPath "Episode-$i.jpg"
    
    try {
        if ((Invoke-WebRequest -Uri $url -Method Head -ErrorAction Stop).StatusCode -eq 200) {
            Invoke-WebRequest -Uri $url -OutFile $outputPath
            Write-Host "Downloaded: Episode-$i.jpg"
        }
    }
    catch {
        Write-Host "Not found or error: Episode-$i.jpg"
    }
}

# same for PDF and TXT files, just change the extension and output path accordingly
# example txt url https://www.grc.com/sn/sn-1069.txt
# example pdf url https://www.grc.com/sn/sn-1069-notes.pdf

for ($i = 1; $i -le 998; $i++) {
    $txtNumPadded = $i.ToString('000')
    $pdfUrl = "$baseUrl/sn-$i-notes.pdf"
    $pdfOutputPath = Join-Path $pdfDownloadPath "Episode-$i.pdf"
    
    try {
        if ((Invoke-WebRequest -Uri $pdfUrl -Method Head -ErrorAction Stop).StatusCode -eq 200) {
            Invoke-WebRequest -Uri $pdfUrl -OutFile $pdfOutputPath
            Write-Host "Downloaded: Episode-$i.pdf"
        }
    }
    catch {
        Write-Host "Not found or error: Episode-$i.pdf"
    }

    $txtUrl = "$baseUrl/sn-$txtNumPadded.txt"
    $txtOutputPath = Join-Path $txtDownloadPath "Episode-$i.txt"
    
    try {
        if ((Invoke-WebRequest -Uri $txtUrl -Method Head -ErrorAction Stop).StatusCode -eq 200) {
            Invoke-WebRequest -Uri $txtUrl -OutFile $txtOutputPath
            Write-Host "Downloaded: Episode-$i.txt"
        }
    }
    catch {
        Write-Host "Not found or error: Episode-$i.txt"
    }
}