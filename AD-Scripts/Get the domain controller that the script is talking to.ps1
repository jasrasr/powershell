# Get the domain controller that the script is talking to
$domainController = (Get-ADDomainController -Discover -Service "PrimaryDC").HostName
Write-Output "The script is talking to domain controller: $domainController"