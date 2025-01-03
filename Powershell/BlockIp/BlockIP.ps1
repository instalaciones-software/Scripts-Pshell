# ParÃ¡metros del script
$logPath = "C:\failed_logins_log.txt"
$threshold = 5  # NÃºmero de intentos fallidos para bloquear la IP

# Verificar si el archivo de log existe, si no, crearlo
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType File -Force
}

# Buscar eventos de intentos de inicio de sesiÃ³n fallidos (ID 4625) en los Ãºltimos 10 minutos
$failedLogins = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddMinutes(-20)} | 
    Where-Object { $_.Properties[19].Value -ne $null } |  # Asegurarse de que la IP estÃ© presente en la propiedad 19
    ForEach-Object {
        [PSCustomObject]@{
            TimeGenerated = $_.TimeCreated
            IPAddress = $_.Properties[19].Value  # Usar la propiedad correcta de "Source Network Address"
            UserName = $_.Properties[5].Value   # Nombre de usuario de la propiedad 5
        }
    }

# Registrar todas las IPs detectadas, incluso si no alcanzan el umbral
foreach ($login in $failedLogins) {
    Add-Content -Path $logPath -Value "$(Get-Date) - Intento fallido desde IP: $($login.IPAddress), Usuario: $($login.UserName)"
}

# Contar intentos fallidos por cada IP
$groupedLogins = $failedLogins | Group-Object IPAddress

foreach ($group in $groupedLogins) {
    if ($group.Count -ge $threshold) {
        $ip = $group.Name
        $users = $group.Group | Select-Object -ExpandProperty UserName -Unique -Join ", "

        # Revisar si ya ha sido bloqueada
        $alreadyBlocked = netsh advfirewall firewall show rule name=all | Select-String $ip
        if (-not $alreadyBlocked) {
            try {
                # Bloquear la IP en el Firewall de Windows
                Write-Host "Bloqueando IP: $ip con $($group.Count) intentos fallidos (Usuarios: $users)"
                netsh advfirewall firewall add rule name="Bloquear IP Maliciosa $ip" dir=in action=block remoteip=$ip
                
                # Registrar el bloqueo en el log
                Add-Content -Path $logPath -Value "$(Get-Date) - IP $ip bloqueada por $($group.Count) intentos fallidos. Usuarios: $users."
            }
            catch {
                Write-Host "Error al bloquear la IP: $ip o escribir en el archivo de log."
            }
        }
    }
}

