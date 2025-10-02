function Get-MdStatistics {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Basic stats
    $mo = Get-Content $Path | Measure-Object -Line -Word -Character

    # Paragraphs
    $lines = Get-Content $Path
    $paraCount = 0
    $inPara = $false
    foreach ($l in $lines) {
        if ($l -match '\S') {
            if (-not $inPara) {
                $paraCount++
                $inPara = $true
            }
        }
        else {
            $inPara = $false
        }
    }

    # Sentences (rough)
    $text = Get-Content $Path -Raw
    $sentenceEndings = '(?<=[\.\?\!])\s+'
    $sentences = [regex]::Split($text, $sentenceEndings) | Where-Object { $_.Trim().Length -gt 0 }
    $sentenceCount = $sentences.Count

    [PSCustomObject] @{
        Lines       = $mo.Lines
        Words       = $mo.Words
        Characters  = $mo.Characters
        Paragraphs  = $paraCount
        Sentences   = $sentenceCount
    }
}
