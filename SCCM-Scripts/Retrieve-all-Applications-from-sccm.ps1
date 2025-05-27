# Connection to SCCM server required before running this script

# Retrieve all Applications with Deployment Count and Status
$applications = Get-CMApplication | ForEach-Object {
    $deployments = Get-CMDeployment | Where-Object { $_.PackageName -eq $_.LocalizedDisplayName }
    [PSCustomObject]@{
        Name            = $_.LocalizedDisplayName
        DeploymentCount = $deployments.Count
        Status          = if ($deployments) {
            if (($deployments | Select-Object -First 1).Enabled) { 'Enabled' } else { 'Disabled' }
        } else {
            'No Deployments'
        }
    }
}

# Retrieve all Packages with Deployment Count and Status
$packages = Get-CMPackage | ForEach-Object {
    $deployments = Get-CMDeployment | Where-Object { $_.PackageID -eq $_.PackageID }
    [PSCustomObject]@{
        Name            = $_.Name
        DeploymentCount = $deployments.Count
        Status          = if ($deployments) {
            if (($deployments | Select-Object -First 1).Enabled) { 'Enabled' } else { 'Disabled' }
        } else {
            'No Deployments'
        }
    }
}

# Output results
Write-Host "`n===== Applications =====`n"
$applications | Format-Table -AutoSize

Write-Host "`n===== Packages =====`n"
$packages | Format-Table -AutoSize
