param (
    [string] $SourceFile,
    [string] $DestinationFile
)

$fi = Get-Item -LiteralPath $SourceFile
$totalBytes = $fi.Length

$inStream = [System.IO.File]::OpenRead($SourceFile)
$outStream = [System.IO.File]::OpenWrite($DestinationFile)

try {
    $bufferSize = 4MB
    $buffer = New-Object byte[] $bufferSize
    $bytesCopied = 0

    while ($true) {
        $read = $inStream.Read($buffer, 0, $bufferSize)
        if ($read -le 0) { break }

        $outStream.Write($buffer, 0, $read)
        $bytesCopied += $read

        $percent = [int]( ($bytesCopied / $totalBytes) * 100 )

        Write-Progress `
            -Activity "Moving file" `
            -Status "Copied $bytesCopied of $totalBytes bytes" `
            -PercentComplete $percent
    }

    $outStream.Flush()
} finally {
    $inStream.Close()
    $outStream.Close()
}

Remove-Item -LiteralPath $SourceFile
Write-Progress -Activity "Moving file" -Completed -Status "Done"
