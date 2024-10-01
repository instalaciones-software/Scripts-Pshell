

$Password = Read-Host -AsSecureString
$UserAccount = Get-LocalUser -Name "USER-REMOTE"
$UserAccount | Set-LocalUser -Password $Password