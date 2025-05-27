import-module dsinternals
$server = 'server' # use AD server
$weakpasswordsfilepath = 'C:\Users\...\weakpasswords.txt' # point to havibeenpwnd or similar plain text password file with each line as new password
$results = (get-adreplaccount -all -server $server | Test-ADPasswordQuality -weakpasswordsfile $weakpasswordsfilepath | Tee-Object -FilePath "C:\temp\passwordsreport.txt")  # output to file

$results.WeakPassword
$adweakpasswords = $results.WeakPassword
$weakpasspasswords = get-content -path $weakpasswordsfilepath


$totalcount = $adweakpasswords.count
$count = $adweakpasswords.count

foreach ($account in $adweakpasswords){
   # foreach ($account in $manualuserlist){
   write-output "$count of $totalcount"
    
    $samaccountname=$account.Split('\')[1]
 #   $samaccountname=$account
    $user = Get-ADReplAccount -SamAccountName $samaccountname -Server $server
    $userhash = $user | format-custom -View nthash
    #new-item -itemtype file -path $hashfilepath
    $hashfilepath = 'C:\Temp\hash.txt' 
    $userhash | Out-File $hashfilepath
    
    (Get-Content $hashfilepath) | where {$_.trim() -ne ""} | Set-Content $hashfilepath
    $hash = Get-Content $hashfilepath


foreach ($WeakPassword in $weakpasspasswords)
{
    $secureweakpassword = $WeakPassword | ConvertTo-SecureString -AsPlainText -ErrorAction SilentlyContinue
    
    if ($secureweakpassword) {
        $weakpasspasswordhash = ConvertTo-NTHash -Password $secureweakpassword
    }
    if ($hash -eq $weakpasspasswordhash){
       Write-Output "$samaccountname has password $weakpassword"
       break 
    }
}
$count--
}
