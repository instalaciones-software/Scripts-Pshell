#!/bin/bash

# Dowload shell ps1 for upgrade
wget -p /home/$USER/Documentos/script/ https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1


read -p "Ingresa el subdominio para conectarte al servidor:" server


echo "Estableciendo conexion con el servidor $server.yeminus.com"

sleep 2s



#Start PowerShell
pwsh -Command Invoke-Command -FilePath /home/$USER/Documentos/script/remote.ps1 -ComputerName $server.yeminus.com -Authentication Negotiate -Credential pshell


rm -r /home/$USER/Documentos/script/