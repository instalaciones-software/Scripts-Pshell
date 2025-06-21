$key = "Ocsxxi%123%"

if ($key -eq "Ocsxxi%123%") {

    $pass = Get-Credential -UserName "pshell" -Message "Ingresa la contraseña"
    $continuar = $true

    # Crear un hash table con las opciones y los scripts correspondientes
    $scripts = @{
        "1" = "ChangePass.ps1"
        "2" = "CrearUsuariosRDP.ps1"
        "3" = "CambiarClaveUsuario.ps1"
        "4" = "descargarVersion.ps1"
        "5" = "backupArchivo.ps1"
    }

    while ($continuar) {
        
        # Solicitar las direcciones de los servidores
        $input = Read-Host "A que servidores deseas conectarte? (separa por coma: IP o dominio)"
        $servers = $input -split "," | ForEach-Object { $_.Trim() }

        Write-Host "
        Escoja una opción:

        1. Cambiar claves de los usuarios de soporte y consultores
        2. Crear Usuarios RDP
        3. Cambiar clave del usuario remota pws
        4. Descargar versión
        5. Hacer backup de archivo
        " -ForegroundColor Cyan

        # Solicitar la opción que desea ejecutar
        $opcion = Read-Host "Que opcion deseas ejecutar?"

        # Verificar si la opción es válida
        if ($scripts.ContainsKey($opcion)) {
            $scriptName = $scripts[$opcion]
            Write-Host "Descargando $scriptName desde GitHub..."
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            try {
                Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/$scriptName" -OutFile ".\$scriptName"
                Write-Host "$scriptName descargado correctamente." -ForegroundColor Green
            }
            catch {
                Write-Error "Hubo un error al descargar $scriptName"
                continue
            }

            # Ejecutar el script descargado en los servidores
            foreach ($server in $servers) {
                try {
                    Write-Host "`n Ejecutando en $server..." -ForegroundColor Cyan
                    Invoke-Command -ComputerName $server -FilePath ".\$scriptName" -Credential $pass -Authentication Negotiate -ErrorAction Stop
                    Write-Host "Ejecutado correctamente en $server" -ForegroundColor Green
                }
                catch {
                    Write-Error "Error al ejecutar en $server"
                }
            }
        } else {
            Write-Host "Opción no válida." -ForegroundColor Red
        }

        # Configurar los servidores de destino como Trusted Hosts
        $trustedHosts = $servers -join ","
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

        # Preguntar si se desea continuar con más servidores
        $respuesta = Read-Host "`n¿Deseas conectarte a más servidores? (s/n)"
        if ($respuesta -ne "s") {
            $continuar = $false
        }
    }

    # Limpiar TrustedHosts después de completar las operaciones
    Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
    Write-Host "`n Todos los procesos finalizados. TrustedHosts limpiado." -ForegroundColor Yellow

}
else {
    Write-Host "Clave incorrecta. Acceso denegado." -ForegroundColor Red
}
