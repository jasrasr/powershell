# Path to your XML export file
$xmlPath = "C:\Users\jason.lamb\OneDrive - middough\Downloads\jasonlambme.WordPress.2025-10-16.xml"

# Path to output CSV
$csvPath = "C:\temp\powershell-exports\jl_posts_title_date_link_101625-2.csv"

[xml]$xml = Get-Content -Path $xmlPath

# Define namespace mapping: prefix → URI (match what your WXR uses)
$namespaces = @{
    wp = "http://wordpress.org/export/1.2/"      # <— adjust if your XML uses a different version
    # If there are other namespaces you use (dc, content, etc.), map them here too
}

# Use Select-Xml with -Namespace so that `wp:` is understood
$nodes = Select-Xml -Xml $xml -Namespace $namespaces `
    -XPath "//item[wp:post_type='post' and wp:status='publish']"

$results = foreach ($match in $nodes) {
    $item = $match.Node

    # Title (no namespace prefix needed since <title> is in default/no prefix)
    $title = ($item.SelectSingleNode("title")).InnerText

    # Date: use Select-Xml with namespace on the $item
    $dateMatch = Select-Xml -Node $item -Namespace $namespaces -XPath "wp:post_date"
    $date = $dateMatch.Node.InnerText

    # Link (usually <link> is not namespaced)
    $link = ($item.SelectSingleNode("link")).InnerText

    [PSCustomObject] @{
        Title = $title
        Date  = $date
        Link  = $link
    }
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($results.Count) posts to $csvPath"


[xml]$xml = Get-Content -Path $xmlPath

# Namespace mapping (adjust the URI if your XML uses a different version)
$namespaces = @{
    wp = "http://wordpress.org/export/1.2/"
    # add other needed namespace prefixes if your XML uses them
}

# Select <item> nodes that match post_type = 'post'
$nodes = Select-Xml -Xml $xml -Namespace $namespaces `
    -XPath "//item[wp:post_type='post']"

$results = foreach ($match in $nodes) {
    $item = $match.Node

    # Title
    $title = ($item.SelectSingleNode("title")).InnerText

    # Date
    $dateMatch = Select-Xml -Node $item -Namespace $namespaces -XPath "wp:post_date"
    $date = $dateMatch.Node.InnerText

    # Link
    $link = ($item.SelectSingleNode("link")).InnerText

    # Status
    $statusMatch = Select-Xml -Node $item -Namespace $namespaces -XPath "wp:status"
    $status = $statusMatch.Node.InnerText

    [PSCustomObject] @{
        Title  = $title
        Date   = $date
        Link   = $link
        Status = $status
    }
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($results.Count) posts (with status) to $csvPath"


[xml]$xml = Get-Content -Path $xmlPath

# Namespace mapping (adjust URI if needed)
$namespaces = @{
    wp = "http://wordpress.org/export/1.2/"
}

# Select all items of type post
$nodes = Select-Xml -Xml $xml -Namespace $namespaces `
    -XPath "//item[wp:post_type='post']"

$results = foreach ($match in $nodes) {
    $item = $match.Node

    # Title
    $title = ($item.SelectSingleNode("title")).InnerText

    # Date (full)
    $dateMatch = Select-Xml -Node $item -Namespace $namespaces -XPath "wp:post_date"
    $fullDate = $dateMatch.Node.InnerText

    # Link
    $link = ($item.SelectSingleNode("link")).InnerText

    # Status
    $statusMatch = Select-Xml -Node $item -Namespace $namespaces -XPath "wp:status"
    $status = $statusMatch.Node.InnerText

    # Compute custom date. Parse the full date string into a DateTime first
    # Then format to “yyMMdd”
    $dt = [datetime]::ParseExact($fullDate, "yyyy-MM-dd HH:mm:ss", $null)
    $shortDate = $dt.ToString("yyMMdd")

    [PSCustomObject] @{
        Title     = $title
        Date      = $fullDate
        Link      = $link
        Status    = $status
        ShortDate = $shortDate
    }
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($results.Count) posts (with ShortDate) to $csvPath"
code $csvpath
