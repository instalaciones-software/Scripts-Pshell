

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