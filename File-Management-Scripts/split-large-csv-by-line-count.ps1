# Revision : 1.0
# Description : Split a large CSV into smaller chunk files while preserving the header. Rev 1.0
# Author : Jason Lamb (with help from ChatGPT)
# Created Date : 2025-09-25
# Modified Date : 2025-09-25

param(
    [Parameter(Mandatory = $true)]
    [string] $InputCsv,                     # Full path to the large CSV
    [Parameter(Mandatory = $true)]
    [string] $OutputFolder,                 # Folder to save the split files
    [Parameter(Mandatory = $true)]
    [int] $LinesPerFile                     # Number of data rows per chunk
)

if (-not (Test-Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}

$header = Get-Content -Path $InputCsv -First 1
$rows = Get-Content -Path $InputCsv | Select-Object -Skip 1

$chunkIndex = 1
for ($i = 0; $i -lt $rows.Count; $i += $LinesPerFile) {
    $chunk = $rows[$i..([Math]::Min($i + $LinesPerFile - 1, $rows.Count - 1))]
    $chunkFile = Join-Path $OutputFolder ("chunk_{0:D4}.csv" -f $chunkIndex)
    $header | Out-File -FilePath $chunkFile -Encoding utf8
    $chunk  | Out-File -FilePath $chunkFile -Encoding utf8 -Append
    Write-Host "Created $chunkFile with $($chunk.Count) rows"
    $chunkIndex++
}
