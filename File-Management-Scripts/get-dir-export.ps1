Get-ChildItem -Recurse | Format-Table -Property FullName, Length, LastWriteTime -AutoSize

Get-ChildItem -Recurse -Name | Format-Table -AutoSize

Get-ChildItem -Recurse | Select-Object @{Name="RelativePath";Expression={$_.FullName.Replace((Get-Location).Path, ".")}}, Length, LastWriteTime | Format-Table -AutoSize
get-help get-childitem -full

Get-ChildItem -Recurse | Select-Object `
    @{Name="RelativePath";Expression={$_.FullName.Replace((Get-Location).Path, ".")}}, `
    @{Name="Type";Expression={if ($_.PSIsContainer) {"Directory"} else {"File"}}}, `
    Length, LastWriteTime | Format-Table -AutoSize | Out-File output.txt

Get-Content output.txt

Get-ChildItem -Recurse | Select-Object `
    @{Name="RelativePath";Expression={$_.FullName.Replace((Get-Location).Path, ".")}}, `
    @{Name="Type";Expression={if ($_.PSIsContainer) {"Directory"} else {"File"}}}, `
    @{Name="Size (KB)";Expression={if (-not $_.PSIsContainer) {"{0:N2}" -f ($_.Length / 1KB)}}}, `
    LastWriteTime | Format-Table -AutoSize | Tee-Object output.txt
