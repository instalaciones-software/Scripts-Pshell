#!/bin/bash

# Dowload shell ps1 for upgrade
wget -P /home/updateiis/script https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1

clear

echo "

********************************************************************************************************************|
                                                                                                                    |
                                        CONEXIONES A SERVIDORES HOSTING                                             | 
                                                                                                                    |
*********************************************************************************************************************
"


read -p "Ingresa el subdominio para conectarte al servidor:" server


echo "Estableciendo conexion con el servidor $server.yeminus.com"


#Start PowerShell
pwsh -Command Invoke-Command -FilePath /home/updateiis/script/remote.ps1 -ComputerName $server.yeminus.com -Authentication Negotiate -Credential pshell


rm -r /home/updateiis/script/*.ps1