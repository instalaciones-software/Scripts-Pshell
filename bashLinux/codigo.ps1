# Configuraciones de correo
$smtpServer = "smtp.gmail.com"      # Servidor SMTP (puede cambiar dependiendo del proveedor)
$smtpPort = 587                     # Puerto para TLS
$smtpUser = "yeminusinstalaciones@gmail.com"    # Tu correo de Gmail
$smtpPassword = "qpdx eyum xeci ggci"      # Tu contraseña o aplicación específica de Google
$toEmail = "instalaciones@yeminus.com,diego251644@gmail.com"  # Correo al cual enviar el código (puede ser tu propio correo)
$fromEmail = "instalaciones@yeminus.com"


# Generar un código aleatorio de 6 dígitos
$codigo = Get-Random -Minimum 100000 -Maximum 999999

# Cuerpo del correo con el código de verificación
$body = "Tu código de verificación es: $codigo"

Write-Host "$body"

# Configurar el cliente SMTP
$smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)

# Enviar el correo
$mailmessage = New-Object System.Net.Mail.MailMessage($fromEmail, $toEmail, "Código de Verificación IIS", $body)

# Intentar enviar el correo
try {
    $smtp.Send($mailmessage)
    Write-Host "El código de verificación ha sido enviado a tu correo."
} catch {
    Write-Host "Hubo un error al enviar el correo: $_"
    exit
}

# Pedir al usuario que ingrese el código recibido por correo
$codigoIngresado = Read-Host "Ingresa el código de verificación que recibiste en tu correo"

# Validar el código
if ($codigoIngresado -eq $codigo) {
    Write-Host "¡Hola Mundo!"
} else {
    Write-Host "Código incorrecto. Intenta nuevamente."
}
