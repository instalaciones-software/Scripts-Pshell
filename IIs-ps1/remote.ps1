$appcmdPath = "$env:SystemRoot\system32\inetsrv\appcmd.exe"
$appcmdPath2 = C:\Windows\System32\inetsrv\appcmd.exe list site /text:name | Sort-Object

<#
|---------------------------------------------------------------------------------------------------------------------|
|           ESTE SCRIPT SOLO ESTA PARA LA EJECUCCION PARA ACTUALIZACIONES DESDE EL EQUIPO PERSONAL                    |
| --------------------------------------------------------------------------------------------------------------------|
#>

#Set-ExecutionPolicy Unrestricted

Write-Host `
    "
         Conexion Establecida

Script Version 1.0.32.0" -ForegroundColor green

Write-Host "Sitios Web Actuales que se pueden actualizar:" -ForegroundColor Cyan 
Write-Host $appcmdPath2 -NoNewline





if (Test-Path -Path "E:\") {
    Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/iis.ps1" -OutFile "E:\apps\geminus\inst\iis.ps1"
    Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/ChangePass.exe" -OutFile "E:\apps\geminus\inst\ChangePass.exe"
}
else {
}



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



$addfile = mkdir "C:\inetpub\versiones\" 2>$null


# $dato = Read-Host "
# ¿ QUE DESEAS REALIZAR ?

# 1. Crear sitio web y variables de entorno 
# 2. Actualizar sitio web (ENTER PARA CONTINUAR)"


$dato = "2"

#create variables in S.O

if ($dato -eq "1") {
    $sitioweb = Read-Host "¿Nombre del sitio web?"
    $motor = Read-Host "¿Tipo de motor Oracle(ENTER) o PostgreSQL(1)?"
    $ip = Read-Host "¿Direccion ip del motor de la base de datos?"
    $pass = Read-Host "¿Clave del usuario admin gem?"
    $peticion = Read-Host "¿Peticiones Desconocidas si tecleas (ENTER) por defecto 0 ?"
    
    
    if ($sitioweb -ne "yeminus") {
        $sitioweb = $sitioweb.ToLower()
        
        
        #CREATE SITE WEB 
        
        # Puerto en el que se ejecutará el sitio
        $Port = 80
        $hostname = "$sitioweb.yeminus.com"
        
        # Ruta física al directorio raíz del sitio web
        $PhysicalPath = mkdir "C:\inetpub\wwwroot\$sitioweb"

        $rutaapi = mkdir "C:\inetpub\wwwroot\$sitioweb\api$sitioweb" 2>$null


        $rutarecurso = mkdir "E:\Apps\$sitioweb" 2>$null
        
        # Crear el directorio físico si no existe
        if (-not (Test-Path $PhysicalPath)) {
            New-Item -ItemType Directory -Path $PhysicalPath
        }
        
        # Crear el sitio web usando appcmd
        & $AppCmdPath add site /name:$sitioweb /bindings:http/*:${Port}:${hostname} /physicalPath:$PhysicalPath
        
        # Verificar que el sitio se haya creado
        & $AppCmdPath list site /name:$sitioweb

        
        & $AppCmdPath add app /site.name:$sitioWeb /path:"/api$sitioWeb" /physicalPath:"$rutaapi" /applicationPool:$sitioWeb 1>$null
        
        & $AppCmdPath add apppool /apppool.name:$sitioWeb /processModel.identityType:"LocalSystem" 1>$null

        & $AppCmdPath add vdir /app.name:$sitioWeb/api$sitioWeb /path:/recursos /physicalPath:$rutarecurso /username:small /password:123456Aa 1>$null


        # CREATE ENVIROMENT VARIABLES

        $url = "http://$sitioweb.yeminus.com/api$sitioweb/"
        $admin = "ADMIN_$sitioweb"
        $NombreBd = "yeminus"
    }
    
    else {

        # CREATE ENVIROMENT VARIABLES

        $admin = Read-Host "¿Usuario admin gem?"
        $NombreBd = Read-Host "¿Servicio de la BD?"
        $url = Read-Host "¿Digitar URL Base?"
        $rutarecurso = Read-Host "¿Cual es la ruta de recursos?" 
        $user = Read-Host "¿Usuario para el recurso virtual?"
        $passuser = Read-Host "¿Clave para la ruta recursos virtual?"

        $admin = $admin.ToUpper()
        $NombreBd = $NombreBd.ToUpper()
        $url = $url.ToLower()
        $user = $user.ToUpper()
        $passuser = $passuser.ToLower()
        $pass = $pass.ToLower()
        $sitioweb = $sitioweb.ToLower()
        
    

        #CREATE SITE WEB 

        $Port = 80
        $hostname = ""
        
        # Ruta física al directorio raíz del sitio web
        $PhysicalPath = mkdir "C:\inetpub\wwwroot\$sitioweb"

        $rutaapi = mkdir "C:\inetpub\wwwroot\$sitioweb\api$sitioweb" 2>$null

        
        # Crear el directorio físico si no existe
        if (-not (Test-Path $PhysicalPath)) {
            New-Item -ItemType Directory -Path $PhysicalPath
        }
        
        # Crear el sitio web usando appcmd
        & $AppCmdPath add site /name:$sitioweb /bindings:http/*:${Port}:${hostname} /physicalPath:$PhysicalPath
        
        # Verificar que el sitio se haya creado
        & $AppCmdPath list site /name:$sitioweb

     
        & $AppCmdPath add app /site.name:$sitioWeb /path:"/api$sitioWeb" /physicalPath:"$rutaapi" /applicationPool:$sitioWeb 1>$null
     
        & $AppCmdPath add apppool /apppool.name:$sitioWeb /processModel.identityType:"LocalSystem" 1>$null

        & $AppCmdPath add vdir /app.name:$sitioWeb/api$sitioWeb /path:/recursos /physicalPath:$rutarecurso /username:$user /password:$passuser 1>$null


    }



    foreach ($dato in $dato) {
        $dato = $sitioweb.ToUpper()
        Write-Host "Nombre de la variable: $nombreVariable1"  # Imprime el nombre de la variable para depurar
        $nombreVariable1 = "${dato}BASEURLyeminus"
        $dato = $sitioweb.ToLower()
        $valorVariable1 = "$url"
    
        
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable1 -Value $valorVariable1 -PropertyType String -Force

        if ($motor -eq "") {
            
            $dato = $sitioweb.ToUpper()
            $admin = $admin.ToUpper()
            $NombreBd = $NombreBd.ToUpper()

            $nombreVariable2 = "${dato}CADENACONEXIONBDyeminus"
            $valorVariable2 = "User Id=$admin;Password=$pass;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$ip)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=$NombreBd)))"
            
            
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable2 -Value $valorVariable2 -PropertyType String -Force
        }


        if ($motor -eq "1") {
            
            $dato = $sitioweb.ToUpper()
            $nombreVariable2 = "${dato}CADENACONEXIONBDyeminus"
            $valorVariable2 = "Server=$ip;Port=5432;Database=$NombreBd;User Id=postgres;Password=$pass;SearchPath=$admin"
            
            
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable2 -Value $valorVariable2 -PropertyType String -Force
        }

        $dato = $sitioweb.ToUpper()

        $nombreVariable3 = "${dato}DIRECTORIOACTIVOyeminus"
        $valorVariable3 = "8214"
    

        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable3 -Value $valorVariable3 -PropertyType String -Force

        if ($motor -eq "") {
            $nombreVariable4 = "${dato}TIPOMOTORBDyeminus"
            $valorVariable4 = "Oracle"
    
        
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable4 -Value $valorVariable4 -PropertyType String -Force
        }
      
        if ($motor -eq "1") {
            $nombreVariable4 = "${dato}TIPOMOTORBDyeminus"
            $valorVariable4 = "PostgreSQL"
    
        
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable4 -Value $valorVariable4 -PropertyType String -Force
        }

        if ($peticion -eq "") {
                        
            $dato = $sitioweb.ToUpper()
            
            $nombreVariable5 = "${dato}PETICIONESDESCONOCIDASPORSEGUNDOyeminus"
            $valorVariable5 = "0"
                
                    
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable5 -Value $valorVariable5 -PropertyType String -Force
        }

        if ($peticion -eq "1") {
            
            $dato = $sitioweb.ToUpper()
            
            $nombreVariable5 = "${dato}PETICIONESDESCONOCIDASPORSEGUNDOyeminus"
            $valorVariable5 = "1"       

            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable5 -Value $valorVariable5 -PropertyType String -Force
        }

    }
    
    Write-Host "Resumen variables de entorno" -ForegroundColor red
    Write-Host "
    Nombre del sitio web: $sitioweb
    Url api: $url
    Ip: $ip
    Usuario Admin:$admin
    Motor de BD: $valorVariable4
    Peticion desconocida: $valorVariable5"

    
    # Write-Host "ESTA OPCION ESTA EN PRUEBAS" -ForegroundColor Red
    # exit
    
}

if ($dato -eq "2" -or $dato -eq "") {
        
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
    $numversion = Read-Host "¿Qué versión vas a implementar? (Ultima version en GitHub: $latestVersion, presiona Enter para descargarla)"


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
            Write-Host "Descargando Version $numversion ......" -ForegroundColor Yellow
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


    # list the names sites web
    $sitiosWeb = Read-Host 'Ingresa los nombres de los sitios web (separados por coma)'
    $sitiosWeb = $sitiosWeb.ToLower()

    if ($sitiosWeb -eq "todos") {

        if (Test-Path $appcmdPath) {
            $appcmdOutput = & $appcmdPath list site /text:name
            $sitiosWeb = $appcmdOutput -join ","
            Write-Host "Sitios actualizar"  -ForegroundColor Green
            Write-Host $sitiosWeb
        }
        else {

        }
    }


    if ($sitiosWeb -eq "yeminus" -or $sitiosWeb -eq "yeminusweb" ) {
        $nombreUsuario = $env:USERNAME

        $contrasena = Read-Host "¿Contraseña del usuario $env:USERNAME ?" -AsSecureString
        $contrasenaTextoPlano = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($contrasena))
   
    } 


    else {
        $nombreUsuario = "small"
        $contrasenaTextoPlano = "123456Aa"

    }

    # Convert the names sites web in array
    $nombresSitiosWeb = $sitiosWeb -split ','


    foreach ($sitioWeb in $nombresSitiosWeb) {
        # stop site web
        $program = & "$comandoAppCmd\appcmd" list vdir "$sitioWeb/" /text:physicalPath
    
        if ($program -ne $null -and $program -ne '') {
            Write-Host "Deteniendo Pools De Aplicacion $sitioWeb" -ForegroundColor yellow 

            foreach ($pool in  $listApis) {
                # stop site web
                & $comandoAppCmd\appcmd stop apppool $sitioWeb 1>$null
                & $comandoAppCmd\appcmd stop apppool "$sitioWeb.$pool"
            }
            # remove files the app
          
            Remove-Item -Recurse -Force "$program\*" -Exclude oldversion.txt    

            foreach ($pool in $listApis) {
                # startup the site web
                & $comandoAppCmd\appcmd start apppool $sitioWeb 1>$null
                & $comandoAppCmd\appcmd start apppool "$sitioWeb.$pool" 1>$null
            }

            Write-Host "IMPLEMENTANDO VERSION $numversion AL SITIO WEB $sitioWeb DESPLEGANDO APLICACION..." -ForegroundColor green 

        }
        else {
            Write-Host "!ATENCIÓN!" -ForegroundColor red -NoNewline
            Write-Host " El sitio web '$sitioWeb' no existe o el nombre es incorrecto."
               
            break OuterLoop
        }
        
        #add the directory resource virtual 
        $rutarecursos = & "${comandoAppCmd}\appcmd" list vdir "$sitioWeb/Api$sitioWeb/recursos" /text:physicalPath
   
        foreach ($nombreApi in $listApis) {

            & "${comandoAppCmd}\appcmd" add app /site.name:$sitioWeb /path:"/$nombreApi.Api" /physicalPath:"$program\$nombreApi.Api" /applicationPool:$sitioWeb.$nombreApi 1>$null

            & "${comandoAppCmd}\appcmd" add vdir /app.name:$sitioWeb/$nombreApi.api /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null

            & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitioWeb.$nombreApi /processModel.identityType:"LocalSystem" 1>$null
        }
    
   
        # path where this the file compress
        $compressedFilePath = "C:\inetpub\versiones\$numversion.zip"

        # path the extract for the files 
        $extractedPath = "C:\inetpub\versiones\"

        # descompress the files
        Expand-Archive -Path $compressedFilePath -DestinationPath $extractedPath -Force

        # path search the file PackageTmp
        $sourcePath = "$extractedPath"

        # Name the file to search 
        $folderName = "PackageTmp"

        #Path where move the files 
        $destinationPath = "$program"

        # fuction for search and rename the file
        function RenameAndMoveFolder {
            param (
                [string]$currentPath
            )

            # search all the files
            $subfolders = Get-ChildItem -Path $currentPath -Directory

            foreach ($folder in $subfolders) {
                # Verify the file
                if ($folder.Name -eq $folderName) {
                    # Rename the files
                    $newName = "api$sitioWeb"
                    Rename-Item -Path $folder.FullName -NewName $newName -Force
            
                    #Move the files rename the destination 
                    Move-Item -Path "$($folder.Parent.FullName)\$newName" -Destination $destinationPath -Force
                }
                else {            
                    RenameAndMoveFolder -currentPath $folder.FullName
                }
            }
        }

        # start the search and rename the files 
        RenameAndMoveFolder -currentPath $sourcePath

        Remove-Item -Recurse -Force "C:\inetpub\versiones\*" -Exclude *.zip

        $sitioWeb = $sitioWeb.ToUpper()

        #Url the apisitioweb in variables everinoment
        $urlYem = [System.Environment]::GetEnvironmentVariable("${sitioWeb}BASEURLyeminus", "Machine")

        
        Invoke-WebRequest $urlYem -UseBasicParsing

        $sitioweb = $sitioweb.ToLower()
        
        $urlYem2 = $urlYem.Replace("api$sitioWeb/", "$sitioWeb")

        Write-Host "Url Web Cliente $urlYem2" -ForegroundColor Yellow
                   
        Write-Host "Por favor hacer la ejecuccion de los 4 pasos" -ForegroundColor Green

        # route the files
        $rutaArchivo = "$program\oldversion.txt"

        # show the files txt 
        $contenidoArchivo = Get-Content -Path $rutaArchivo

           
        if ($sitioWeb -ne "yeminus" -and $sitioWeb -ne "yeminusweb") {
            
            # owerwrite the files txt
            "$numversion" | Out-File -FilePath $rutaArchivo -Force
            
            $EmailDestinatario = "instalaciones@yeminus.com,directorsoporte@yeminus.com,instalaciones2@yeminus.com,instalaciones3@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,cjaramillo@yeminus.com,tics@yeminus.com,dguzman@yeminus.com"
            $EmailEmisor = "noresponder@yeminus.com"
            $Asunto = "📌Actualización Empresa $sitioWeb Version $numversion"
            $sitioWeb = $sitioWeb.ToLower()
            $CuerpoEnHTML = "<p>Cordial saludo Compañeros, Se realiza la actualizacion del yeminus web a la empresa <b>$sitioWeb  con version $numversion este cliente tenia la version $contenidoArchivo </b> Por favor estar pendientes de este cliente por si requieren soporte sobre el producto web</p>

           <p><b>Url Web Cliente:</b></p> $urlYem2
           <p></p>
            <p><b>Atentamente area de infraestructura</b></p>"
            

            
            $SMTPServidor = "mail.yeminus.com"
            $CodificacionCaracteres = [System.Text.Encoding]::UTF8
    
            try {
                $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
                $SMTPMensaje.IsBodyHtml = $true
                $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
                $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
                $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
                $SMTPCliente.EnableSsl = $true
                $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "12345Aa$@/*");
                $SMTPCliente.Send($SMTPMensaje)
     
            }  
    
    
            catch {
                Write-Error -Message "Error al enviar correo electrónico"
            }                                                                                                                
                                                                        
        }
        
    }        
} 