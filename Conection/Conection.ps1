
Write-Host "Version 1.0.12.0" -ForegroundColor Green

Set-ExecutionPolicy Unrestricted -Force 

mkdir "C:\Windows\iis" 2>$null

Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "C:\Windows\iis\remote.ps1"

attrib +h "C:\Windows\iis"

$datops = Read-Host "Ingresa el subdominio para conectarte al servidor y añade varios separados por comas." 
$info = $datops -split ','

$pass = Get-Credential -Credential "pshell"

# Crear un hash para almacenar las conexiones únicas
$servidoresConectados = @{}

# Crear un diccionario para agrupar subdominios por IP
$subdominiosPorIp = @{}

foreach ($subdominio in $info) {
    $subdominio = $subdominio.Trim().ToLower()
    $nombreCompleto = "$subdominio.yeminus.com"
    
    # Obtener la IP del subdominio
    try {
        $ip = [System.Net.Dns]::GetHostAddresses($nombreCompleto)[0].IPAddressToString
    } catch {
        Write-Host "Error al resolver el subdominio $nombreCompleto" -ForegroundColor Red
        continue
    }
    
    # Agrupar subdominios por IP
    if (-not $subdominiosPorIp.ContainsKey($ip)) {
        $subdominiosPorIp[$ip] = @()
    }
    $subdominiosPorIp[$ip] += $nombreCompleto
}

# Establecer conexiones únicas
foreach ($subdominioGroup in $subdominiosPorIp.GetEnumerator()) {
    $ip = $subdominioGroup.Key
    $subdominiosEnMismoServer = $subdominioGroup.Value

    if ($subdominiosEnMismoServer.Count -gt 1) {
        $subdominiosLista = $subdominiosEnMismoServer -join ', '
        Write-Host "Los subdominios $subdominiosLista están en el mismo servidor. Puedes actualizar varios sitios tras la conexión." -ForegroundColor Cyan
    }

    # Establecer conexión con el primer subdominio de la lista
    $nombreCompleto = $subdominiosEnMismoServer[0]
    Write-Host "Estableciendo conexión con el servidor ($nombreCompleto) ...." -ForegroundColor DarkYellow
    Start-Sleep -Seconds 3 

    # Agregar la IP a los servidores conectados
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





