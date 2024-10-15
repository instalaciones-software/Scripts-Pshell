#!/bin/bash

echo "Version 1.0.0.0"

#create file for download packages
mkdir /home/$USER/Documentos/script/

# Download the Microsoft repository GPG keys
wget -P /home/$USER/Documentos/script/ https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb


#Download shell The Github Yeminus
wget -p /home/$USER/Documentos/script/ https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/bash.sh



echo "

********************************************************************************************************************|
  ATENCION ESTE ARCHIVO ES INSTALADOR DE LOS PAQUETES DE POWERSHELL EN LA DISTRIBUCION CON LINUX                    | 
                                                                                                                    |
                                                                                                                    |
  EL ARCHIVO PARA HACER LA CONEXION CON LOS SERVIDORES SE ENCUENTRA EN /home/$USER/Documentos/script/connections.   |sh                                                                                                                |
*********************************************************************************************************************
"

echo ""

sleep 5

# Update the list of products
sudo apt-get update -y


# Install PowerShell
sudo apt-get install -y powershell gss-ntlmssp

#install pwsh
sudo snap install powershell --classic


pwsh -Command 'Install-Module -Name PSWSMan'


pwsh -Command 'Install-WSMan'


# Register the Microsoft repository GPG keys
sudo dpkg -i /home/$USER/Documentos/script/packages-microsoft-prod.deb


