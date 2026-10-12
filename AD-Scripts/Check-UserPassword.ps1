Add-Type -AssemblyName System.DirectoryServices.AccountManagement

$domain = "cooperservices.com"
$username = Read-Host "Username"
$password = Read-Host -AsSecureString "Password"
$plainPwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))


$searcher = New-Object System.DirectoryServices.DirectorySearcher
$searcher.Filter = "(sAMAccountName=$username)"
$result = $searcher.FindOne()

if ($result) {
    Write-Host "USER EXISTS: $($result.Path)" -ForegroundColor Green

    $context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
        [System.DirectoryServices.AccountManagement.ContextType]::Domain,
        $domain
    )

    # Check lock status
    $userPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $username)

    if ($userPrincipal.IsAccountLockedOut()) {
        Write-Host "ACCOUNT STATUS: LOCKED" -ForegroundColor Red
    } else {
        Write-Host "ACCOUNT STATUS: UNLOCKED" -ForegroundColor Green
    }

    $isValid = $context.ValidateCredentials($username, $plainPwd)

    if ($isValid) {
        Write-Host "CREDENTIALS VALID" -ForegroundColor Green
    } else {
        Write-Host "CREDENTIALS INVALID" -ForegroundColor Red
    }

} else {
    Write-Host "USER NOT FOUND" -ForegroundColor Red
}