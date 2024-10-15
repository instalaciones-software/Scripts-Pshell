#!/bin/bash

read -p "Ingresa el subdominio para conectarte al servidor:" server


echo "Estableciendo conexion con el servidor $server.yeminus.com"

sleep 2s



#Start PowerShell
pwsh -Command Invoke-Command -FilePath /home/$USER/Documentos/script/remote.ps1 -ComputerName $server.yeminus.com -Authentication Negotiate -Credential pshell
