﻿
Write-Host "Version 1.0.11.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force 

mkdir "C:\Windows\iis" 2>$null

#separlos por coma si quiere conectarse mas de un servidor 
$datops = "NOMBRES_SUBDOMINIO"

$info = $datops -split ','

$pass = Get-Credential -Credential "pshell"

foreach ($info in $info) {
    $info = $info.ToUpper()
    Write-Host "Estableciendo conexion con el servidor ($info) ...." -ForegroundColor DarkYellow
    $info = $info.ToLower()
    Start-Sleep -Seconds 3 
    
    Set-Item WSMan:\localhost\Client\TrustedHosts -value $info".yeminus.com" -Force
    Invoke-Command  -FilePath "E:\share\pshellChange.ps1" -ComputerName $info".yeminus.com" -Credential $pass
}


Clear-Item WSMan:\localhost\Client\TrustedHosts -Force


pause    




