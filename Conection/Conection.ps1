
Write-Host "Version 1.0.12.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force 

mkdir "C:\Windows\iis" 2>$null

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "C:\Windows\iis\remote.ps1"

attrib +h "C:\Windows\iis"

$datops = Read-Host "Ingresa el subdominio para conectarte al servidor y añade varios separados por comas" 
$info = $datops -split ','

$pass = Get-Credential -Credential "pshell"


$servidoresConectados = @{}


$subdominiosPorIp = @{}

foreach ($subdominio in $info) {
    $subdominio = $subdominio.Trim().ToLower()
    $nombreCompleto = "$subdominio.yeminus.com"
    
 
    try {
        $ip = [System.Net.Dns]::GetHostAddresses($nombreCompleto)[0].IPAddressToString
    } catch {
        Write-Host "Error al resolver el subdominio $nombreCompleto" -ForegroundColor Red
        continue
    }
    
  
    if (-not $subdominiosPorIp.ContainsKey($ip)) {
        $subdominiosPorIp[$ip] = @()
    }
    $subdominiosPorIp[$ip] += $nombreCompleto
}


foreach ($subdominioGroup in $subdominiosPorIp.GetEnumerator()) {
    $ip = $subdominioGroup.Key
    $subdominiosEnMismoServer = $subdominioGroup.Value

    if ($subdominiosEnMismoServer.Count -gt 1) {
        $subdominiosLista = $subdominiosEnMismoServer -join ', '
        Write-Host "Los subdominios $subdominiosLista están en el mismo servidor. Puedes actualizar varios sitios tras la conexión" -ForegroundColor Cyan
    }

    
    $nombreCompleto = $subdominiosEnMismoServer[0]
    Write-Host "Estableciendo conexión con el servidor ($nombreCompleto) ...." -ForegroundColor DarkYellow
    Start-Sleep -Seconds 3 

  
    if (-not $servidoresConectados.ContainsKey($ip)) {
        $servidoresConectados[$ip] = $nombreCompleto
        
        Set-Item WSMan:\localhost\Client\TrustedHosts -value $nombreCompleto -Force
        Invoke-Command -FilePath "C:\Windows\iis\remote.ps1" -ComputerName $nombreCompleto -Credential $pass
    } else {
        Write-Host "Ya conectado a la IP correspondiente a $nombreCompleto. No es necesario reconectar." -ForegroundColor Green
    }
}




Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Remove-Item -Path "C:\Windows\iis\remote.ps1" -Force


pause    


Enter-PSSession -ComputerName yeminus.yeminus.com -Credential pshell