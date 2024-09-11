Write-Host "Version 8.0.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force
    
mkdir "C:\Windows\iis" 2>$null

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "C:\Windows\iis\remote.ps1"

attrib +h "C:\Windows\iis"

$datops = Read-Host "¿Servidor a conectarse?" 

$datops = $datops.ToLower()

Set-Item WSMan:\localhost\Client\TrustedHosts -value $datops".yeminus.com" -Force
Invoke-Command  -FilePath "C:\Windows\iis\remote.ps1" -ComputerName $datops".yeminus.com" -Credential "pshell"


Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Remove-Item -Path "C:\Windows\iis\remote.ps1" -Force



pause    



