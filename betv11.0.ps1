$nombreSitioWeb = "yeminus" # remplazar
$urlYem = [System.Environment]::GetEnvironmentVariable("${nombreSitioWeb}BASEURLYEMINUS", "Machine") # remplazar



$urlYem = $urlYem.Replace("apiyeminus/", "")



$response = Invoke-WebRequest "$urlYem/admin.api/api/admin/empresas/getids" 
$content = $response.Content | ConvertFrom-Json

foreach ($item in $content) {
    foreach ($element in $item) {
        # CREATE TABLES 
      Invoke-WebRequest $urlYem/Admin.Api/api/configuracion/actualizacionbd/creartablas/$element/YEMINUS

       Write-Host "ACTUALIZANDO EL ID" $element

    }
}


$web = "yeminusweb"

if ($web -eq "yeminusweb" -or "yeminus" ) {

 $contrasena = Read-Host "¿Contraseña del usuario $env:USERNAME ?" -AsSecureString
$contrasenaTextoPlano = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($contrasena))

}else {
    $nombreUsuario = "small"
    $contrasena = "123456Aa"<# Action when all if and elseif conditions are false #>
}


Write-Host $contrasena

