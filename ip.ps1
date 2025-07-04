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