
$rutaCarpeta = "E:\backups"

if (Test-Path $rutaCarpeta) {
  Write-Host "La carpeta ya existe en $rutaCarpeta"
}
else {
  New-Item -ItemType Directory -Path $rutaCarpeta
  Write-Host "Se ha creado la carpeta en $rutaCarpeta"
}

$rutaArchivo = 'E:\Apps\list.txt'
$contenidoArchivo = Get-Content -Path $rutaArchivo

    
$fechaini = Get-Date -Format 'yyyyMMdd'
$currentDate = [datetime]::ParseExact($fechaini, 'yyyyMMdd', $null)


$previousDate = $currentDate.AddDays(-3698) # 8 dias atras 
$fechaanterior = $previousDate.ToString('yyyyMMdd')


$fechaactual = Get-Date -Format 'yyyyMMdd'

  

cd E:\Apps

attrib -h +s /d *.*

foreach ($name in $contenidoArchivo) {
       
  robocopy "E:\Apps\$name\" "E:\backups\$name\" /XD 'adjuntos-correos' /s /z /maxage:$fechaanterior /minage:$fechaactual

  robocopy "C:\FirmaDigitalFE\" "E:\backups\FirmaDigitalFE\" /s /z /maxage:$fechaanterior /minage:$fechaactual
    
}

#danny esta es la nueva linea hay que quemar la ruta del 7zip 

& "C:\Program Files\7-Zip\7z.exe" a -tzip "E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip" "E:\backups" -mx=9


#Compress-Archive  -force -Path  "E:\backups" -DestinationPath "E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip"

Remove-Item -Recurse -Force "E:\backups"


# Enviar correo


$EmailDestinatario = "tics@dominio.com"
$EmailEmisor = "instalacionesdominio@gmail.com"
$Asunto = "!IMPORTANTE BACKUPS APP SRV-$env:COMPUTERNAME!"
$CuerpoEnHTML = "Cordial saludo, Se hace backup del servidor <b>$env:COMPUTERNAME Recuerda que el archivo se almaceno en el FTP la ruta es ftp://files.dominio.com/BackupEmpresas/BackupsAPP/ informacion guardada del dia $fechaanterior al $fechaactual . las empresas que estan en este servidor:</b><i>$contenidoArchivo<i/>"
$SMTPServidor = "smtp.gmail.com"
$CodificacionCaracteres = [System.Text.Encoding]::UTF8

try {
  $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
  $SMTPMensaje.IsBodyHtml = $true
  $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
  $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
  $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
  $SMTPCliente.EnableSsl = $true
  $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "mfjsthdtvacefkft");
  $SMTPCliente.Send($SMTPMensaje)
 
}  


catch {
  Write-Error -Message "Error al enviar correo electrónico"
}


& "C:\Program Files (x86)\WinSCP\WinSCP.com" /command "open ftp://empresabkup:empresabkup1*@files.dominio.com" "put E:\Back-$env:COMPUTERNAME-$fechaanterior-Al-$fechaactual.zip /BackupEmpresas/BackupsAPP/" "exit"


attrib +h +s /d *.*

