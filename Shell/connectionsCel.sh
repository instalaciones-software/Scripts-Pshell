#!/bin/bash

#rm -r /home/updateiis/script/*.ps1
rm -r /home/updateiis/script/*.ps1.1

# Dowload shell ps1 for upgrade
#wget -P /home/updateiis/script https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1

clear


read -p "Ingresa el subdominio:" server
echo

echo "Estableciendo conexion con el servidor $server.yeminus.com"

pwsh -Command "
\$cred = Import-Clixml -Path '/home/updateiis/script/xml.xml'
Invoke-Command -FilePath '/home/updateiis/script/4.0.ps1' -ComputerName '$server.yeminus.com' -Credential \$cred
"

exit