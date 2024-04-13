
<#Para resolver el error "No se puede cargar el archivo porque en el sistema está deshabilitada la ejecución de scripts",
 puedes ejecutar el siguiente comando en PowerShell:

 puedes borrar la # al principio de la linea 8 y lo ejecutas, utilizando el comando f8 subrayandola y le das la opcion si a todo
#>

 #Set-ExecutionPolicy Unrestricted

# list the apis
$listApis = New-Object Collections.Generic.List[String]
$listApis.Add("ActivosFijos");
$listApis.Add("Admin");
$listApis.Add("CajasMenores");
$listApis.Add("ComprasInventarios");
$listApis.Add("ConsultasSQL");
$listApis.Add("CuentasPorCobrar");
$listApis.Add("CuentasPorPagar");
$listApis.Add("DocumentosElectronicos");
$listApis.Add("Encuestas");
$listApis.Add("EntregaMasivaDocumentos");
$listApis.Add("FacturacionPeriodica");
$listApis.Add("Financiero");
$listApis.Add("GestionCapitalHumano");
$listApis.Add("GestionContenidos");
$listApis.Add("GestionTrabajo");
$listApis.Add("Importaciones");
$listApis.Add("InformesComerciales");
$listApis.Add("InformesFinancieros");
$listApis.Add("Interfaces");
$listApis.Add("Licenciamiento");
$listApis.Add("Logistica");
$listApis.Add("MantenimientoMaquinaria");
$listApis.Add("PresupuestoPrivado");
$listApis.Add("PresupuestoPublico");
$listApis.Add("Produccion");
$listApis.Add("Salud");
$listApis.Add("Security");
$listApis.Add("SolicitudesCompraMRP");
$listApis.Add("TablasSistema");
$listApis.Add("Ventas");

# password for the resource virtual
$contrasena = Read-Host "¿Contraseña del usuario $env:USERNAME ?" -AsSecureString
$contrasenaTextoPlano = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($contrasena))

# route where this installed the appcmd IIS
$comandoAppCmd = "C:\Windows\System32\inetsrv\"

# user the autentication for the resource virtual
$nombreUsuario = $env:USERNAME

# which version to deploy
$numversion = Read-Host '¿Qué versión vas a implementar ej (3.0.46.0)?'

# define the route download 
$rutaDescarga = "C:\inetpub\$numversion.zip"

# check if the version this download
if (Test-Path $rutaDescarga) {
    Write-Host "La versión $numversion ya está descargada en $rutaDescarga"
} else {
    # download the version from GitHub
    try {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "https://github.com/yeminus/yeminusweb/releases/download/$numversion/$numversion.zip" -OutFile $rutaDescarga
        Write-Host "!VERSION DESCARGADA¡" -ForegroundColor White -BackgroundColor Green -NoNewline
        Write-Host " $numversion exitosamente en $rutaDescarga"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Host "!ATENCIÓN!" -ForegroundColor white -BackgroundColor red -NoNewline
            Write-Host " La versión $numversion no existe en el repositorio. Valide la última versión en el siguiente enlace: https://github.com/yeminus/yeminusweb/releases/"
        } else {
            Write-Host "Ocurrió un error: $($_.Exception.Message)"
        }

        return
    }
}


# list the names sites web
$sitiosWeb = Read-Host 'Ingresa los nombres de los sitios web (separados por coma)'
$sitiosWeb = $sitiosWeb.ToLower()

# Convert the names sites web in array
$nombresSitiosWeb = $sitiosWeb -split ','


foreach ($nombreSitioWeb in $nombresSitiosWeb) {
       $program = & "$comandoAppCmd\appcmd" list vdir "$nombreSitioWeb/" /text:physicalPath
    
    if ($program -ne $null -and $program -ne '') {
        Write-Host "Deteniendo Pools De Aplicacion $nombreSitioWeb" -ForegroundColor DarkBlue -BackgroundColor White

        foreach ($pool in  $listApis){
            # stop site web
        & $comandoAppCmd\appcmd stop apppool $nombreSitioWeb 1>$null
        & $comandoAppCmd\appcmd stop apppool "$nombreSitioWeb.$pool"
        }
        # remove files the app
        ii "$program\"
        Remove-Item -Recurse "$program\*" -Exclude oldversion.txt    

        foreach($pool in $listApis){
                # startup the site web
        & $comandoAppCmd\appcmd start apppool $nombreSitioWeb 1>$null
        & $comandoAppCmd\appcmd start apppool "$nombreSitioWeb.$pool" 1>$null
        }

        Write-Host "ACTUALIZANDO VERSION AL SITIO WEB $nombreSitioWeb CARGANDO ..." -ForegroundColor black -BackgroundColor yellow
        
    } else {
        Write-Host "!ATENCIÓN!" -ForegroundColor white -BackgroundColor red -NoNewline
        Write-Host " El sitio web '$nombreSitioWeb' no existe o el nombre es incorrecto."

       break OuterLoop
    }
    
    
    #add the directory resource virtual 
    $rutarecursos = & "${comandoAppCmd}\appcmd" list vdir "$nombreSitioWeb/Api$nombreSitioWeb/recursos" /text:physicalPath


    foreach ($nombreApi in $listApis) {
         & "${comandoAppCmd}\appcmd" add app /site.name:$nombreSitioWeb /path:"/$nombreApi.Api" /physicalPath:"$program\$nombreApi.Api" /applicationPool:$nombreSitioWeb.$nombreApi 1>$null
         & "${comandoAppCmd}\appcmd" add vdir /app.name:$nombreSitioWeb/$nombreApi.api /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
         & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$nombreSitioWeb.$nombreApi /processModel.identityType:"LocalSystem" 1>$null
    }
       

    # path where this the file compress
$compressedFilePath = "C:\inetpub\$numversion.zip"

# path the extract for the files 
$extractedPath = "$program"

# descompress the files
Expand-Archive -Path $compressedFilePath -DestinationPath $extractedPath -Force

# create files "apiempresa" on the directory the extract
$apiYeminusPath = Join-Path $extractedPath "apiyeminus"
New-Item -Path $apiYeminusPath -ItemType Directory

# Move the files 'apisiteweb'
Move-Item -Path (Join-Path $extractedPath "Content\D_C\WORKSPACE-GIT\cf-v3\SolApiGeminus\ApiGeminus\obj\x64\Release\Package\PackageTmp\*") -Destination $apiYeminusPath -Force

Remove-Item -Recurse "$program\content" -Exclude apiyeminus ; Remove-Item -Recurse "$program\*.XML"


#Url the apisitioweb in variables everinoment
$urlYem = [System.Environment]::GetEnvironmentVariable("${nombreSitioWeb}BASEURLYEMINUS", "Machine")

    
    Write-Host "!ACTUALIZACION COMPLETADA¡" -ForegroundColor White -BackgroundColor Green -NoNewline
    Write-Host " " "para el sitio web '$nombreSitioWeb' con version: $numversion"


     # route the files
$rutaArchivo = "$program\oldversion.txt"

# show the files txt 
$contenidoArchivo = Get-Content -Path $rutaArchivo


# legend the upgrade
$texto = "SITIO WEB`n`n`n$nombreSitioWeb`n`n`nCordial Saludo, se realizo la actualizacion del Yeminus de la version ($contenidoArchivo) a la version ($numversion)`n`nTema por el que se actualiza:$legend`n`nSr(a) Cliente por favor recordar borrar cache, y hacer la prueba de que funcione el tema de la actualizacion.`n De no hacerlo asi por favor comunicarse a las lineas de soporte de mesa de ayuda`n`n Tel: 310 4210 508         316 7429 438         (6) 333 1303     (6) 334 5036`n`n`n`nTambien Puedes realizar tu mismo el soporte,  para dar mejor trazabilidad al ticket`n`nTutorial de subir tickets: https://youtu.be/LpUyBrDM-fw`n`nLink subir soportes: https://yeminus.yeminus.com/portalcliente/#/`n`n`nCon gusto."

# owerwrite the files txt
"$numversion" | Out-File -FilePath $rutaArchivo -Force

# create files tmp 
$tempFile = [System.IO.Path]::GetTempFileName()
$texto | Out-File -FilePath $tempFile -Force -Encoding UTF8

# start program notepad.exe
Start-Process notepad.exe -ArgumentList $tempFile

    
[System.Diagnostics.Process]::Start("msedge.exe", "--incognito $urlYem")
                                                                             
}                                                                            
                                                                             
