$list = @(
    "inversionesfzz.yeminus.com",
    "cercafe.yeminus.com",
    "telematica.yeminus.com",
    "fxmoda.yeminus.com",
    "dys.yeminus.com",
    "agregadosexito.yeminus.com",
    "dima.yeminus.com",
    "sma.yeminus.com",
    "energitel.yeminus.com",
    "farmart.yeminus.com",
    "comercialdelicores.yeminus.com",
    "manzanares.yeminus.com",
    "redvital9.yeminus.com",
    "yeminus.yeminus.com"
)

$file = Read-Host "Por favor indicar cual es la ruta del archivo ps1"
$pass = Get-Credential -UserName "pshell" -Message "Ingresa la contraseña"

$trustedHosts = $list -join ","
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

foreach ($server in $list) {
    try {
        Write-Host "Ejecutando en $server..."
        Invoke-Command -ComputerName $server -FilePath $file -Credential $pass -Authentication Negotiate -ErrorAction Stop
        Write-Host "Ejecutado correctamente en $server"
    } catch {
        Write-Error "Error al ejecutar en $server $_"
    }
}

Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force


    