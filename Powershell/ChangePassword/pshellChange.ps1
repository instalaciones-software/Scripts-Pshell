

$Password = Read-Host -AsSecureString
$UserAccount = Get-LocalUser -Name "USER-REMOTE" # Usuario en el que desea modificar la clave 
$UserAccount | Set-LocalUser -Password $Password