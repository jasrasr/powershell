# source csv by row a-z

$csvPath = "C:\Temp\building permissions FINAL 101525.csv"
$outputPath = "C:\Temp\building permissions FINAL 101525-sorted.csv"
$encoding = [System.Text.UTF8Encoding]::new($true) # UTF-8 with BOM
$delimiter = ','
$quoteChar = '"'
$escapeChar = '"'
$hasHeader = $true
$rowKey = 'group name'  # Column to sort by
$caseSensitive = $false
$ascending = $true

# Read CSV
$rows = Import-Csv -Path $csvPath -Delimiter $delimiter -Encoding $encoding
if ($rows.Count -eq 0) {
    Write-Host "No data rows found in $csvPath"
    return
}

# Sort Rows
$sortedRows = $rows | Sort-Object -Property $rowKey -CaseSensitive:$caseSensitive -Descending:(!$ascending)

# Write CSV
$writer = [System.IO.StreamWriter]::new($outputPath, $false, $encoding)
try {
    if ($hasHeader) {
        $header = ($rows[0].PSObject.Properties.Name) -join $delimiter
        $writer.WriteLine($header)
    }
    $total = $sortedRows.Count
    for ($i = 0; $i -lt $total; $i++) {
        $row = $sortedRows[$i]
        Write-Progress -Activity "Writing sorted CSV" -Status "Row $($i + 1) of $total" -PercentComplete ((($i + 1) / $total) * 100)
        $values = @()
        foreach ($prop in $row.PSObject.Properties) {
            $val = $prop.Value -as [string]
            if ($null -eq $val) { $val = '' }
            if ($val.Contains($quoteChar)) {
                $val = $val.Replace($quoteChar, $escapeChar + $quoteChar)
            }
            if ($val.Contains($delimiter) -or $val.Contains($quoteChar)) {
                $val = $quoteChar + $val + $quoteChar
            }
            $values += $val
        }
        $line = $values -join $delimiter
        $writer.WriteLine($line)
    }
    Write-Progress -Activity "Writing sorted CSV" -Completed -Status "Done"
} finally {
    $writer.Close()
}

Write-Host "Sorted CSV saved to : $outputPath" -ForegroundColor Green
code $outputPath


