del "C:\Users\pshell\Scripts\*.ps1" 
cls


$intento = 0
$maxIntentos = 3
$opcionValida = $false

do {
    Write-Host "`n¿Quiere ejecutar el script a un solo servidor o a todos?`n`nOpciones:`n1. Un solo servidor (Enter)`n2. Todos los servidores`n" -ForegroundColor Cyan

    $question = Read-Host "¿Qué opción escoges?" 


    # OPCION 1 
    if ($question -eq "" -or $question -eq "1") {
        $opcionValida = $true

        # --- Submenú de selección de script ---
        $opciones = @{
            '1' = 'Web'
            '2' = 'ChangePass'
            '3' = 'version'
            '4' = 'Firma'
            '5' = 'parche'
            '6' = 'api'
            '7' = 'Ip'
        }

        do {
            Clear-Host
            Write-Host "¿Qué archivo .ps1 desea descargar?" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "    1. Web        - (Actualizar Yemninus Web a partir 4.0)"
            Write-Host "    2. ChangePass - (Cambiar clave a todos los usuarios soporte y consultor)"
            Write-Host "    3. version    - (Descargar última versión del Yeminus Web)"
            Write-Host "    4. Firma      - (Hacer Backup de firmas digitales)"
            Write-Host "    5. parche     - (Actualizar versión parche)"
            Write-Host "    6. api        - (Reiniciar API)"
            Write-Host "    7. Ip         - (Desbloquear IP pública)"
            Write-Host ""
            Write-Host "NOTA: Ingrese el número correspondiente a la opción." -ForegroundColor Yellow

            $opcion = Read-Host "¿Qué opción eliges? (1-7)"
            $opcionValidaInterna = $opciones.ContainsKey($opcion) -and -not [string]::IsNullOrWhiteSpace($opcion)

            if (-not $opcionValidaInterna) {
                Write-Host "`n⚠️  Opción inválida. Presione una tecla para intentar nuevamente..." -ForegroundColor Red
                [void][System.Console]::ReadKey($true)
            }
        } until ($opcionValidaInterna)

        # --- Descargar script seleccionado ---
        $file = $opciones[$opcion]
        Write-Host "`nDescargando $file.ps1..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2

        $url = "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/$file.ps1"
        $destino = "C:\Users\instalacion\Scripts\$file.ps1"
        Invoke-WebRequest -Uri $url -OutFile $destino
        Write-Host "`n✅ Descarga completada" -ForegroundColor Green

        # --- Bucle para conectarse a varios servidores ---
        do {
            $input = Read-Host "`n¿A qué servidores deseas conectarte? (separa por coma: subdominio)"
            $servers = $input -split "," | ForEach-Object { $_.Trim() }

            $trustedHosts = ($servers | ForEach-Object { "$_.yeminus.com" }) -join ","
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

            foreach ($server in $servers) {
                try {
                    $cred = Import-Clixml -Path "C:\Users\instalacion\xml.xml"
                    Write-Host " Ejecutando en $server.yeminus.com" -ForegroundColor Green
                    Invoke-Command -ComputerName "$server.yeminus.com" -FilePath "$destino" -Credential $cred -Authentication Negotiate
                }
                catch {
                    Write-Error "❌ Error al ejecutar en $server"
                }
            }

            $respuesta = Read-Host "`n¿Deseas conectarte a más servidores? (s/n)"
        } while ($respuesta -eq "s")

        Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
        Write-Host "`n✅ Todos los procesos finalizados. TrustedHosts limpiado." -ForegroundColor Yellow

    }



    # OPCION 2 
    elseif ($question -eq "2") {
       
        Write-Host "Opción 2 seleccionada: Ejecutar en todos los servidores - Solo lo hace el personal de infraestructura" -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        $opcionValida = $true

        $pass = Read-Host "¿Quieres continuar? Digita la clave"

        if ($pass -eq "Ocsxxi%123%") {
            # Lista de servidores como string separado por coma
            $serverList = "yeminus,cercafe,inversionesfzz,telematica,fxmoda,dys,agregadosexito,dima,sma,energitel,farmart,comercialdelicores,manzanares,redvital9,teramed"
            # Convertir en array
            $servers = $serverList -split "," | ForEach-Object { $_.Trim() }

            $opciones = @{
                '1' = 'Web'
                '2' = 'ChangePass'
                '3' = 'version'
                '4' = 'Firma'
                '5' = 'parche'
                '6' = 'api'
                '7' = 'Ip'
            }

            do {
                Clear-Host
                Write-Host "¿Qué archivo .ps1 desea descargar?" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "    1. Web        - (Actualizar Yemninus Web a partir 4.0)"
                Write-Host "    2. ChangePass - (Cambiar clave a todos los usuarios soporte y consultor)"
                Write-Host "    3. version    - (Descargar última versión del Yeminus Web)"
                Write-Host "    4. Firma      - (Hacer Backup de firmas digitales)"
                Write-Host "    5. parche     - (Actualizar versión parche)"
                Write-Host "    6. api        - (Reiniciar API)"
                Write-Host "    7. Ip         - (Desbloquear IP pública)"
                Write-Host ""
                Write-Host "NOTA: Ingrese el número correspondiente a la opción." -ForegroundColor Yellow

                $opcion = Read-Host "¿Qué opción eliges? (1-7)"
                $opcionValidaInterna = $opciones.ContainsKey($opcion) -and -not [string]::IsNullOrWhiteSpace($opcion)

                if (-not $opcionValidaInterna) {
                    Write-Host "`n⚠️  Opción inválida. Presione una tecla para intentar nuevamente..." -ForegroundColor Red
                    [void][System.Console]::ReadKey($true)
                }
            } until ($opcionValidaInterna)

            # Descargar el script
            $file = $opciones[$opcion]
            Write-Host "`nDescargando $file.ps1..." -ForegroundColor Cyan
            Start-Sleep -Seconds 2

            $url = "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/$file.ps1"
             $destino = "C:\Users\instalacion\Scripts\$file.ps1"
            Invoke-WebRequest -Uri $url -OutFile $destino
            Write-Host "`n✅ Descarga completada $destino" -ForegroundColor Green

            # Preparar TrustedHosts con dominios completos
            $trustedHosts = ($servers | ForEach-Object { "$_.yeminus.com" }) -join ","
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

            # Ejecutar en cada servidor
            foreach ($server in $servers) {
                try {
                    $cred = Import-Clixml -Path "C:\Users\instalacion\xml.xml"
                    Write-Host " Ejecutando en $server.yeminus.com" -ForegroundColor Green
                    Invoke-Command -ComputerName "$server.yeminus.com" -FilePath "$destino" -Credential $cred -Authentication Negotiate
                }
                catch {
                    Write-Error "❌ Error al ejecutar en $server"
                }
            }

            # Limpiar TrustedHosts
            Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
            Write-Host "`n✅ Todos los procesos finalizados. TrustedHosts limpiado." -ForegroundColor Yellow

        }
        else {
            Write-Host "`n❌ Clave incorrecta. Acceso denegado." -ForegroundColor Red
        }



        Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
        
    }

    else {
        Write-Host "La opción no está disponible. Intente nuevamente." -ForegroundColor Red
        $intento++
    }

} until ($opcionValida -or $intento -ge $maxIntentos)

if (-not $opcionValida) {
    Write-Host "`n❌ Se han excedido los intentos permitidos. Terminando el script." -ForegroundColor Red
    exit
}
