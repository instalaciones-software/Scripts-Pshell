#!/bin/bash

echo "Bash version 1.0.2.0"

mkdir /home/$USER/Documentos/script/

# Download the Microsoft repository GPG keys
wget -P /home/$USER/Documentos/script/ https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb

wget -P /home/$USER/Documentos/script/ https://github.com/instalaciones-software/Scripts-Pshell/releases/download/1.0.0/remote.ps1

# Register the Microsoft repository GPG keys
sudo dpkg -i /home/$USER/Documentos/script/packages-microsoft-prod.deb

# Update the list of products
sudo apt-get update

# Install PowerShell
sudo apt-get install -y powershell gss-ntlmssp

read -p "Ingresa el subdominio para conectarte al servidor y añade varios separados por comas:" server

echo "Estableciendo conexion con el servidor $server.yeminus.com"

sleep 2s

#Start PowerShell
pwsh -Command Invoke-Command -FilePath /home/$USER/Documentos/script/remote.ps1 -ComputerName $server.yeminus.com -Authentication Negotiate -Credential pshell
