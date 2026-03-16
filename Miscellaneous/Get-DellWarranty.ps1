param(
    [string[]]$ServiceTags = @("CLRJGC4")
)

foreach ($tag in $ServiceTags) {
    $url = "https://apiftr.dell.com/support/assetinfo/en-us/GetAssetWarrantyByServiceTag?svctag=$tag"
    
    $headers = @{
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        "Accept" = "application/json"
        "Referer" = "https://www.dell.com/support/home/en-us/product-support/servicetag/$tag/warranty"
    }
    
    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method GET
        
        Write-Host "`n=== $tag ==="
        Write-Host "Model:     $($response.AssetHeaderData.ProductLineDescription)"
        Write-Host "Ship Date: $($response.AssetHeaderData.ShipDate)"
        
        foreach ($item in $response.AssetEntitlementData) {
            Write-Host "`n  Plan:   $($item.ServiceLevelDescription)"
            Write-Host "  Start:  $($item.StartDate)"
            Write-Host "  End:    $($item.EndDate)"
            $status = if ((Get-Date) -lt [datetime]$item.EndDate) { "Active" } else { "Expired" }
            Write-Host "  Status: $status"
        }
    }
    catch {
        Write-Host "Error looking up $tag : $_"
    }
}