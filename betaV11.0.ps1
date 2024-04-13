
<#Para resolver el error "No se puede cargar el archivo porque en el sistema está deshabilitada la ejecución de scripts",
 puedes ejecutar el siguiente comando en PowerShell:

 puedes borrar la # al principio de la linea 8 y lo ejecutas, utilizando el comando f8 subrayandola y le das la opcion si a todo
#>

 #Set-ExecutionPolicy Unrestricted

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

# route where this installed the appcmd IIS
$comandoAppCmd = "C:\Windows\System32\inetsrv\"

# which version to deploy
$numversion = Read-Host '¿Qué versión vas a implementar ej (3.0.46.0)?'

$addfile = mkdir "C:\inetpub\versiones\" 2>$null

# define the route download 
$rutaDescarga = "C:\inetpub\versiones\$numversion.zip"

# check if the version this download
if (Test-Path $rutaDescarga) {
    Write-Host "La versión $numversion ya está descargada en $rutaDescarga"
} else {
    # download the version from GitHub
    try {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "https://github.com/yeminus/yeminusweb/releases/download/$numversion/$numversion.zip" -OutFile $rutaDescarga
        Write-Host "!VERSION DESCARGADA¡" -ForegroundColor green -NoNewline
        Write-Host " $numversion exitosamente en $rutaDescarga"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Host "!ATENCIÓN!" -ForegroundColor red  -NoNewline
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

if ($sitiosWeb -eq "yeminus" -or  $sitiosWeb -eq "yeminusweb" ) {
    $nombreUsuario = $env:USERNAME

    $contrasena = Read-Host "¿Contraseña del usuario $env:USERNAME ?" -AsSecureString
   $contrasenaTextoPlano = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($contrasena))
   
   }else {
       $nombreUsuario = "small"
       $contrasenaTextoPlano = "123456Aa"
   }

# Convert the names sites web in array
$nombresSitiosWeb = $sitiosWeb -split ','


foreach ($nombreSitioWeb in $nombresSitiosWeb) {
    # stop site web
    $program = & "$comandoAppCmd\appcmd" list vdir "$nombreSitioWeb/" /text:physicalPath
    
    if ($program -ne $null -and $program -ne '') {
                Write-Host "Deteniendo Pools De Aplicacion $nombreSitioWeb" -ForegroundColor yellow 

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

        Write-Host "IMPLEMENTANDO VERSION $numversion AL SITIO WEB $nombreSitioWeb CARGANDO ..." -ForegroundColor green 

    } else {
        Write-Host "!ATENCIÓN!" -ForegroundColor red -NoNewline
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
$compressedFilePath = "C:\inetpub\versiones\$numversion.zip"

# path the extract for the files 
$extractedPath = "C:\inetpub\versiones\"

# descompress the files
Expand-Archive -Path $compressedFilePath -DestinationPath $extractedPath -Force

# Ruta donde buscar la carpeta PackageTmp
$sourcePath = "$extractedPath"

# Nombre de la carpeta que buscamos
$folderName = "PackageTmp"

# Ruta donde mover la carpeta renombrada
$destinationPath = "$program"

# Función recursiva para buscar y renombrar la carpeta
function RenameAndMoveFolder {
    param (
        [string]$currentPath
    )

    # Busca todas las subcarpetas en la ruta actual
    $subfolders = Get-ChildItem -Path $currentPath -Directory

    foreach ($folder in $subfolders) {
        # Verifica si el nombre de la carpeta coincide
        if ($folder.Name -eq $folderName) {
            # Renombra la carpeta
            $newName = "api$nombreSitioWeb"
            Rename-Item -Path $folder.FullName -NewName $newName -Force
            Write-Host "Carpeta renombrada: $($folder.FullName) => $($folder.Parent.FullName)\$newName"

            # Mueve la carpeta renombrada al destino
            Move-Item -Path "$($folder.Parent.FullName)\$newName" -Destination $destinationPath -Force
            Write-Host "Carpeta movida a: $destinationPath"
        } else {
            # Si no es la carpeta buscada, sigue buscando en las subcarpetas
            RenameAndMoveFolder -currentPath $folder.FullName
        }
    }
}

# Inicia la búsqueda y renombrado de la carpeta
RenameAndMoveFolder -currentPath $sourcePath

Remove-Item -Recurse "C:\inetpub\versiones\*" -Exclude *.zip



$nombreSitioWeb = $nombreSitioWeb.ToUpper()


#Url the apisitioweb in variables everinoment
$urlYem = [System.Environment]::GetEnvironmentVariable("${nombreSitioWeb}BASEURLYEMINUS", "Machine")
    
    Invoke-WebRequest $urlYem
        
    $urlYem2 = $urlYem.Replace("api$nombresSitiosWeb/", '')

    $response = Invoke-WebRequest "$urlYem2/admin.api/api/admin/empresas/getids" 
    
    Write-Host "IDS A ACTUALIZAR SON " $response -ForegroundColor Green
    
    $content = $response.Content | ConvertFrom-Json
    
    foreach ($item in $content) {
        foreach ($element in $item) {
            # CREATE TABLES 
            Write-Host "ACTUALIZANDO EL ID" $element -ForegroundColor green
          Invoke-WebRequest $urlYem2/Admin.Api/api/configuracion/actualizacionbd/creartablas/$element/YEMINUS #>> $program\CreateTable.txt    
        }
    }
    

  # route the files
$rutaArchivo = "$program\oldversion.txt"

# show the files txt 
$contenidoArchivo = Get-Content -Path $rutaArchivo

Write-Host "Abriendo Software Web" -ForegroundColor green 
sleep -Seconds 3 

$urlYem = $urlYem.Replace("api$sitiosWeb", "$sitiosWeb")

Write-Host $urlYem


if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
    [System.Diagnostics.Process]::Start("chrome.exe", "--incognito $urlYem")
}

elseif (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
    [System.Diagnostics.Process]::Start("msedge.exe", "--inprivate $urlYem")
}

else {
    Start-Process "firefox.exe" $urlYem
}


# legend the upgrade
$texto = "SITIO WEB`n`n`n$nombreSitioWeb`n`n`nCordial Saludo, se realizo la actualizacion del Yeminus de la version ($contenidoArchivo) a la version ($numversion)`n`nTema por el que se actualiza:$legend`n`nSr(a) Cliente por favor recordar borrar cache, y hacer la prueba de que funcione el tema de la actualizacion.`n De no hacerlo asi por favor comunicarse a las lineas de soporte de mesa de ayuda`n`n Tel: 310 4210 508         316 7429 438         (6) 333 1303     (6) 334 5036`n`n`n`nTambien Puedes realizar tu mismo el soporte,  para dar mejor trazabilidad al ticket`n`nTutorial de subir tickets: https://youtu.be/LpUyBrDM-fw`n`nLink subir soportes: https://yeminus.yeminus.com/portalcliente/#/`n`n`nCon gusto."

# owerwrite the files txt
"$numversion" | Out-File -FilePath $rutaArchivo -Force

# create files tmp 
$tempFile = [System.IO.Path]::GetTempFileName()
$texto | Out-File -FilePath $tempFile -Force -Encoding UTF8

# start program notepad.exe
    Start-Process notepad.exe -ArgumentList $tempFile
                                                                     
}                                                                            
                                                                          
