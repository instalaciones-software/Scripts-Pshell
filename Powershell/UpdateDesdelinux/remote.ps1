$appcmdPath = "$env:SystemRoot\system32\inetsrv\appcmd.exe"
$appcmdPath2 = C:\Windows\System32\inetsrv\appcmd.exe list site /text:name | Sort-Object

  
    
Write-Host `
    "
    Conexion Establecida
    
    Version Script 2.0.0.1" -ForegroundColor green
    


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



# Crea archivo para el descargue de las versiones
$addfile = mkdir "C:\inetpub\versiones\" 2>$null


#contador inicial para ejecutar
$intento = 0

do {


    $dato = Read-Host " 
            Escoje la opcion.. (1 a 4)
        
            1. Actualizar version completa (ENTER)
            2. Actualizar parche 
            3. Desbloquear ip publica cliente
            4. Reiciar el api (BETA)
            Opcion"
            
        
    # Condicion Principal
    if ($dato -eq "1" -or $dato -eq "2" -or $dato -eq "3" -or $dato -eq "4" -or $dato -eq "") {
                
        if ($dato -eq "1" -or $dato -eq "") {
                    
              
                        
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
                        
                        
                    # add new components            
                    & "${comandoAppCmd}\appcmd" add app /site.name:$sitiosWeb /path:"/$listmodel" /physicalPath:"$program\$listmodel" /applicationPool:$sitiosWeb.$listmodel 1>$null
                        
                    # add directory virtual de los componentes
                    C:\Windows\system32\inetsrv\appcmd add vdir /app.name:$sitiosWeb/$listmodel /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
                        
                    # add pool app 
                    & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitiosWeb.$listmodel /processModel.identityType:"ApplicationPoolIdentity" 1>$null
                            
                }
                    
                # Define la ruta de las carpetas y el grupo
                $carpeta1 = "C:\inetpub\wwwroot\$sitiosWeb"
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

                Write-Host "$contenidoArchivo"
                

                     
                # envia correo si el sitio web se llama diferente a yeminus, yeminusweb
                if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminusweb" -and $sitiosWeb -ne "yeminus2") {
                                
                               
                    $EmailDestinatario = "instalaciones@yeminus.com"
                    $EmailEmisor = "noresponder@yeminus.com"
                    $Asunto = "📌Actualización Empresa $sitiosWeb Version $numversion"
                    $sitiosWeb = $sitiosWeb.ToLower()
                    $CuerpoEnHTML = "<p>Cordial saludo, Se realiza la actualizacion del yeminus web a la empresa <b>$sitiosWeb  con version $numversion este cliente tenia la version $contenidoArchivo </b> Por favor estar pendientes de este cliente por si requieren soporte sobre el producto web</p>
                    
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
        if ($dato -eq "2" ) {
                    
              
           
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


            # aqui empeieza a desplegar la version
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
     
            # eliminar archivos 

            if ($sitiosWeb -ne "yeminus" -and $sitiosWeb -ne "yeminus2" -and $sitiosWeb -ne "yeminusweb") {
                #revisar el lunes
                    
                Rename-Item -Path "C:\inetpub\wwwroot\$sitiosWeb\yeminus" -NewName "$sitiosWeb"
            }
            Remove-Item  -Force -Recurse "C:\inetpub\versiones\"  -Exclude *.zip 
            Remove-Item  -Force  -Recurse "C:\inetpub\wwwroot\$sitiosWeb\*.zip"  
                
     

            if ($sitiosWeb -ne "yeminus" -or $sitiosWeb -ne "yeminus2" -or $sitiosWeb -ne "yeminusweb") {
                #Enviar correo para confirmar actualizacion del yeminus web, envia cuando el sitio web no se llama yeminus es decir envia cuando se actualiza hosting..       
                if ($sitiosWeb -ne "yeminus" -or $sitiosWeb -ne "yeminus2" ) {
                    $EmailDestinatario = "instalaciones@yeminus.com" # Correos a enviar
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
        if ($dato -eq "3") {
           
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
                    
                    
            } while ($time -lt 2 )
        }
        else {
            $intento++
        }
        if ($dato -eq "4") {
            Write-Host "la opcion se encuentra en pruebas" -ForegroundColor Yellow
            sleep -Seconds 2
        }
    }  
    
    # preguntar si quiere ejecutar el script
    if ($dato -eq "1" -or $dato -eq "2" -or $dato -eq "3" -or $dato -eq "4" - $dato -eq "") {
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



