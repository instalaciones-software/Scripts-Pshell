﻿function Generate-RandomString {
    param (
        [int]$length = 12
    )
    
    $chars = "QWERTYUIOPLKJHGFDASAZXCVBNMabcdefghjklmnbvcxz!#$%&'()*+,-./:;<=>?@[\]^_`{|}~123456789"
    
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    
    return $randomString
}
                                                                    # Usuarios RDP 
$usernames = @(                                                     
    @{ Name = "epineda"; ZipPassword = "ChangePassZip" }            # Inge gerente
    @{ Name = "administrator"; ZipPassword = "ChangePassZip" }      # Danny Instalacion
    @{ Name = "instalacion"; ZipPassword = "ChangePassZip" }        # Diego Instalacion
    @{ Name = "instalacion2"; ZipPassword = "ChangePassZip" }       # Esteban Instalacion
    @{ Name = "soporte-01"; ZipPassword = "ChangePassZip" }         # Jarvy Subgerente
    @{ Name = "soporte-02"; ZipPassword = "ChangePassZip" }         # Harold Mesa de ayuda
    @{ Name = "soporte-03"; ZipPassword = "ChangePassZip" }         # Laura Mesa de ayuda
    @{ Name = "soporte-04"; ZipPassword = "ChangePassZip" }         # Jhon G Mesa de ayuda
    @{ Name = "soporte-05"; ZipPassword = "ChangePassZip" }         # Stiven Mesa de ayuda
    @{ Name = "soporte-06"; ZipPassword = "ChangePassZip" }         # Angelica Mesa de ayuda
    @{ Name = "soporte-07"; ZipPassword = "ChangePassZip"}          # Julian Mesa de ayuda
    @{ Name = "consultor-01"; ZipPassword = "ChangePassZip" }       # Valen Implementacion
    @{ Name = "consultor-02"; ZipPassword = "ChangePassZip" }       # Juli Implementacion
    @{ Name = "consultor-03"; ZipPassword = 'ChangePassZip' }       # Olguita Implementacion
    @{ Name = "consultor-04"; ZipPassword = "ChangePassZip" }       # Sebastian Implementacion
    @{ Name = "consultor-05"; ZipPassword = "ChangePassZip" }       # Duglas Implementacion
    @{ Name = "consultor-06"; ZipPassword = "ChangePassZip" }       # heidy Implementacion
    @{ Name = "consultor-07"; ZipPassword = "ChangePassZip" }       # Diego  Implementacion
    @{ Name = "consultor-08"; ZipPassword = "ChangePassZip" }       # Diana Implementacion
    )

mkdir E:\Apps\geminus\datos 2>$null

$folderPath = "E:\Apps\geminus\"

if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
}

foreach ($user in $usernames) {
    $username = $user.Name
    $zipPassword = $user.ZipPassword

    
    $length = 30
    
    $randomString = Generate-RandomString -length $length
    
    $userFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.txt"
    
    Set-Content -Path $userFilePath -Value "por favor no compartir acceso, el reporte se envia cada 30 dias $username $randomString"
    
    $password = ConvertTo-SecureString -AsPlainText -Force -String $randomString
    
    Set-LocalUser -Name $username -Password $password
    Write-Host "Cambio de clave al usuario $username"
    
    $zipFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.zip"

    Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$zipFilePath`"", "`"$userFilePath`"", "-p$zipPassword" -NoNewWindow -Wait
   
    Remove-Item -Path "$folderPath\datos\*.txt" -Force
        
}

$routefile = "E:\Apps\geminus\datos"
$routezip = "E:\Apps\geminus\datos\datos.zip"

Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$routezip`"", "`"$routefile`"" -NoNewWindow -Wait 


$EmailEmisor = "noresponder@yeminus.com"
$Asunto = "Reporte de Actividad - SRV-" + $env:COMPUTERNAME
$CuerpoEnHTML = "<p>Cordial saludo Compañeros, Comparto el reporte</p>"

$SMTPServidor = "mail.yeminus.com"
$CodificacionCaracteres = [System.Text.Encoding]::UTF8


$ArchivoAdjunto = "$routezip"


$CCO = "instalaciones@yeminus.com" ,"instalaciones2@yeminus.com","epineda@yeminus.com","subgerente@yeminus.com","directorsoporte@yeminus.com","yeminusinstalaciones@gmail.com","coorinstalaciones.yeminus@gmail.com,aarias@yeminus.com,soporte2@yeminus.com,soporte1@yeminus.com,soporte3@yeminus.com,soporte10@yeminus.com,vquintero@yeminus.com,scuervo@yeminus.com,jpineda@yeminus.com,oflorez@yeminus.com,dmarin@yeminus.com,jrodriguez@yeminus.com,despinal@yeminus.com"
#$CCO = "instalaciones@yeminus.com" #pruebas

try {
    
    $SMTPMensaje = New-Object System.Net.Mail.MailMessage
    $SMTPMensaje.From = $EmailEmisor
    $SMTPMensaje.Subject = $Asunto
    $SMTPMensaje.Body = $CuerpoEnHTML
    $SMTPMensaje.IsBodyHtml = $true
    $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
    $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
    
    
    $Adjunto = New-Object System.Net.Mail.Attachment($ArchivoAdjunto)
    $SMTPMensaje.Attachments.Add($Adjunto)
    
    
    foreach ($cco in $CCO) {
        $SMTPMensaje.Bcc.Add($cco)
    }
        
    
    $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
    $SMTPCliente.EnableSsl = $true
    $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "12345Aa$@/*")
        
    
    $SMTPCliente.Send($SMTPMensaje)
    Write-Output "Correo electrónico enviado correctamente."
        
    
    $Adjunto.Dispose()
}
catch {
    Write-Error -Message "Error al enviar correo electrónico: $_"
}
            
            
Remove-Item -Path "$folderPath\datos\*.*" -Force

            

