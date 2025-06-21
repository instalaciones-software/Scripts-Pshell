$appcmdPath = "$env:SystemRoot\system32\inetsrv\appcmd.exe"
$appcmdPath2 = C:\Windows\System32\inetsrv\appcmd.exe list site /text:name | Sort-Object

  
    
Write-Host `
    "
    Conexion Establecida
    
    Version Script 3.0.0.0" -ForegroundColor green
    


# Lista de los apis Que tiene actualmente el Software Yeminus web 
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
$listmodel.Add("Impresion");



# Crea archivo para el descargue de las versiones
$addfile = mkdir "C:\inetpub\versiones\" 2>$null


#contador inicial para ejecutar
$intento = 0


#Set-ExecutionPolicy Unrestricted  #ejecutar cuandola ejecución de scripts está deshabilitada

do {


    $dato = Read-Host " 
            Escoje la opcion.. (1 a 10)
        
            1. Actualizar version completa (ENTER)
            2. Actualizar parche 
            3. Desbloquear ip publica cliente
            4. Reiniciar el api
            5. Invoke comandos (ALL SERVER) 
            6. Backup File
            7. Block Ip
            8. ChangePassAll_Users
            9. pshellChange
            10. Download Version

            
            Opcion"
            
        
    # Condicion Principal
    if ($dato -eq "1" -or $dato -eq "2" -or $dato -eq "3" -or $dato -eq "4" -or $dato -eq "5" -or $dato -eq "6" -or $dato -eq "7" -or $dato -eq "8" -or $dato -eq "9" -or $dato -eq "") {
          
        #1. Actualizar version completa (ENTER)
        if ($dato -eq "1" -or $dato -eq "") {
                    
            Write-Host "ESTE PASO ES PARA ACTUALIZAR LA VERSIÓN COMPLETA DE YEMINUS WEB. ESTE SCRIPT FUNCIONA A PARTIR DE LA VERSIÓN 4.0." -ForegroundColor Yellow

            sleep -Seconds 3
                        
            Write-Host "Sitios Actuales que se pueden actualizar:" -ForegroundColor Cyan 
            Write-Host $appcmdPath2 -NoNewline # Aqui muestra los sitios que tiene el servidor IIS
            Write-Host
        
        
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
            $numversion = Read-Host "¿Qué versión vas a implementar? (Ultima version completa en GitHub: $latestVersion, presiona Enter para descargarla)"
                    
                    
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
            $sitiosWeb = Read-Host 'Nombre del sitio Web' # para actualizar mas de un sitio web separalos por coma (,)
        
            $sitiosWeb = $sitiosWeb.ToLower()
                        
        
        
            # enviar correo codigo de verificacion si el sitio se llama diferente a yeminus, yeminus2 y yeminus web
            if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminus2" -and $sitiosWeb -ne "yeminusweb") {
        
                # Generar Codigo
                $codigo = Get-Random -Minimum 10000 -Maximum 99999
        
                # ENVIAR CODIGO DE ACCESO PARA REALIZAR LA ACTUALIZACION 
                $EmailDestinatario = "instalaciones@yeminus.com,directorsoporte@yeminus.com,soporte3@yeminus.com,tics@yeminus.com,jpineda@yeminus.com,instalaciones2@yeminus.com" # Correos a enviar
                $EmailEmisor = "noresponder@yeminus.com"
                $Asunto = "Codigo de acceso para actualizar los sitios web $sitiosWeb Version $numversion Completa"
                $sitiosWeb = $sitiosWeb.ToLower()
                $CuerpoEnHTML = "Cordial saludo, Para poder continuar con la actualizacion digita el codigo en el script
        
                        <b><p>CODIGO: $codigo </p></b>
                        <p>Atentamente area de Infraestructura</p>"
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
                    Write-Error -Message "Error al enviar correo electronico"
                }    
        
                        
                $temp = 0
        
                do { 
                            
                    # Pedir al usuario que ingrese el código recibido por correo
                    $codigoIngresado = Read-Host "¿Quieres continuar? escribe el Codigo de autenticacion que llega al correo"
                            
                            
                    # Validar el código
                    # si los correos de yeminus estan caidos, se puede saltar el codigo con la palabra yeminus
                    if ($codigoIngresado -eq $codigo -or $codigoIngresado -eq "insta2025*") {
                                
                        Write-Host "Codigo Exitoso" -ForegroundColor Green
                        sleep -Seconds 2
                                 
                        foreach ($sitiosWeb in $sitiosWeb) {
                                
                            if (Test-Path -Path "C:\inetpub\wwwroot\$sitiosWeb\oldversion.txt") {
                                        
                                $file = Get-Content "C:\inetpub\wwwroot\$sitiosWeb\oldversion.txt"

                            }

                            else {
                                Write-Host "El archivo que indica que version tienen no existe $sitiosWeb" -ForegroundColor Red
                            }
                        }
                                
                        Start-Sleep -Seconds 2
                                
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
        
                        break
                
                    }
        
                    else {
                        Write-Host "codigo invalido" -ForegroundColor Red
                        $temp++
                        $temp = 0
                    }
        
                } while ($temp -lt 2)
        
                        
            }
                
                    
            #si el sitio web se llama yeminus, yeminus2 yeminusweb va solicitar la clave del usuario administrador
            if ($sitiosWeb -eq "yeminus" -or $sitiosWeb -eq "yeminusweb" -or $sitiosWeb -eq "yeminus2") {


                # registrar eventos para cuando se realice la actualizacion del yeminus web en servidores propios
                New-EventLog -LogName "Windows Powershell" -Source "IIS_YEMINUS" 2>$null
                Write-EventLog -LogName "Windows Powershell" -Source "IIS_YEMINUS" -EntryType Information -EventID 300  -Message "Se realizo la actualizacion build completa del yeminus web a la version: $numversion al sitio web: $sitiosWeb"


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
                    
                    
            $file = Get-Content "C:\inetpub\wwwroot\$sitiosWeb\oldversion.txt"
                                    
            foreach ($LINE in $file) {
                Write-Output "Version actual $sitiosWeb" $LINE 
            }

            foreach ($sitiosWeb in $nombresSitiosWeb) {

                # stop site web
                $program = & "$comandoAppCmd\appcmd" list vdir "$sitiosWeb/" /text:physicalPath
                        
                if ($program -ne $null -and $program -ne '') {
                    Write-Host "Actualizando...." -ForegroundColor Yellow
                    sleep -Seconds 1
                    Write-Host "Deteniendo Pools De Aplicacion $sitiosWeb" -ForegroundColor yellow 
                    
                    foreach ($pool in  $listApis) {
                                                            
                        # stop site web
                        & $comandoAppCmd\appcmd stop apppool $sitiosWeb 1>$null
                        & $comandoAppCmd\appcmd stop apppool "$sitiosWeb.$pool"
                        & $comandoAppCmd\appcmd stop apppool "$sitiosWeb.$listmodel" 1>$null
                    
                    }
                    # remove files the app
                            
                    Remove-Item -Recurse -Force "$program\*" -Exclude oldversion.txt    
                    
                    foreach ($pool in $listApis) {
                        # startup the site web
                        & $comandoAppCmd\appcmd start apppool $sitiosWeb 1>$null
                        & $comandoAppCmd\appcmd start apppool "$sitiosWeb.$pool" 1>$null
                        & $comandoAppCmd\appcmd start apppool "$sitiosWeb.$listmodel" 1>$null
                    
                    }
                    
                    Write-Host "Actualizando version de $file al $numversion sitio web $sitiosWeb DESPLEGANDO APLICACION..." -ForegroundColor green 

                    $rutaArchivo = "$program\oldversion.txt"

                    # owerwrite the files txt
                    "$numversion" | Out-File -FilePath $rutaArchivo -Force
                    
                }
                else {
                    Write-Host "!ATENCIÓN!" -ForegroundColor red -NoNewline
                    Write-Host " El sitio web '$sitiosWeb' no existe o el nombre es incorrecto."
                                
                    break OuterLoop
                }
                            
                #add the directory resource virtual 
                $rutarecursos = & "${comandoAppCmd}\appcmd" list vdir "$sitiosWeb/Api$sitiosWeb/recursos" /text:physicalPath
                    
                    
                foreach ($nombreApi in $listApis) {
                                
                    # convert a aplication apiyeminus
                    & "${comandoAppCmd}\appcmd" add app /site.name:$sitiosWeb /path:"/api$sitiosWeb" /physicalPath:"$program\api$sitiosWeb" /applicationPool:$sitiosWeb 1>$null
                        
                    # add path virtual apiyeminus
                    & "${comandoAppCmd}\appcmd" add vdir /app.name:$sitiosWeb/"api$sitiosWeb" /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
                        
                    # convert a aplication .api
                    & "${comandoAppCmd}\appcmd" add app /site.name:$sitiosWeb /path:"/$nombreApi.Api" /physicalPath:"$program\$nombreApi.Api" /applicationPool:$sitiosWeb.$nombreApi 1>$null
                                    
                    # add path virtual .api
                    & "${comandoAppCmd}\appcmd" add vdir /app.name:$sitiosWeb/$nombreApi.api /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null   
                        
                    # add pool de app
                    & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitiosWeb.$nombreApi /processModel.identityType:"ApplicationPoolIdentity" 1>$null
                        
                    # add pool de app the group user IIS_IUSRS
                    Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitiosWeb" 2>$null
                    Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitiosWeb.$nombreApi" 2>$null
                    Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitiosWeb.$listmodel" 2>$null
                        

                    foreach ($listmodel in $listmodel) {
                        
                        # add new components            
                        & "${comandoAppCmd}\appcmd" add app /site.name:$sitiosWeb /path:"/$listmodel" /physicalPath:"$program\$listmodel" /applicationPool:$sitiosWeb.$listmodel 1>$null
                            
                        # add directory virtual de los componentes
                        C:\Windows\system32\inetsrv\appcmd add vdir /app.name:$sitiosWeb/$listmodel /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
                            
                        # add pool app 
                        & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitiosWeb.$listmodel /processModel.identityType:"ApplicationPoolIdentity" 1>$null
                    }
                        
                            
                }
                    
                # # Define la ruta de las carpetas y el grupo
                # $carpeta1 = "C:\inetpub\wwwroot\$sitiosWeb"
                # $carpeta2 = "$rutarecursos"
                # $grupo = "IIS_IUSRS"  
                # $permiso = [System.Security.AccessControl.FileSystemRights]::Modify
                    
                # # Función para agregar permisos
                # function Agregar-Permisos {
                #     param (
                #         [string]$ruta
                #     )
                #     if (Test-Path $ruta) {
                #         $acl = Get-Acl $ruta
                #         $regla = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo, $permiso, "ContainerInherit, ObjectInherit", "None", "Allow")
                #         $acl.SetAccessRule($regla)
                #         Set-Acl $ruta $acl
                #         Write-Host "Se agrego permisos al grupo IIS_IUSRS a la $ruta."
                #     }
                #     else {
                #         Write-Host "La carpeta $ruta no existe."
                #     }
                # }
                    
                # # Llamar a la función para cada carpeta
                # Agregar-Permisos $carpeta1
                # Agregar-Permisos $carpeta2
                    
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
                            $newName = "api$sitiosWeb"
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
                    
                $sitiosWeb = $sitiosWeb.ToUpper()
                    
                #Url the apisitiosweb in variables everinoment
                $urlYem = [System.Environment]::GetEnvironmentVariable("${sitiosWeb}BASEURLyeminus", "Machine")
                    
                            
                Invoke-WebRequest $urlYem -UseBasicParsing
                    
                $sitiosweb = $sitiosweb.ToLower()
                            
                $urlYem2 = $urlYem.Replace("api$sitiosWeb/", "$sitiosWeb")
                    
                Write-Host "Url Web Cliente $urlYem2" -ForegroundColor Yellow
                                    
                Write-Host "Por favor hacer la ejecuccion de los 4 pasos" -ForegroundColor Green
                    
                # route the files
                $rutaArchivo = "$program\oldversion.txt"

                    
                # show the files txt 
                $numversion = Get-Content -Path $rutaArchivo
                     
                # envia correo si el sitio web se llama diferente a yeminus, yeminusweb
                if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminusweb" -and $sitiosWeb -ne "yeminus2") {
                                
                               
                    $EmailDestinatario = "instalaciones@yeminus.com,jpineda@yeminus.com,directorsoporte@yeminus.com,instalaciones3@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,tics@yeminus.com,vquintero@yeminus.com,aarias@yeminus.com "
                    $EmailEmisor = "noresponder@yeminus.com"
                    $Asunto = "📌Actualización Empresa $sitiosWeb Version $numversion"
                    $sitiosWeb = $sitiosWeb.ToLower()
                    $CuerpoEnHTML = "<p>Cordial saludo, Se realiza la actualizacion del yeminus web a la empresa <b>$sitiosWeb  con version $numversion este cliente tenia la version $file </b> Por favor estar pendientes de este cliente por si requieren soporte sobre el producto web</p>
                    
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
                        Write-Host ""
                    }                                                                                                                
                                                                                            
                }
                            
            }  
        
            $intento = 0
        } 

        #2. Actualizar parche 
        if ($dato -eq "2" ) {
              
            Write-Host "ESTE PASO SE EJECUTA CUANDO LA VERSION SALGA CON UN PARCHE, ES DECIR ALGUN .API QUE SE HAYA SOLUCINADO LA INCONSISTENCIA, ESTE PASO NO FUNCIONA PARA ACTUALIZAR VERSION COMPLETA" -ForegroundColor Yellow
              
            sleep -Seconds 3

            Write-Host "Sitios Actuales que se pueden actualizar:" -ForegroundColor Cyan 
            Write-Host $appcmdPath2 -NoNewline # Aqui muestra los sitios que tiene el servidor IIS
            Write-Host
           
           
            #URL Api Gituhub 
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $url = "https://api.github.com/repos/yeminus/yeminusweb/releases/latest"
                            
            # carry out a get the version 
            $response = Invoke-RestMethod -Uri $url -Method Get
                            
            #get number to version lastest version
            $latestVersion = $response.tag_name
                    
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
                    
            $numversion = Read-Host "¿Qué versión vas a implementar? (Ultima version en parche: $latestVersion, presiona Enter para descargarla)"
                    
                    
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
                    
                            
            # path where this the file compress
            $compressedFilePath = "C:\inetpub\versiones\$numversion.zip"
                    
            # path the extract for the files 
            $extractedPath = mkdir "C:\inetpub\versiones\$numversion"  2>$null
                    
            # descompress the files
            Expand-Archive -Path $compressedFilePath -DestinationPath $extractedPath -Force 
                        
            Write-Host "El parche contiene estas app" -ForegroundColor Yellow
            Get-ChildItem "C:\inetpub\versiones\$numversion" -Name
            $parche = Get-ChildItem "C:\inetpub\versiones\$numversion" -Name
                    
            $parche = $parche -split ","
                    
            # list the names sites web
            $sitiosWeb = Read-Host 'Nombre del sitio Web' 
                    
            $sitiosWeb = $sitiosWeb -split ","
                    
            $sitiosWeb = $sitiosWeb.ToLower()
                        
            # Condicion para servidores hosting
            if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminus2") {
                    
                # Generar Codigo
                $codigo = Get-Random -Minimum 10000 -Maximum 99999

                # Descargar archivo ps1 en los servidores hosting
                Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1" -OutFile "E:\apps\geminus\inst\remote.ps1"
           
                # ENVIAR CODIGO DE ACCESO PARA REALIZAR LA ACTUALIZACION 
                $EmailDestinatario = "instalaciones@yeminus.com,directorsoporte@yeminus.com,soporte3@yeminus.com,tics@yeminus.com,jpineda@yeminus.com,instalaciones2@yeminus.com" # Correos a enviar
                $EmailEmisor = "noresponder@yeminus.com"
                $Asunto = "Codigo de acceso para actualizar los sitios web $sitiosWeb Version $numversion Parche"
                $sitiosWeb = $sitiosWeb.ToLower()
                $CuerpoEnHTML = "Cordial saludo, Para poder continuar con la actualizacion digita el codigo en el script
           
                        <b><p>CODIGO: $codigo </p></b>
                        <p>Atentamente area de Infraestructura</p>"
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
                    Write-Error -Message "Error al enviar correo electronico"
                }    
           
           
                $tanteo = 0
           
                        
                do {
                    $codigoIngresado = Read-Host "¿Quieres continuar? escribe el Codigo de autenticacion que llega al correo" 
           
                    # Validar el código
                    # si los correos de yeminus estan caidos, se puede saltar el codigo con la palabra insta2025*
                    if ($codigoIngresado -eq "$codigo" -or $codigoIngresado -eq "insta2025*") {
                    
                        Write-Host "Validando codigo" -ForegroundColor Yellow
                        sleep -Seconds 3
                        
                        if ($codigoIngresado -eq $codigo -or $codigoIngresado -eq "insta2025*"  ) {
                            Write-Host "Codigo Valido" -ForegroundColor Green
                    
                        }
                        else {
                            Write-Host "Codigo Invalido, Intente de nuevo" -ForegroundColor Red
                        }
                    
                        break
                    }
                    
                    else {
                        Write-Host "Codigo errado ultimo intento, Escribe de nuevo el codigo" -ForegroundColor Yellow
                        sleep -Seconds 2
                          
                        $tanteo++
                    }
                    
                } while ($tanteo -lt 2)             
            } 
                    
            # Convert the names sites web in array
            $nombresSitiosWeb = $sitiosWeb -split ','
                                        
            foreach ($sitiosWeb in $nombresSitiosWeb) {
                $program = & "$comandoAppCmd\appcmd" list vdir "$sitiosWeb/" /text:physicalPath
         
                if ($program -ne $null -and $program -ne '') {
                  
                }
                else {
                    Write-Host " !ATENCIÓN! El sitio web '$sitiosWeb' no existe o el nombre es incorrecto." -ForegroundColor Red
                 
                    break OuterLoop
                }
     
            }

            if ($sitiosWeb -eq "yeminus" -or $sitiosWeb -eq "yeminus2") {
            
                # registrar eventos para cuando se realice la actualizacion del yeminus web en servidores propios
                New-EventLog -LogName "Windows Powershell" -Source "IIS_YEMINUS" 2>$null
                Write-EventLog -LogName "Windows Powershell" -Source "IIS_YEMINUS" -EntryType Information -EventID 300  -Message "Se realizo la actualizacion del yeminus web a la version parche: $numversion al sitio web: $sitiosWeb"   
            }

            Read-Host

            # aqui empieza a desplegar la version
            $zipArchivo = "C:\inetpub\versiones\$numversion.zip"
            $destinoRuta = "C:\inetpub\wwwroot\$sitiosWeb"          
            $modulosRuta = "C:\inetpub\wwwroot\$sitiosWeb\modules"   
     
                 
            if (-Not (Test-Path $destinoRuta)) {
                New-Item -ItemType Directory -Force -Path $destinoRuta
            }
            if (-Not (Test-Path $modulosRuta)) {
                New-Item -ItemType Directory -Force -Path $modulosRuta
            }
            Expand-Archive -Path $zipArchivo -DestinationPath $destinoRuta -Force
            $archivosInternos = Get-ChildItem -Path $destinoRuta -Filter "*.zip"
             
            foreach ($archivo in $archivosInternos) {
                $nombreCarpeta = [System.IO.Path]::GetFileNameWithoutExtension($archivo.Name)
             
                if ($archivo.Name -like "*.api.zip") {
     
                    $carpetaDestino = Join-Path $destinoRuta $nombreCarpeta
     
                                     
                    if (Test-Path $carpetaDestino) {
                        Remove-Item -Path $carpetaDestino -Recurse -Force
                    }
     
                    New-Item -ItemType Directory -Force -Path $carpetaDestino
     
                    $nombreCarpeta = "$nombreCarpeta"
                    $nombreCarpeta = $nombreCarpeta -replace "\.api$", ""  # Elimina ".api" al final del texto
                    $nameapi = "$sitiosWeb." + $nombreCarpeta
     
                                                 
                    & $comandoAppCmd\appcmd stop apppool $nameapi 1>$null
                    Expand-Archive -Path $archivo.FullName -DestinationPath $carpetaDestino -Force
                    & $comandoAppCmd\appcmd start apppool $nameapi 1>$null
     
                }
                elseif ($archivo.Name -eq "yeminus.zip") {
                    & $comandoAppCmd\appcmd stop apppool $sitiosWeb 1>$null
                    Remove-Item  -Force -Recurse "C:\inetpub\wwwroot\$sitiosWeb\$sitiosWeb" 
                    & $comandoAppCmd\appcmd start apppool $sitiosWeb 1>$null 


                    $carpetaDestino = Join-Path $destinoRuta $nombreCarpeta
                 
                    if (Test-Path $carpetaDestino) {
                        Remove-Item -Path $carpetaDestino -Recurse -Force
                    }
     
                    New-Item -ItemType Directory -Force -Path $carpetaDestino
     
                    Expand-Archive -Path $archivo.FullName -DestinationPath $carpetaDestino -Force 
                    
                }

     
                elseif ($archivo.Name -ne "yeminus.zip") {
     
                    $carpetaDestino = Join-Path $modulosRuta $nombreCarpeta
     
                    if (Test-Path $carpetaDestino) {
                        Remove-Item -Path $carpetaDestino -Recurse -Force
                    }
     
                    New-Item -ItemType Directory -Force -Path $carpetaDestino
                    Expand-Archive -Path $archivo.FullName -DestinationPath $carpetaDestino -Force
                     
                }
            }
             
     
            #LLAMAR LA URL
            $urlYem = [System.Environment]::GetEnvironmentVariable("${nombresSitiosWeb}BASEURLyeminus", "Machine")
            $urlYem2 = $urlYem.Replace("api$nombresSitiosWeb/", "")
            $urlcomplet = $urlyem2 + $sitiosweb
                     
            (Get-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\assets\config-resources\config.js") -replace "https://desarrollo.yeminus.com:8080/apiyeminus/", $urlYem | Set-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\assets\config-resources\config.js"
            (Get-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\main.09bf5c1c4ec603e4.js") -replace "https://desarrollo.yeminus.com:8080/", $urlYem2  | Set-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\main.09bf5c1c4ec603e4.js"
            (Get-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\index.html") -replace "/yeminus/", "/$nombresSitiosWeb/"  | Set-Content "C:\inetpub\wwwroot\$sitiosweb\$sitiosweb\index.html"
     
            
            if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminus2" -and $sitiosWeb -ne "yeminusweb") {
                
                    
                Rename-Item -Path "C:\inetpub\wwwroot\$sitiosWeb\yeminus" -NewName "$sitiosWeb"
            }
            Remove-Item  -Force -Recurse "C:\inetpub\versiones\"  -Exclude *.zip 
            Remove-Item  -Force  -Recurse "C:\inetpub\wwwroot\$sitiosWeb\*.zip"  
                
     

            if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminus2" -and $sitiosWeb -ne "yeminusweb") {
                #Enviar correo para confirmar actualizacion del yeminus web, envia cuando el sitio web no se llama yeminus es decir envia cuando se actualiza hosting..       
                if ($sitiosWeb -ne "yeminus" -or $sitiosWeb -ne "yeminus2" ) {
                    $EmailDestinatario = "instalaciones@yeminus.com,jpineda@yeminus.com,directorsoporte@yeminus.com,instalaciones3@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,tics@yeminus.com,vquintero@yeminus.com,aarias@yeminus.com " # Correos a enviar
                    $EmailEmisor = "noresponder@yeminus.com"
                    $Asunto = "Actualizacion de los sitios web $sitiosWeb con Version N. Parche $numversion "
                    $sitiosWeb = $sitiosWeb.ToLower()
                    $CuerpoEnHTML = "Cordial saludo, se realiza la actualizacion del yeminus web a los sitios $sitiosWeb con las siguientes 
                                        
                                        <b><p>MODULOS: $parche</p></b>
                                
                                        
                                        <b><p>URL WEB:$urlcomplet</p></b>
                                        <p>Atentamente area de Servicio al cliente</p>"
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
                        Write-Error -Message "Error al enviar correo electronico"
                    } 
                 
                }
            }

            $intento = 0
        }         

        #3. Desbloquear ip publica cliente
        if ($dato -eq "3") {
           
            Write-Host "ESTA OPCION ES PARA DESBLOQUEAR IP PUBLICA DEL CLIENTE" -ForegroundColor Yellow

            sleep -Seconds 3

            $time = 0
           
            do {
           
                  
           
                $key = "YemCol*"
                    
                $acceso = Read-Host "ingrese la clave de acceso"
                    
                if ($acceso -eq "$key" -or $acceso -eq "insta2025*") {
           
                    Write-Host `
                        "
                        _   _ _ __ | | ___   ___| | __ (_)_ __  
                    | | | | '_ \| |/ _ \ / __| |/ / | | '_ \ 
                    | |_| | | | | | (_) | (__|   <  | | |_) |
                        \__,_|_| |_|_|\___/ \___|_|\_\ |_| .__/ 
                                                        |_|  
                        " -ForegroundColor Green
                    
                    # Solicitar al usuario que ingrese la IP a desbloquear
                        
                    
                    $ip = Read-Host "Ingresa la IP que deseas desbloquear"
                    
                    # Eliminar la regla de firewall correspondiente
                    netsh advfirewall firewall delete rule name="Bloquear IP Maliciosa $ip"
                    
                    #Write-Host "La regla para bloquear la IP $ip ha sido eliminada."
                    
                    $ruta = "E:\failed_logins_log.txt"
                    $patron = "Intento fallido desde IP: $ip" 
                    # Buscar archivo de failed login
                    
                    Select-String -Path $ruta -Pattern $patron 
                    
                    # Definir el patrón de búsqueda
                    $patron = "Intento fallido desde IP: $ip"
                    
                    
                    (Get-Content "E:\failed_logins_log.txt") -replace "$ip", "ok" | Set-Content "E:\failed_logins_log.txt"
                    
                    
                    Write-Host "proceso finalizado con exito"
           
                    break
                        
                }
                    
                    
                else {
                    $time++
                    Write-Host "clave incorrecta, intente de nuevo"
                    sleep -Seconds 2
                }
                    
                $intento = 0
                    
                    
                else {
                    $intento++
                }
            } 
            
            while ($time -lt 2 )
            


          
        }

        # 4. Reiniciar el api
        if ($dato -eq "4") {

            Write-Host "ESTA OPCION ES PARA REINICIAR EL API DE LOS SITIOS WEB DE LOS CLIENTES, ESTO CONLLEVA A QUE EL SITIO WEB SE LES VA CAER POR UN MOMENTO" -ForegroundColor Yellow

            sleep -Seconds 3

            $key = "YemCol*" 
            $tiempo = 0
            
            do {
            
                $acceso = Read-Host "ingrese la clave de acceso"
            
                if ($acceso -eq "$key" -or $acceso -eq "insta2025*") {
                    Write-Host `
                        "
              _ __ ___| |__   ___   ___ | |_    __ _ _ __  _ 
             | '__/ _ \ '_ \ / _ \ / _ \| __|  / _` | '_ \| |
             | | |  __/ |_) | (_) | (_) | |_  | (_| | |_) | |
             |_|  \___|_.__/ \___/ \___/ \__|  \__,_| .__/|_|
                                                    | |                                    
                " -ForegroundColor Green
            
                    # Importa el módulo WebAdministration
                    Import-Module WebAdministration
            
            
                    # Define el nombre del sitio a reiniciar
                    $sitio = Read-Host "Ingresa el nombre del sitio que deseas reiniciar"
            
                    # Detener Poolapps sitio web
                    $comandoAppCmd = "C:\Windows\System32\inetsrv\" 
            
                    Write-Host "Deteniendo Poolapps $sitio" -ForegroundColor Yellow
            
                    & $comandoAppCmd\appcmd stop apppool $sitio
            
                    sleep -Seconds 2
            
                    # Iniciar Poolapps sitio web
            
                    & $comandoAppCmd\appcmd start apppool $sitio
            
                    # Detener el sitio web
            
                    Write-Host "Deteniendo Sitio $sitio" -ForegroundColor Yellow
            
                    & $comandoAppCmd\appcmd stop site $sitio
            
                    sleep -Seconds 2
            
                    # Iniciar el sitio web 
            
                    & $comandoAppCmd\appcmd start site $sitio
            
            
                    Write-Host "El api $sitio ha sido reiniciado correctamente."
            
                    Break
                }
            
            
                else {
                    Write-Host "clave incorrecta"
                }
                
            } while ($tiempo -lt 2)
            
            
            
        }
        
        #5. Invoke comandos (ALL SERVER) 
        if ($dato -eq "5") {

            Write-Host "Esta opcion es para ejecutar un solo script en todos los servidores de yeminus" -ForegroundColor Yellow

            sleep -Seconds 3

            $tiempo = 0              
                
            $key = Read-Host "Ingresa la clave"

            do {

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
                        }
                        else {
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

                
            } while ($tiempo -lt 2)
            
        }

        #6. Backup File
        if ($dato -eq "6") {

            $pass = Read-Host "Por favor ingresa la clave"
            
            if ($pass -eq "insta2025*") {

                sleep -Seconds 3
                
                Write-Host "Este paso es para hacer backup de los formatos de las empresas" -ForegroundColor Yellow

                sleep -Seconds 3

                do {

                    $rutaCarpeta = "E:\backups"

                    if (Test-Path $rutaCarpeta) {
                        Write-Host "La carpeta ya existe en $rutaCarpeta"
                    }
                    else {
                        New-Item -ItemType Directory -Path $rutaCarpeta
                        Write-Host "Se ha creado la carpeta en $rutaCarpeta"
                    }

                    $rutaArchivo = 'E:\Apps\list.txt'
                    $contenidoArchivo = Get-Content -Path $rutaArchivo

    
                    $fechaini = Get-Date -Format 'yyyyMMdd'
                    $currentDate = [datetime]::ParseExact($fechaini, 'yyyyMMdd', $null)


                    $previousDate = $currentDate.AddDays(-3698) # 8 dias atras 
                    $fechaanterior = $previousDate.ToString('yyyyMMdd')


                    $fechaactual = Get-Date -Format 'yyyyMMdd'

  

                    cd E:\Apps

                    attrib -h +s /d *.*

                    foreach ($name in $contenidoArchivo) {
       
                        robocopy "E:\Apps\$name\" "E:\backups\$name\" /XD 'adjuntos-correos' /s /z /maxage:$fechaanterior /minage:$fechaactual

                        robocopy "C:\FirmaDigitalFE\" "E:\backups\FirmaDigitalFE\" /s /z /maxage:$fechaanterior /minage:$fechaactual
    
                    }

                    #danny esta es la nueva linea hay que quemar la ruta del 7zip 

                    & "C:\Program Files\7-Zip\7z.exe" a -tzip "E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip" "E:\backups" -mx=9


                    #Compress-Archive  -force -Path  "E:\backups" -DestinationPath "E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip"

                    Remove-Item -Recurse -Force "E:\backups"


                    # Enviar correo


                    $EmailDestinatario = "tics@yeminus.com"
                    $EmailEmisor = "instalacionesyeminus@gmail.com"
                    $Asunto = "!IMPORTANTE BACKUPS APP SRV-$env:COMPUTERNAME!"
                    $CuerpoEnHTML = "Cordial saludo, Se hace backup del servidor <b>$env:COMPUTERNAME Recuerda que el archivo se almaceno en el FTP la ruta es ftp://files.yeminus.com/BackupEmpresas/BackupsAPP/ informacion guardada del dia $fechaanterior al $fechaactual . las empresas que estan en este servidor:</b><i>$contenidoArchivo<i/>"
                    $SMTPServidor = "smtp.gmail.com"
                    $CodificacionCaracteres = [System.Text.Encoding]::UTF8

                    try {
                        $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
                        $SMTPMensaje.IsBodyHtml = $true
                        $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
                        $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
                        $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
                        $SMTPCliente.EnableSsl = $true
                        $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "mfjsthdtvacefkft");
                        $SMTPCliente.Send($SMTPMensaje)
 
                    }  


                    catch {
                        Write-Error -Message "Error al enviar correo electrónico"
                    }


                    & "C:\Program Files (x86)\WinSCP\WinSCP.com" /command "open ftp://empresabkup:empresabkup1*@files.yeminus.com" "put E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip /BackupEmpresas/BackupsAPP/" "exit"


                    attrib +h +s /d *.*


            
                
                } while ($tiempo -lt 2)

            }

        }

        #7. BlockIP
        if ($dato -eq "7") {
          
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

        #8. ChangePassAll_Users
        if ($dato -eq "8") {


            $pass = Read-Host "Ingresa la clave para poder continuar"


            if ($pass -eq "insta2025*") {
                    
                Write-Host "Cambiar la contraseña de todos los usuarios de remoto" -ForegroundColor Yellow

                sleep -Seconds 3
            
                do {
                
                    function Generate-RandomString {
                        param (
                            [int]$length = 12
                        )
    
                        $chars = "QWERTYUIOPLKJHGFDASAZXCVBNMabcdefghjklmnbvcxz!#$%&'()*+,-./:;<=>?@[\]^_`{|}~123456789"
    
                        $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    
                        return $randomString
                    }
                    # Usuarios RDP 
                    $usernames = @(   
                        # Usuarios RDP 
                        @{ Name = "epineda"; ZipPassword = "Pepito" }                      # Inge
                        @{ Name = "administrator"; ZipPassword = "+-NewPw2024*#" }         # Danny Infraestructura
                        @{ Name = "instalacion"; ZipPassword = "Ocsxxi%123%" }             # Diego Infraestructura
                        @{ Name = "instalacion2"; ZipPassword = "Colombia2021**##" }       # Esteban Infraestructura
                        @{ Name = "soporte-01"; ZipPassword = "Yeminus" }                  # Jarvy   Subgerente      
                        @{ Name = "soporte-02"; ZipPassword = "15963Sopo#" }               # Harold  Director Mesa
                        @{ Name = "soporte-03"; ZipPassword = "Lc1088022547" }             # Laura mesa
                        @{ Name = "soporte-04"; ZipPassword = "Bardack085" }               # Jhon G mesa
                        @{ Name = "soporte-05"; ZipPassword = "saar98." }                  # Stiven mesa
                        @{ Name = "soporte-06"; ZipPassword = "Alana0803*" }               # Angelica mesa
                        @{ Name = "soporte-07"; ZipPassword = "Sopyem10*" }                 # Julian mesa
                        @{ Name = "consultor-01"; ZipPassword = "Valen9306." }             # Valentina mesa
                        @{ Name = "consultor-02"; ZipPassword = "Jp1088353472#" }          # Juli implentacion
                        @{ Name = "consultor-03"; ZipPassword = 'Con-Of$gem' }             # Olguita implentacion
                        @{ Name = "consultor-04"; ZipPassword = "S3bas#" }                 # Sebastian implentacion
                        @{ Name = "consultor-05"; ZipPassword = "123456Dt$" }              # Daniel taborda implentacion
                        @{ Name = "consultor-06"; ZipPassword = "lbeltran22" }             # luz stella implentacion
                        @{ Name = "consultor-07"; ZipPassword = "De1349*" }                # Diego implentacion
                        @{ Name = "consultor-08"; ZipPassword = "Dc1117486486#" }          # Diana implentacion
                    )
                    mkdir E:\Apps\geminus\datos 2>$null

                    $folderPath = "E:\Apps\geminus\"

                    if (-not (Test-Path -Path $folderPath)) {
                        New-Item -Path $folderPath -ItemType Directory
                    }

                    foreach ($user in $usernames) {
                        $username = $user.Name
                        $zipPassword = $user.ZipPassword

    
                        $length = 30
    
                        $randomString = Generate-RandomString -length $length
    
                        $userFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.txt"
    
                        Set-Content -Path $userFilePath -Value "por favor no compartir acceso, el reporte se envia cada 30 dias $username $randomString"
    
                        $password = ConvertTo-SecureString -AsPlainText -Force -String $randomString
    
                        Set-LocalUser -Name $username -Password $password
                        Write-Host "Cambio de clave al usuario $username"
    
                        $zipFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.zip"

                        Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$zipFilePath`"", "`"$userFilePath`"", "-p$zipPassword" -NoNewWindow -Wait
   
                        Remove-Item -Path "$folderPath\datos\*.txt" -Force
        
                    }

                    $routefile = "E:\Apps\geminus\datos"
                    $routezip = "E:\Apps\geminus\datos\datos.zip"

                    Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$routezip`"", "`"$routefile`"" -NoNewWindow -Wait 


                    $EmailEmisor = "noresponder@yeminus.com"
                    $Asunto = "Reporte de Actividad - SRV-" + $env:COMPUTERNAME
                    $CuerpoEnHTML = "<p>Cordial saludo Compañeros, Comparto el reporte</p>"

                    $SMTPServidor = "mail.yeminus.com"
                    $CodificacionCaracteres = [System.Text.Encoding]::UTF8


                    $ArchivoAdjunto = "$routezip"


                    $CCO = "instalaciones@yeminus.com" , "instalaciones2@yeminus.com", "epineda@yeminus.com", "subgerente@yeminus.com", "directorsoporte@yeminus.com", "yeminusinstalaciones@gmail.com", "coorinstalaciones.yeminus@gmail.com,aarias@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,vquintero@yeminus.com,scuervo@yeminus.com,jpineda@yeminus.com,oflorez@yeminus.com,dtaborda@yeminus.com,jrodriguez@yeminus.com,despinal@yeminus.com"
                    #$CCO = "instalaciones@yeminus.com" #pruebas

                    try {
    
                        $SMTPMensaje = New-Object System.Net.Mail.MailMessage
                        $SMTPMensaje.From = $EmailEmisor
                        $SMTPMensaje.Subject = $Asunto
                        $SMTPMensaje.Body = $CuerpoEnHTML
                        $SMTPMensaje.IsBodyHtml = $true
                        $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
                        $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
    
    
                        $Adjunto = New-Object System.Net.Mail.Attachment($ArchivoAdjunto)
                        $SMTPMensaje.Attachments.Add($Adjunto)
    
    
                        foreach ($cco in $CCO) {
                            $SMTPMensaje.Bcc.Add($cco)
                        }
        
    
                        $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
                        $SMTPCliente.EnableSsl = $true
                        $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "12345Aa$@/*")
        
    
                        $SMTPCliente.Send($SMTPMensaje)
                        Write-Output "Correo electrónico enviado correctamente."
        
    
                        $Adjunto.Dispose()
                    }
                    catch {
                        Write-Error -Message "Error al enviar correo electrónico: $_"
                    }
            
            
                    Remove-Item -Path "$folderPath\datos\*.*" -Force


                } while ($tiempo -lt 2)

            }

        }

        #9. pshellChange
        if ($dato -eq "9") {
            
            $pass = Read-Host "Por favor digita la clave de ingreso" 

            if ($pass -eq "insta2025*") {
                
                Write-Host "Cambiar la clave de un solo usuario" -ForegroundColor Yellow

                sleep -Seconds 3 
                
                $user = Read-Host "Indica cual es el usuario"
    
                $Password = Read-Host -AsSecureString
                $UserAccount = Get-LocalUser -Name "$user" 
                $UserAccount | Set-LocalUser -Password $Password
            }

        }
    }  

    # 10. Download Version
    if ($dato -eq "10") {

        
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
                    
     
} while ($intento -lt 3)
     
     
Write-Host "Saliendo..."
sleep -Seconds 2



