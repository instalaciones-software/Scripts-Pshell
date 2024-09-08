                                                                           
Write-Host "Version 5.0.0" -ForegroundColor Green
    
$pathpass = Read-Host "Para conectarse a otros servidores, es necesario proporcionar la llave de acceso. Por favor, especifique la ruta donde desea descargar los archivos" 
    
Invoke-WebRequest -Uri "https://github.com/instalaciones-software/IIS/releases/download/1.0/hosting.ps1" -OutFile "$pathpass\hosting.ps1"
Invoke-WebRequest -Uri "https://github.com/instalaciones-software/XML/releases/download/1.0.0/key.zip" -OutFile "$pathpass\key.zip"

Read-Host "Por favor descomprimir el archivo comprimido la clave fue suministrada a los directores del area (ENTER) PARA CONTINUAR"
   
ii $pathpass

$datops = Read-Host "¿Servidor a conectarse?" 

Set-Item WSMan:\localhost\Client\TrustedHosts -value $datops".yeminus.com" -Force
$cred = Import-Clixml "$pathpass\key.xml"
Invoke-Command  -FilePath $pathpass\hosting.ps1 -ComputerName $datops".yeminus.com" -Credential $cred



Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Remove-Item -Path "$pathpass\key.xml" -Force
Remove-Item -Path "$pathpass\hosting.ps1" -Force
Remove-Item -Path "$pathpass\key.zip" -Force


Pause
