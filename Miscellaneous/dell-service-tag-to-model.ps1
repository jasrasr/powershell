$alltags = "11S1LP3, 1D62LP3, 1GB2LP3, 1RB2LP3, 1WFZHN3, 1WG2LP3, 1YG2LP3, 23M2LP3, 2453LP3, 27S1LP3, 2JB2LP3, 2LX1LP3, 2PX1LP3, 2VG2LP3, 2Y43LP3, 3KB2LP3, 3LB2LP3, 3NX1LP3, 3QB2LP3, 3X43LP3, 41S1LP3, 45S1LP3, 4D8ZHN3, 4JB2LP3, 52M2LP3, 5H62LP3, 5KB2LP3, 5S03LP3, 5T03LP3, 6253LP3, 63M2LP3, 6D0YHN3, 6GB2LP3, 6MX1LP3, 6NX1LP3, 6PB2LP3, 6PX1LP3, 6RB2LP3, 6TG2LP3, 6W43LP3, 70M2LP3, 71M2LP3, 7353LP3, 7H62LP3, 7MB2LP3, 7SB2LP3, 7T43LP3, 7VG2LP3, 7WG2LP3, 8MB2LP3, 8PB2LP3, 8XG2LP3, 9053LP3, 98S1LP3, 9H62LP3, 9QX1LP3, 9TG2LP3, B1H2LP3, B1S1LP3, B2LP3, B962LP3, BV43LP3, BXG2LP3, C053LP3, CHB2LP3, CJB2LP3, CLB2LP3, CQG2LP3, CVG2LP3, CZ43LP3, D0M2LP3, D1S1LP3, D353LP3, DKB2LP3, DMB2LP3, DPB2LP3, DS43LP3, DVG2LP3, F2M2LP3, FWFZHN3, G0H2LP3, G153LP3, GLX1LP3, GPB2LP3, GR03LP3, GRG2LP3, GTG2LP3, GXG2LP3, H0S1LP3, H1M2LP3, HD62LP3, HF62LP3, HFB2LP3, HMB2LP3, HMX1LP3, J0S1LP3, J353LP3, J38RFN3, JG62LP3, JYR1LP3"
# all your tags as one big string
#>
#$tagarray = $alltags -split ","

<#
foreach ($tag in $tagarray) {
# parse the whole site - A LOT OF DATA
# Invoke-WebRequest -Uri "https://www.dell.com/support/home/en-us?app=drivers&~ck=mn" -Body @{ "serviceTag" = $tag } -Method Post
}
#>



# --- PREP ---
$tags = $alltags -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$csv   = "C:\temp\powershell-exports\dell-models-$stamp.csv"
New-Item -ItemType Directory -Path (Split-Path $csv) -Force | Out-Null
$headers = @{
  'User-Agent'      = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'
  'Accept'          = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
  'Accept-Language' = 'en-US,en;q=0.8'
  'Cache-Control'   = 'no-cache'
}

# CSV header
[pscustomobject]@{ServiceTag='ServiceTag';Model='Model';StatusCode='StatusCode';Url='Url'} |
  Export-Csv -Path $csv -NoTypeInformation

# --- FUNCTIONS ---
function Invoke-WithRetry {
  param([string]$Uri,[hashtable]$Headers,[int]$Max=5)
  $delay = 2
  for ($i=1; $i -le $Max; $i++) {
    try {
      return Invoke-WebRequest -Uri $Uri -Headers $Headers -MaximumRedirection 5 -TimeoutSec 60 -ErrorAction Stop
    } catch {
      $msg = $_.Exception.Message
      if ($i -eq $Max) { throw }
      # backoff on throttling/forbidden
      if ($msg -match '403|429|temporar|forbid|timed out|closed') {
        Start-Sleep -Seconds $delay
        $delay = [Math]::Min($delay * 2, 30)
      } else {
        Start-Sleep -Seconds 2
      }
    }
  }
}

# --- MAIN (live output per tag) ---
$idx = 0
$tot = $tags.Count

$tags | ForEach-Object {
  $tag = $_
  $idx++
  $url = "https://www.dell.com/support/product-details/en-us/servicetag/$tag"

  try {
    # polite pace so Dell doesn’t yeet us (they rate-limit / discourage scraping)
    Start-Sleep -Milliseconds (400 + (Get-Random -Minimum 0 -Maximum 600))

    # add a realistic referrer each time
    $h = $headers.Clone()
    $h['Referer'] = 'https://www.dell.com/support/home/en-us'

    $r = Invoke-WithRetry -Uri $url -Headers $h

    # Title pattern: "Support for <MODEL> | ..."
    $model = [regex]::Match($r.Content, '(?<=Support for ).*?(?=\s*\|)').Value
    if (-not $model) {
      # fallback: first H1
      $m = [regex]::Match($r.Content, '<h1[^>]*>\s*(.*?)\s*</h1>', 'IgnoreCase')
      if ($m.Success) { $model = ($m.Groups[1].Value -replace '<.*?>').Trim() }
    }
    if (-not $model) { $model = '(model not found)' }

    Write-Host ("[{0}/{1}] {2} -> {3}" -f $idx, $tot, $tag, $model)

    [pscustomobject]@{
      ServiceTag = $tag
      Model      = $model
      StatusCode = $r.StatusCode
      Url        = $url
    } | Export-Csv -Path $csv -NoTypeInformation -Append
  }
  catch {
    Write-Host ("[{0}/{1}] {2} -> (request failed)" -f $idx, $tot, $tag) -ForegroundColor Yellow
    [pscustomobject]@{
      ServiceTag = $tag
      Model      = '(request failed)'
      StatusCode = $null
      Url        = $url
    } | Export-Csv -Path $csv -NoTypeInformation -Append
  }
}

Write-Host "`nSaved CSV -> $csv"
