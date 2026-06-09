# API request helper template.
$BaseUri = '<https://api.example.com>'
$Headers = @{
    Accept = 'application/json'
    # Authorization = "Bearer $Token"
}

function Invoke-ApiRequest {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [string]$Method = 'GET',

        [object]$Body
    )

    $Uri = '{0}/{1}' -f $BaseUri.TrimEnd('/'), $Path.TrimStart('/')
    $Request = @{
        Uri         = $Uri
        Method      = $Method
        Headers     = $Headers
        ErrorAction = 'Stop'
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $Request.Body = $Body | ConvertTo-Json -Depth 10
        $Request.ContentType = 'application/json'
    }

    Invoke-RestMethod @Request
}
