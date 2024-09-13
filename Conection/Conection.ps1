
Write-Host "Version 9.0.0.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force 

mkdir "C:\Windows\iis" 2>$null

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "C:\Windows\iis\remote.ps1"

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/Conections.exe" -OutFile "C:\Users\$env:USERNAME\Downloads\Conectionns.exe"

Write-Host "En la carpeta Descargas del usuario $env:USERNAME se ha descargado recientemente el ejecutable. Lo más conveniente sería ejecutar la aplicación desde allí la proxima ejecuccion, ya que podría haber cambios en la aplicación" -ForegroundColor Green

attrib +h "C:\Windows\iis"

$datops = Read-Host "¿Servidor a conectarse, solo ingresa el subdominio?" 

$datops = $datops.ToLower()

Set-Item WSMan:\localhost\Client\TrustedHosts -value $datops".yeminus.com" -Force
Invoke-Command  -FilePath "C:\Windows\iis\remote.ps1" -ComputerName $datops".yeminus.com" -Credential "pshell"


Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Remove-Item -Path "C:\Windows\iis\remote.ps1" -Force



pause    




