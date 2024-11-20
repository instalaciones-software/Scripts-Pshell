#!/bin/bash

# Install pre-requisite packages.

sudo apt-get install -y wget apt-transport-https software-properties-common


# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb


# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb


# Update the list of packages after we added packages.microsoft.com
sudo apt-get update


# Install PowerShell
sudo apt-get install -y powershell

#complemnetos powershell
sudo apt-get install -y powershell gss-ntlmssp

#Install PWSMan
pwsh -Command 'Install-Module -Name PSWSMan'

#Install Wsman
pwsh -Command 'Install-WSMan'

echo "Instalacion finalizada"

read