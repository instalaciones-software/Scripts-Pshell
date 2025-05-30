
$list = @(
    "yeminus.yeminus.com",
    "dio.yeminus.com"
)

$pass = Get-Credential -UserName "pshell" -Message "Ingresa la contraseña"

$trustedHosts = $list -join ","
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

foreach ($server in $list) {
    Invoke-Command -ComputerName $server -ScriptBlock { Get-UICulture } -Credential $pass -Authentication Negotiate
}

Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force