cls


$appcmdPath = "$env:SystemRoot\system32\inetsrv\appcmd.exe"
$appcmdPath2 = C:\Windows\System32\inetsrv\appcmd.exe list site /text:name | Sort-Object

  


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
                    }

                    # stop

                    foreach ($model in $listmodel) {

                       & $comandoAppCmd\appcmd stop apppool "$sitiosWeb.$model"
                    }



                    # remove files the app
                            
                    Remove-Item -Recurse -Force "$program\*" -Exclude oldversion.txt    
                    
                    foreach ($pool in $listApis) {
                        # startup the site web
                        & $comandoAppCmd\appcmd start apppool $sitiosWeb 1>$null
                        & $comandoAppCmd\appcmd start apppool "$sitiosWeb.$pool" 1>$null                        
                    }
                    


                        foreach ($model in $listmodel) {

                       & $comandoAppCmd\appcmd start apppool "$sitiosWeb.$model " 1>$null
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
                    
                    
                    foreach ($modul in $listmodel) {
                        
                        # add new components            
                        & "${comandoAppCmd}\appcmd" add app /site.name:$sitiosWeb /path:"/$modul" /physicalPath:"$program\$modul" /applicationPool:$sitiosWeb.$modul 1>$null
                        
                        # add directory virtual de los componentes
                        C:\Windows\system32\inetsrv\appcmd add vdir /app.name:$sitiosWeb/$modul /path:/recursos /physicalPath:$rutarecursos /username:$nombreUsuario /password:$contrasenaTextoPlano 1>$null
                        
                        # add pool app 
                        & "${comandoAppCmd}\appcmd" add apppool /apppool.name:$sitiosWeb.$modul /processModel.identityType:"ApplicationPoolIdentity" 1>$null

                        Add-LocalGroupMember -Group "IIS_IUSRS" -Member "IIS APPPOOL\$sitiosWeb.$modul" 2>$null
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