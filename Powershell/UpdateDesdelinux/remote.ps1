# Pedir al usuario que ingrese el código recibido por correo
$codigoIngresado = Read-Host "Clave de ingreso"

# Validar el código
# si los correos de yeminus estan caidos, se puede saltar el codigo con la palabra yeminus
if ($codigoIngresado -eq "insta2025") {
    


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

Script Version 1.0.34.0" -ForegroundColor green

    Write-Host "ATENCION!! Este script ejecutelo cuando la version del cliente sea inferior a la 4.0 " -ForegroundColor Red
    Read-Host

    Write-Host "Sitios Web Actuales que se pueden actualizar:" -ForegroundColor Cyan 
    Write-Host $appcmdPath2 -NoNewline
    Write-Host





    if (Test-Path -Path "E:\") {
        Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/iis.ps1" -OutFile "E:\apps\geminus\inst\iis.ps1"
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


    $listmodel = New-Object Collections.Generic.List[String]
    $listmodel.Add("WebComponents");




    $addfile = mkdir "C:\inetpub\versiones\" 2>$null


    $dato = "1"

    #create variables in S.O


    if ($dato -eq "1") {
        
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
        $sitiosWeb = Read-Host 'Ingresa el subdominio de nuevo' # para actualizar mas de un sitio web separalos por coma (,)

        foreach ($sitiosWeb in $sitiosWeb) {

            if (Test-Path -Path "C:\inetpub\wwwroot\$sitiosWeb\oldversion.txt") {
        
                $file = Get-Content "C:\inetpub\wwwroot\$sitiosWeb\oldversion.txt"
          
                foreach ($LINE in $file) {
                    Write-Output "Version actual $sitiosWeb" $LINE 
                }
            }
            else {
                Write-Host "El archivo que indica que version tienen no existe $sitiosWeb" -ForegroundColor Red
            }
        }

        Start-Sleep -Seconds 2

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
                    & $comandoAppCmd\appcmd stop apppool "$sitioWeb.$listmodel" 1>$null
                    
                    
                    #----------------------------------------------------------------------------------------------
                    
                    & $comandoAppCmd\appcmd delete apppool "$sitioWeb" 1>$null # Borrar appol sitio temporal
                    & $comandoAppCmd\appcmd delete apppool "$sitioWeb.$pool"  1>$null # Borrar app pool temporal
                    & $comandoAppCmd\appcmd delete apppool "$sitioWeb.$listmodel" 1>$null  # Borrar appol componentes temporal
                    
                    
                }
                
                Remove-WebSite -Name "$sitioWeb" 
                
                Read-Host "Crear sitio web con su recurso virtual modificar el app pool V 4.0 (Enter para continuar)"

                # remove files the app
                
                Remove-Item -Recurse -Force "$program\*" -Exclude oldversion.txt    

                
                Write-Host "Actualizando version de $file al $numversion sitio web $sitioWeb DESPLEGANDO APLICACION..." -ForegroundColor green 
                
            }
            else {
                Write-Host "!ATENCIÓN!" -ForegroundColor red -NoNewline
                Write-Host " El sitio web '$sitioWeb' no existe o el nombre es incorrecto."
                
                break OuterLoop
            }
            
            #add the directory resource virtual 
            $rutarecursos = & "${comandoAppCmd}\appcmd" list vdir "$sitioWeb/Api$sitioWeb/recursos" /text:physicalPath
            
                        
            #Read-Host "Cree de nuevo el sitio web con la ruta de recursos (Enter para continuar)"

            foreach ($nombreApi in $listApis) {
                
                # convert a aplication apiyeminus
                & "${comandoAppCmd}\appcmd" add app /site.name:$sitioWeb /path:"/api$sitioWeb" /physicalPath:"$program\api$sitioWeb" /applicationPool:$sitioWeb 1>$null
    
                # add path virtual apiyeminus
                & "${comandoAppCmd}\appcmd" add vdir /app.name:$sitioWeb/"api$sitioWeb" /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
    
                # convert a aplication .api
                & "${comandoAppCmd}\appcmd" add app /site.name:$sitioWeb /path:"/$nombreApi.Api" /physicalPath:"$program\$nombreApi.Api" /applicationPool:$sitioWeb.$nombreApi 1>$null
                
                # add path virtual .api
                & "${comandoAppCmd}\appcmd" add vdir /app.name:$sitioWeb/$nombreApi.api /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null   
    
                # add pool de app
                & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitioWeb.$nombreApi /processModel.identityType:"ApplicationPoolIdentity" 1>$null
    
                # add pool de app the group user IIS_IUSRS
                Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitioWeb" 2>$null
                Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitioWeb.$nombreApi" 2>$null
                Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitioWeb.$listmodel" 2>$null
    
    
                # add new components            
                & "${comandoAppCmd}\appcmd" add app /site.name:$sitioWeb /path:"/$listmodel" /physicalPath:"$program\$listmodel" /applicationPool:$sitioWeb.$listmodel 1>$null
    
                # add directory virtual de los componentes
                C:\Windows\system32\inetsrv\appcmd add vdir /app.name:$sitioWeb/$listmodel /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
    
                # add pool app 
                & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitioWeb.$listmodel /processModel.identityType:"ApplicationPoolIdentity" 1>$null
         
            }

            # Define la ruta de las carpetas y el grupo
            $carpeta1 = "C:\inetpub\wwwroot\$sitioWeb"
            $carpeta2 = "$rutarecursos"
            $grupo = "IIS_IUSRS"  
            $permiso = [System.Security.AccessControl.FileSystemRights]::Modify

            # Función para agregar permisos
            function Agregar-Permisos {
                param (
                    [string]$ruta
                )
                if (Test-Path $ruta) {
                    $acl = Get-Acl $ruta
                    $regla = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo, $permiso, "ContainerInherit, ObjectInherit", "None", "Allow")
                    $acl.SetAccessRule($regla)
                    Set-Acl $ruta $acl
                    Write-Host "Se agrego permisos al grupo IIS_IUSRS a la $ruta."
                }
                else {
                    Write-Host "La carpeta $ruta no existe."
                }
            }

            # Llamar a la función para cada carpeta
            Agregar-Permisos $carpeta1
            Agregar-Permisos $carpeta2
               
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
            
                $EmailDestinatario = "instalaciones@yeminus.com,directorsoporte@yeminus.com,instalaciones2@yeminus.com,instalaciones3@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,tics@yeminus.com,dguzman@yeminus.com,vquintero@yeminus.com"
                $EmailEmisor = "noresponder@yeminus.com"
                $Asunto = "📌Actualización Empresa $sitioWeb Version $numversion"
                $sitioWeb = $sitioWeb.ToLower()
                $CuerpoEnHTML = "<p>Cordial saludo Compañeros, Se realiza la actualizacion del yeminus web a la empresa <b>$sitioWeb  con version $numversion este cliente tenia la version $contenidoArchivo </b> Por favor estar pendientes de este cliente por si requieren soporte sobre el producto web</p>

               <p><b>Url Web Cliente:</b></p> $urlYem2
               <p></p>
                <p><b>Atentamente area de servicio al cliente</b></p>"
            

            
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



}

else {
    Write-Host "clave incorrecto. Intenta nuevamente."
}



