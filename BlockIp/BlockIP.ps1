# Parámetros del script
$logPath = "E:\failed_logins_log.txt"
$threshold = 3  # Número de intentos fallidos para bloquear la IP

# Verificar si el archivo de log existe, si no, crearlo
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType File -Force
}

# Buscar eventos de intentos de inicio de sesión fallidos (ID 4625) en los últimos 10 minutos
$failedLogins = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddMinutes(-10)} | 
    Where-Object { $_.Properties[19].Value -ne $null } |  # Asegurarse de que la IP esté presente en la propiedad 18
    ForEach-Object {
        [PSCustomObject]@{
            TimeGenerated = $_.TimeCreated
            IPAddress = $_.Properties[19].Value  # Usar la propiedad correcta de "Source Network Address"
        }
    }

# Registrar todas las IPs detectadas, incluso si no alcanzan el umbral
foreach ($login in $failedLogins) {
    Add-Content -Path $logPath -Value "$(Get-Date) - Intento fallido desde IP: $($login.IPAddress)"
}

# Contar intentos fallidos por cada IP
$groupedLogins = $failedLogins | Group-Object IPAddress

foreach ($group in $groupedLogins) {
    if ($group.Count -ge $threshold) {
        $ip = $group.Name

        # Revisar si ya ha sido bloqueada
        $alreadyBlocked = netsh advfirewall firewall show rule name=all | Select-String $ip
        if (-not $alreadyBlocked) {
            try {
                # Bloquear la IP en el Firewall de Windows
                Write-Host "Bloqueando IP: $ip con $($group.Count) intentos fallidos"
                netsh advfirewall firewall add rule name="Bloquear IP Maliciosa $ip" dir=in action=block remoteip=$ip
                
                # Registrar el bloqueo en el log
                Add-Content -Path $logPath -Value "$(Get-Date) - IP $ip bloqueada por $($group.Count) intentos fallidos."
            }
            catch {
                Write-Host "Error al bloquear la IP: $ip o escribir en el archivo de log."
            }
        }
    }
}

