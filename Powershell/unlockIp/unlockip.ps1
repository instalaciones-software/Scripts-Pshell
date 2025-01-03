$ip = Read-Host "Por favor indique el numero de ip que desea desbloquear"

# Elimina la regla de firewall 
netsh advfirewall firewall delete rule name="Bloquear IP Maliciosa $ip"

$archivo = "C:\failed_logins_log.txt"

$patron = "IP $ip bloqueada por"

Select-String -Path $archivo -Pattern $patron
