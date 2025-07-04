del "C:\Users\pshell\Scripts\*.ps1" 


$intento = 0
$maxIntentos = 2
$opcionValida = $false

do {
    $question = Read-Host "`n¿Quiere ejecutar el script a un solo servidor o a todos?`n`nOpciones:`n1. Un solo servidor (Enter)`n2. Todos los servidores `n Opcion"
    
    if ($question -eq "" -or $question -eq "1") {

        Write-Host "Opción 1 seleccionada: Ejecutar en un solo servidor." -ForegroundColor Yellow
        $opcionValida = $true

        $input = Read-Host "¿A qué servidores deseas conectarte? (separa por coma: subdominio)" 
        $servers = $input -split "," | ForEach-Object { $_.Trim() }

        $file = Read-Host "¿Que archivo .ps1 Desea Descargar
                        
                        1. Web - (Actualizar Yemninus Web a partir 4.0)
                        2. ChangePass - (Cambiar clave a todos lo usuarios soporte y consultor)
                        3. version - (Descargar ultima version del Yeminus Web)
                        4. Firma - (Hacer Backup firmas Digitales)
                        5. parche - (Actualizar Version parche)
                        6. api - (Reiniciar Api)
                        7. Ip - (Desbloquear ip publica)
                        
                        NOTA: Escribir el nombre de las opciones
                        
                        ?"

        if ($file -eq "pshellChange" -or $file -eq "ChangePass" -or $file -eq "Web" -or $file -eq "version"  -or $file -eq "Firma"  -or $file -eq "parche"  -or $file -eq "api" -or $file -eq "Ip") {

            Write-Host "Descargando...." -ForegroundColor Cyan
                            
            sleep -Seconds 2 

            Invoke-WebRequest -Uri "https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/$file.ps1" -OutFile "C:\Users\pshell\Scripts\$file.ps1"
                            
                                    
            $trustedHosts = "$servers.yeminus.com" -join ","
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force
                            
            foreach ($server in $servers) {
                try {
                    $cred = Import-Clixml -Path "C:\Users\pshell\xml.xml"
                    Write-Host " Ejecutando en $server.yeminus.com" -ForegroundColor Green #para agregar ips, remueva .yeminus.com
                    Invoke-Command -ComputerName "$server.yeminus.com" -FilePath "C:\Users\pshell\Scripts\$file.ps1" -Credential $cred -Authentication Negotiate
                    


                }
                catch {
                    Write-Error "Error al ejecutar en $server"
                }
            }
                            
                                    
            $respuesta = Read-Host "`n¿Deseas conectarte a más servidores? (s/n)"
            if ($respuesta -ne "s") {
                $continuar = $false
            }
        }
                            
                                
        Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
        Write-Host "`n Todos los procesos finalizados. TrustedHosts limpiado." -ForegroundColor Yellow

    }


    elseif ($question -eq "2") {
        Write-Host "Opción 2 seleccionada: Ejecutar en todos los servidores."
        $opcionValida = $true
    }
    else {
        Write-Host "La opción no está disponible. Intente nuevamente.`n"
        $intento++
    }

} until ($opcionValida -or $intento -ge $maxIntentos)

if (-not $opcionValida) {
    Write-Host "`nSe han excedido los intentos permitidos. Terminando el script." -ForegroundColor Red
    exit
}
