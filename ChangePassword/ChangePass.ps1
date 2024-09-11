
function Generate-RandomString {
    param (
        [int]$length = 12
    )
    
    $chars = "QWERTYUIOPLKJHGFDASAZXCVBNMabcdefghjklmnbvcxz!#$%&'()*+,-./:;<=>?@[\]^_`{|}~123456789"
    
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    
    return $randomString
}

$usernames = @(
    @{ Name = "epineda"; ZipPassword = "Pepito" }
    @{ Name = "administrator"; ZipPassword = "+-NewPw2024*#" }
    @{ Name = "instalacion"; ZipPassword = "Y3minus*" }
    @{ Name = "instalacion2"; ZipPassword = "Colombia2021**##" }
    @{ Name = "soporte-01"; ZipPassword = "Yeminus" }
    @{ Name = "soporte-02"; ZipPassword = "15963Sopo#" }
    @{ Name = "soporte-03"; ZipPassword = "Lc1088022547" }
    @{ Name = "soporte-04"; ZipPassword = "Bardack085" }
    @{ Name = "soporte-05"; ZipPassword = "saar98." }
    @{ Name = "soporte-06"; ZipPassword = "Alana0803*" }
    @{ Name = "soporte-07"; ZipPassword = "Sopyem10*" }
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
    
    $userFilePath = "$folderPath\datos\$username.txt"
    
    Set-Content -Path $userFilePath -Value "por favor no compartir acceso, el reporte se envia cada 30 dias $username $randomString"
    
    $password = ConvertTo-SecureString -AsPlainText -Force -String $randomString
    
    Set-LocalUser -Name $username -Password $password
    
    $zipFilePath = "$folderPath\datos\$env:COMPUTERNAME-$username.zip"

    Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$zipFilePath`"", "`"$userFilePath`"", "-p$zipPassword" -NoNewWindow -Wait
   
    Remove-Item -Path "$folderPath\datos\*.txt" -Force
        
}

$routefile = "E:\Apps\geminus\datos"
$routezip = "E:\Apps\geminus\datos\datos.zip"

Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-tzip", "`"$routezip`"", "`"$routefile`"" -NoNewWindow -Wait 


$EmailEmisor = "noresponder@yeminus.com"
$Asunto = "Reporte de Actividad - SRV-" + $env:COMPUTERNAME.Substring($env:COMPUTERNAME.Length - 2)
$CuerpoEnHTML = "<p>Cordial saludo Compañeros, Comparto el reporte</p>"

$SMTPServidor = "mail.yeminus.com"
$CodificacionCaracteres = [System.Text.Encoding]::UTF8


$ArchivoAdjunto = "$routezip"


$CCO = "instalaciones@yeminus.com" ,"instalaciones2@yeminus.com","tics@yeminus.com","epineda@yeminus.com","subgerente@yeminus.com","directorsoporte@yeminus.com","yeminusinstalaciones@gmail.com","coorinstalaciones.yeminus@gmail.com"

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

            

