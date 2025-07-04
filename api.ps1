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