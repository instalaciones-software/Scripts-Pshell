
<# Reemplaza las siguientes palabras en el documento: "USERRDP", "PASSCOMPRESS" y "RUTA". En el campo "RUTA", especifica el directorio donde deseas que se guarde el archivo comprimido. Además, actualiza las variables $EmailEmisor y $CCO modificando las direcciones de correo electrónico de manera masiva, sustituyendo "yeminus.com" por el dominio que utilizas. Finalmente, en la línea 100, cambia la clave del correo electrónico del remitente. #>

function Generate-RandomString {
    param (
        [int]$length = 12
    )
    
    $chars = "QWERTYUIOPLKJHGFDASAZXCVBNMabcdefghjklmnbvcxz!#$%&'()*+,-./:;<=>?@[\]^_`{|}~123456789"
    
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    
    return $randomString
}

$usernames = @(
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS"}
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
    @{ Name = "USERRDP"; ZipPassword = "PASSWORDCOMPRESS" }
)

mkdir RUTA\datos 2>$null

$folderPath = "RUTA\"

if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
}

foreach ($user in $usernames) {
    $username = $user.Name
    $zipPassword = $user.ZipPassword

    
    $length = 30
    
    $randomString = Generate-RandomString -length $length
    
    $userFilePath = "$folderPath\datos\$username.txt"
    
    Set-Content -Path $userFilePath -Value "por favor no compartir acceso, el reporte se envia cada 60 dias $username $randomString"
    
    $password = ConvertTo-SecureString -AsPlainText -Force -String $randomString
    
    Set-LocalUser -Name $username -Password $password
    
    $zipFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.zip"

    Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$zipFilePath`"", "`"$userFilePath`"", "-p$zipPassword" -NoNewWindow -Wait
   
    Remove-Item -Path "$folderPath\datos\*.txt" -Force
        
}

$routefile = "RUTA\datos"
$routezip = "RUTA\datos\datos.zip"

Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$routezip`"", "`"$routefile`"" -NoNewWindow -Wait 


$EmailEmisor = "noresponder@yeminus.com"
$Asunto = "Reporte de Actividad - SRV-" + $env:COMPUTERNAME.Substring($env:COMPUTERNAME.Length - 2)
$CuerpoEnHTML = "<p>Cordial saludo Compañeros, Comparto el reporte</p>"

$SMTPServidor = "mail.yeminus.com"
$CodificacionCaracteres = [System.Text.Encoding]::UTF8


$ArchivoAdjunto = "$routezip"


$CCO = "instalaciones@yeminus.com" ,"instalaciones2@yeminus.com","tics@yeminus.com","epineda@yeminus.com","instalaciones3@yeminus.com","subgerente@yeminus.com","directorsoporte@yeminus.com","correoinstalaciones@yeminus.com","coorinstalaciones.correo@yeminus.com"

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
    $SMTPCliente.Credentials = New-Object System.Net.NetworkCredential($EmailEmisor, "PASSCORREO")
        
    
    $SMTPCliente.Send($SMTPMensaje)
    Write-Output "Correo electrónico enviado correctamente."
        
    
    $Adjunto.Dispose()
}
catch {
    Write-Error -Message "Error al enviar correo electrónico: $_"
}
            
            
Remove-Item -Path "$folderPath\datos\*.*" -Force

            