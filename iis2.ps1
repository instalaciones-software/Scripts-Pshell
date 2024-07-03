﻿
<#Para resolver el error "No se puede cargar el archivo porque en el sistema está deshabilitada la ejecución de scripts",
 puedes ejecutar el siguiente comando en PowerShell:

 puedes borrar la # al principio de la linea 8 y lo ejecutas, utilizando el comando f8 subrayandola y le das la opcion si a todo
#>



#Set-ExecutionPolicy Unrestricted

Write-Host `
"
 ____   ____ ____  ___ ____ _____ ___ _   _  ____           ___ ___ ____
/ ___| / ___|  _ \|_ _|  _ \_   _|_ _| \ | |/ ___|         |_ _|_ _/ ___|
\___ \| |   | |_) || || |_) || |  | ||  \| | |  _   _____   | | | |\___ \
 ___) | |___|  _ < | ||  __/ | |  | || |\  | |_| | |_____|  | | | | ___) |
|____/ \____|_| \_\___|_|    |_| |___|_| \_|\____|         |___|___|____/


Version 1.0.26" -ForegroundColor green




if (Test-Path -Path "E:\") {
    Invoke-WebRequest -Uri "https://github.com/instalaciones-software/IIS/releases/download/1.0/iis.ps1" -OutFile "E:\apps\geminus\inst\iis.ps1"
} else {
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

$appcmdPath = "$env:SystemRoot\system32\inetsrv\appcmd.exe"

$dato = Read-Host "
¿ QUE DESEAS REALIZAR ?

1. Crear variables de entorno 
2. Crear sitios web (BETA)
3. Actualizar sitio web (ENTER PARA CONTINUAR)
Opcion"

#create variables in S.O

if ($dato -eq "1") {
    $sitioweb = Read-Host "¿Nombre del sitio web?"
    $url = Read-Host "¿Url base?"
    $motor = Read-Host "¿Tipo de motor Oracle(ENTER) o PostgreSQL(1)?"
    $NombreBd = Read-Host "¿Servicio de la BD?"
    $ip =  Read-Host "¿Ip del motor de la bd?"
    $admin = Read-Host "¿por favor digite el usuario del admin?"
    $pass = Read-Host "¿Clave del usuario admin?"
    $peticion = Read-Host "¿Peticiones Desconocidas 1 - 0 ?"


    foreach ($dato in $dato) {
        $dato = $sitioweb.ToUpper()
        Write-Host "Nombre de la variable: $nombreVariable1"  # Imprime el nombre de la variable para depurar
        $nombreVariable1 = "${dato}BASEURLYEMINUS"
        $dato = $sitioweb.ToLower()
        $valorVariable1 = "$url"
    
        
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable1 -Value $valorVariable1 -PropertyType String -Force

        if ($motor -eq "") {
            
            $dato = $sitioweb.ToUpper()
            $nombreVariable2 = "${dato}CADENACONEXIONBDYEMINUS"
            $valorVariable2 = "User Id=$admin;Password=$pass;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$ip)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=$NombreBd)))"
            
            
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable2 -Value $valorVariable2 -PropertyType String -Force
        }


        if ($motor -eq "1") {
            
            $dato = $sitioweb.ToUpper()
            $nombreVariable2 = "${dato}CADENACONEXIONBDYEMINUS"
            $valorVariable2 = "Server=$ip;Port=5432;Database=$NombreBd;User Id=postgres;Password=$pass;SearchPath=$admin"
            
            
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable2 -Value $valorVariable2 -PropertyType String -Force
        }

        $dato = $sitioweb.ToUpper()

        $nombreVariable3 = "${dato}DIRECTORIOACTIVOYEMINUS"
        $valorVariable3 = "8214"
    

        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable3 -Value $valorVariable3 -PropertyType String -Force

      if ($motor -eq "") {
        $nombreVariable4 = "${dato}TIPOMOTORBDYEMINUS"
        $valorVariable4 = "Oracle"
    
        
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable4 -Value $valorVariable4 -PropertyType String -Force
      }
      
      if ($motor -eq "1") {
        $nombreVariable4 = "${dato}TIPOMOTORBDYEMINUS"
        $valorVariable4 = "PostgreSQL"
    
        
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable4 -Value $valorVariable4 -PropertyType String -Force
      }

         $dato = $sitioweb.ToUpper()

        $nombreVariable5 = "${dato}PETICIONESDESCONOCIDASPORSEGUNDOYEMINUS"
        $valorVariable5 = "$peticion"
    
        
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name $nombreVariable5 -Value $valorVariable5 -PropertyType String -Force

    }
    
    Write-Host "Resumen variables de entorno" -ForegroundColor red
    Write-Host "
    Nombre del sitio web: $sitioweb
    Url api: $url
    Ip: $ip
    Usuario Admin:$admin
    Motor de BD: $valorVariable4
    Peticion desconocida: $peticion"
}
    
if ($dato -eq "2") {
    
    Write-Host "ESTA OPCION ESTA EN PRUEBAS" -ForegroundColor Red
    exit
    

    # Nombre del sitio web
    $SiteName = Read-Host "Nombre del sitio web"
    
    # Puerto en el que se ejecutará el sitio
    $Port = 80
    $hostname = "$SiteName.yeminus.com"
    
    # Ruta física al directorio raíz del sitio web
    $PhysicalPath = mkdir "C:\inetpub\wwwroot\$SiteName"
    
    # Crear el directorio físico si no existe
    if (-not (Test-Path $PhysicalPath)) {
        New-Item -ItemType Directory -Path $PhysicalPath
    }
    
    # Crear el sitio web usando appcmd
    & $AppCmdPath add site /name:$SiteName /bindings:http/*:${Port}:${hostname} /physicalPath:$PhysicalPath
    
    # Verificar que el sitio se haya creado
    & $AppCmdPath list site /name:$SiteName
    

}

    if ($dato -eq "3" -or $dato -eq "") {
        
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
} else {
    # Descargar la versión desde GitHub
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "https://github.com/yeminus/yeminusweb/releases/download/$numversion/$numversion.zip" -OutFile $rutaDescarga
        Write-Host "!VERSION DESCARGADA!" -ForegroundColor Green -NoNewline
        Write-Host " $numversion exitosamente en $rutaDescarga"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Host "!ATENCIÓN!" -ForegroundColor Red -NoNewline
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

if ($sitiosWeb -eq "todos") {

    if (Test-Path $appcmdPath) {
        $appcmdOutput = & $appcmdPath list site /text:name
        $sitiosWeb = $appcmdOutput -join ","
        Write-Host "Sitios actualizar"  -ForegroundColor Green
        Write-Host $sitiosWeb
    } else {

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


foreach ($nombreSitioWeb in $nombresSitiosWeb) {
    # stop site web
    $program = & "$comandoAppCmd\appcmd" list vdir "$nombreSitioWeb/" /text:physicalPath
    
    if ($program -ne $null -and $program -ne '') {
        Write-Host "Deteniendo Pools De Aplicacion $nombreSitioWeb" -ForegroundColor yellow 

        foreach ($pool in  $listApis) {
            # stop site web
            & $comandoAppCmd\appcmd stop apppool $nombreSitioWeb 1>$null
            & $comandoAppCmd\appcmd stop apppool "$nombreSitioWeb.$pool"
        }
        # remove files the app
        ii "$program\"
        Remove-Item -Recurse -Force "$program\*" -Exclude oldversion.txt    

        foreach ($pool in $listApis) {
            # startup the site web
            & $comandoAppCmd\appcmd start apppool $nombreSitioWeb 1>$null
            & $comandoAppCmd\appcmd start apppool "$nombreSitioWeb.$pool" 1>$null
        }

        Write-Host "IMPLEMENTANDO VERSION $numversion AL SITIO WEB $nombreSitioWeb DESPLEGANDO APLICACION..." -ForegroundColor green 

    }
    else {
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
                $newName = "api$nombreSitioWeb"
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

    $nombreSitioWeb = $nombreSitioWeb.ToUpper()

    #Url the apisitioweb in variables everinoment
    $urlYem = [System.Environment]::GetEnvironmentVariable("${nombreSitioWeb}BASEURLYEMINUS", "Machine")
    
    $urlapi = Invoke-WebRequest $urlYem

    Write-Host $urlapi.Content
        
    $urlYem2 = $urlYem.Replace("api$nombresSitiosWeb/", '')

    $response = Invoke-WebRequest "$urlYem2/admin.api/api/admin/empresas/getids" 
    
    Write-Host "IDS A ACTUALIZAR SON " $response -ForegroundColor Green
    
    $content = $response.Content | ConvertFrom-Json
    
    foreach ($item in $content) {
        foreach ($element in $item) {
            # CREATE TABLES 
            Write-Host "EJECUTANDO 1° PASO AL ID" $element -ForegroundColor green
            $runpaso1 = Invoke-WebRequest $urlYem2/Admin.Api/api/configuracion/actualizacionbd/creartablas/$element/YEMINUS 
            Write-Host $runpaso1.Content

            # CREATE CAMPOS
            Write-Host "EJECUTANDO 2° PASO AL ID" $element -ForegroundColor green
            $runpaso2 = Invoke-WebRequest $urlYem2/Admin.Api/api/configuracion/actualizacionbd/actualizar/$element/YEMINUS/true
            Write-Host $runpaso2.Content
        }
    }
    
    # route the files
    $rutaArchivo = "$program\oldversion.txt"

    # show the files txt 
    $contenidoArchivo = Get-Content -Path $rutaArchivo


    if ($nombreSitioWeb -eq "yeminus" -or $nombreSitioWeb -eq "yeminusweb") {
        $animationDuration = 1  # Seconds per animation cycle
        $totalIterations = 2  # Total number of animation cycles

        for ($iteration = 0; $iteration -lt $totalIterations; $iteration++) {
            for ($i = 0; $i -lt $animationDuration; $i++) {
                Write-Host "¡Iniciando el software web $nombreSitioWeb... Por favor espere!" -NoNewline -ForegroundColor Green
                Start-Sleep -Seconds 1
   
            }
   
            Write-Host "`r`n"  

            Start-Sleep -Seconds 1
        }


        Write-Host "Abriendo Navegador!" -ForegroundColor Green
        sleep -Seconds 2

        $urlYem = $urlYem.Replace("api$sitiosWeb", "$sitiosWeb")

        if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
            [System.Diagnostics.Process]::Start("chrome.exe", "--incognito $urlYem")
        }

        elseif (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
            [System.Diagnostics.Process]::Start("msedge.exe", "--inprivate $urlYem")
        }

        elseif (Test-Path "C:\Program Files (x86)\Internet Explorer\iexplore.exe") {
            [System.Diagnostics.Process]::Start("msedge.exe", "--inprivate $urlYem")
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

   
    # if ($nombreSitioWeb -ne "yeminus" -and $nombreSitioWeb -ne "yeminusweb") {

    #        # owerwrite the files txt
    #      "$numversion" | Out-File -FilePath $rutaArchivo -Force

    #     $EmailDestinatario = "instalaciones@yeminus.com,aarias@yeminus.com,soporte9@yeminus.com,soporte2@yeminus.com,dguzman@yeminus.com,soporte10@yeminus.com,soporte3@yeminus.com,coordinadorsoporte@yeminus.com,directorsoporte@yeminus.com,instalaciones2@yeminus.com,tics@yeminus.com,instalaciones3@yeminus.com"
    #     $EmailEmisor = "noresponder@yeminus.com"
    #     $Asunto = "📌Actualización Empresa $nombreSitioWeb Version $numversion"
    #     $CuerpoEnHTML = "<p>Cordial saludo Compañeros, Se realiza la actualizacion del Yeminus web a la empresa <b>$nombreSitioWeb  con version $numversion este cliente tenia la version $contenidoArchivo </b> Por favor estar pendientes de este cliente por si requieren Soporte Sobre el producto web</p>
    
    #     <p><b>Atentamente Area de instalaciones</b></p>"

    #     $SMTPServidor = "mail.yeminus.com"
    #     $CodificacionCaracteres = [System.Text.Encoding]::UTF8
    
    #     try {
    #         $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
    #         $SMTPMensaje.IsBodyHtml = $true
    #         $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
    #         $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
    #         $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
    #         $SMTPCliente.EnableSsl = $true
    #         $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "12345Aa$@/*");
    #         $SMTPCliente.Send($SMTPMensaje)
     
    #     }  
    
    
    #     catch {
    #         Write-Error -Message "Error al enviar correo electrónico"
    #     }                                                                                                                
                                                                        
    # }
        
}        
    
    # foreach ($nombreSitioWeb in $nombresSitiosWeb) {
    #     $rutaExcel = "c:\$nombreSitioWeb\$nombreSitioWeb.xlsx"

    #     $excel = New-Object -ComObject Excel.Application
    #     $workbook = $excel.Workbooks.Open($rutaExcel)
    #     $worksheet = $workbook.Worksheets.Item(1)

    #     $rango = $worksheet.UsedRange

    #     for ($i = 2; $i -le $rango.Rows.Count; $i++) {
    #         $nombre = $worksheet.Cells.Item($i, 1).Value2
    #         $correo = $worksheet.Cells.Item($i, 2).Value2

    #         if ($nombre -ne $null -and $correo -ne $null) {
    #             # Configuración del correo
    #             $EmailDestinatario = $correo
    #             $EmailEmisor = "noresponder@yeminus.com"
    #             $Asunto = "📌Actualizacion Del Software Web Version $numversion"
    #             $CuerpoEnHTML = "<p>Cordial saludo Sr(a). Cliente</p> 

    # <p>Le informamos que se ha aplicado una actualización a nuestro producto Yeminus Web. La versión <b>($contenidoArchivo)</b> ha sido reemplazada por la versión <b>($numversion)</b> . Por favor, asegúrese de borrar la caché de su navegador para que pueda cargar la nueva versión correctamente. Además, le recomendamos que informe a sus compañeros para que también realicen este proceso.</p>

    # <b><p>Nota:Sr cliente si despues de realizar la actualizacion tiene algun inconveniente por favor escalar el soporte a mesa de ayuda</p></b>
       
    # <p>Tutorial de subir tickets:<p/>

    # <a>https://youtu.be/LpUyBrDM-fw/</a>

    # <p>Link subir tickets:</p>

    # <a> https://yeminus.yeminus.com/portalcliente/#/login</a>

    # <p>Gracias por su atención.</p>"

    #             $SMTPServidor = "mail.yeminus.com"
    #             $CodificacionCaracteres = [System.Text.Encoding]::UTF8

    #             try {
    #                 $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
    #                 $SMTPMensaje.IsBodyHtml = $true
    #                 $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
    #                 $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
    #                 $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
    #                 $SMTPCliente.EnableSsl = $true
    #                 $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "12345Aa$@/*")
    #                 $SMTPCliente.Send($SMTPMensaje)
    #                 Write-Host "Correo enviado a $nombre al correo $EmailDestinatario"
    #             }
    #             catch {
    #                 Write-Error -Message "Error al enviar correo electrónico a $EmailDestinatario"
    #             }
    #         }
    #     }

    #     $workbook.Close()
    #     $excel.Quit()
    # }
}                                                                            
                                                                          

