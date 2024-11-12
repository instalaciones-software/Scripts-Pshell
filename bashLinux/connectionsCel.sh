#!/bin/bash

# Dowload shell ps1 for upgrade
wget -P /home/updateiis/script https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1

clear

echo "

                 *******************************************
                |    CONEXIONES A SERVIDORES HOSTING        | 
                 *******************************************
"

read -p "Ingresa el subdominio para conectarte al servidor:" server
echo

echo "Estableciendo conexion con el servidor $server.yeminus.com"

pwsh -Command "
\$cred = Import-Clixml -Path '/home/updateiis/script/xml.xml'
Invoke-Command -FilePath '/home/updateiis/script/remote.ps1' -ComputerName '$server.yeminus.com' -Credential \$cred
"

rm -r /home/updateiis/script/*.ps1