
Write-Host "Version 1.0.11.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force 

mkdir "C:\Windows\iis" 2>$null

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "C:\Windows\iis\remote.ps1"

attrib +h "C:\Windows\iis"

$datops = Read-Host "Para conectarte al servidor, simplemente ingresa el subdominio. Puedes añadir multiples servidores separados por comas (,)" 

$info = $datops -split ','

$pass = Get-Credential -Credential "pshell"

foreach ($info in $info) {
    $info = $info.ToUpper()
    Write-Host "Estableciendo conexion con el servidor ($info) ...." -ForegroundColor DarkYellow
    $info = $info.ToLower()
    Start-Sleep -Seconds 3 
    
    Set-Item WSMan:\localhost\Client\TrustedHosts -value $info".yeminus.com" -Force
    Invoke-Command  -FilePath "C:\Windows\iis\remote.ps1" -ComputerName $info".yeminus.com" -Credential $pass
}


Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Remove-Item -Path "C:\Windows\iis\remote.ps1" -Force


pause    




