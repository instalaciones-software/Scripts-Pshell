
        #5. Invoke comandos un servidor especifico o varios
        if ($dato -eq "5") {

            Write-Host "Esta opcion es para ejecutar un solo script en uno o varios servidores" -ForegroundColor Yellow

            sleep -Seconds 3

            $tiempo = 0              
                
            $key = Read-Host "Ingresa la clave"

            do {

                if ($key -eq "Ocsxxi%123%") {

                    $continuar = $true

                    while ($continuar) {
        
                        $input = Read-Host "¿A qué servidores deseas conectarte? (separa por coma: IP o dominio)"
                        $servers = $input -split "," | ForEach-Object { $_.Trim() }

                        $file = Read-Host "¿Que archivo .ps1 desea ejecutar
                        
                        1. pshellChange
                        2. ChangePass
                        3. 
                        
                        nota: por favor escribir el nombre
                        
                        ?"

                        if ($file -eq "pshellChange" -or $file -eq "ChangePass") {

                            Write-Host "Descargando...."
                            
                            sleep -Seconds 2 

                            Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/$file.ps1" -OutFile "C:\Users\pshell\$file.ps1"
                            
                                    
                            $trustedHosts = $servers -join ","
                            Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force
                            
                            foreach ($server in $servers) {
                                try {
                                    Write-Host "`n Ejecutando en $server..." -ForegroundColor Cyan
                                    Invoke-Command -ComputerName $server -FilePath "C:\Users\pshell\$file.ps1" -Credential "pshell" -Authentication Negotiate -ErrorAction Stop
                                    Write-Host "Ejecutado correctamente en $server" -ForegroundColor Green
                                }
                                catch {
                                    Write-Error "Error al ejecutar en $server"
                                }
                            }
                            
                                    
                            $respuesta = Read-Host "`n¿Deseas conectarte a más servidores? (s/n)"
                            if ($respuesta -ne "s") {
                                $continuar = $false
                            }
                        }
                            
                                
                        Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
                        Write-Host "`n Todos los procesos finalizados. TrustedHosts limpiado." -ForegroundColor Yellow
                            
                    }
                }
                
                else {
                    Write-Host "Clave incorrecta. Acceso denegado." -ForegroundColor Red
                }
                
            } while ($tiempo -lt 2)
            
                

                        


        }

        #6. BlockIP
        if ($dato -eq "6") {
          
            Write-Host "Bloquear ip publica si hay mas intentos de 3 claves incorrectas" -ForegroundColor Yellow

            sleep -Seconds 3 

            $tiempo = 0

            do {

                # ParÃ¡metros del script
                $logPath = "C:\failed_logins_log.txt"
                $threshold = 5  # NÃºmero de intentos fallidos para bloquear la IP

                # Verificar si el archivo de log existe, si no, crearlo
                if (-not (Test-Path $logPath)) {
                    New-Item -Path $logPath -ItemType File -Force
                }

                # Buscar eventos de intentos de inicio de sesiÃ³n fallidos (ID 4625) en los Ãºltimos 10 minutos
                $failedLogins = Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4625; StartTime = (Get-Date).AddMinutes(-20) } | 
                Where-Object { $_.Properties[19].Value -ne $null } |  # Asegurarse de que la IP estÃ© presente en la propiedad 19
                ForEach-Object {
                    [PSCustomObject]@{
                        TimeGenerated = $_.TimeCreated
                        IPAddress     = $_.Properties[19].Value  # Usar la propiedad correcta de "Source Network Address"
                        UserName      = $_.Properties[5].Value   # Nombre de usuario de la propiedad 5
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

                
            } while ($tiempo -lt 2)
            


        }

    
        # preguntar si quiere ejecutar el script
        if ($dato -eq "1" -or $dato -eq "2" -or $dato -eq "3" -or $dato -eq "4" -or $dato -eq "5" -or $dato -eq "6" -or $dato -eq "7" -or $dato -eq "8" -or $dato -eq "9" -or $dato -eq "10" -or $dato -eq "") {
            $restart = Read-Host "Desea ejecutar el script de nuevo SI(s), NO(ENTER)"
            if ($restart -ne "S" -or $restart -ne "s") {
        
              
                break
            }
            else {
              
            }
        }

        else {
            Write-Host "opcion no valida, intente de nuevo" -ForegroundColor Red
        }

     
     
Write-Host "Saliendo..."
sleep -Seconds 2



