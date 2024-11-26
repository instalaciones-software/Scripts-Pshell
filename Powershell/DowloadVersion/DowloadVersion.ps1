# #mirar los archivos
# Get-ChildItem "C:\inetpub\versiones\"

# sleep -Seconds 3

# Remove-Item "C:\inetpub\versiones\*.zip"


#URL Api Gituhub 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $url = "https://api.github.com/repos/yeminus/yeminusweb/releases/latest"

    # carry out a get the version 
    $response = Invoke-RestMethod -Uri $url -Method Get

    #get number to version lastest version
    $latestVersion = $response.tag_name

    # route where this installed the appcmd IIS
    $comandoAppCmd = "C:\Windows\System32\inetsrv\"

    # which version to deploy
    $numversion = $latestVersion


    if ([string]::IsNullOrEmpty($numversion)) {
        $numversion = $latestVersion
    }

    # Definir la ruta de descarga
    $rutaDescarga = "C:\inetpub\versiones\$numversion.zip"

    # Verificar si la versión ya está descargada
    if (Test-Path $rutaDescarga) {
        Write-Host "La versión $numversion ya está descargada en $rutaDescarga"
    }
    else {
        # Descargar la versión desde GitHub
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri "https://github.com/yeminus/yeminusweb/releases/download/$numversion/$numversion.zip" -OutFile $rutaDescarga
            Write-Host "!VERSION DESCARGADA!" -ForegroundColor Green -NoNewline
            Write-Host " $numversion exitosamente en $rutaDescarga"
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 404) {
                Write-Host "!ATENCIÓN!" -ForegroundColor Red -NoNewline
                Write-Host " La versión $numversion no existe en el repositorio. Valide la última versión en el siguiente enlace: https://github.com/yeminus/yeminusweb/releases/"
            }
            else {
                Write-Host "Ocurrió un error: $($_.Exception.Message)"
            }
            return
        }
    }

