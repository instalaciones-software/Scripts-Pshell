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






# $nombreSitioWeb = "yeminus"
# $urlYem = [System.Environment]::GetEnvironmentVariable("${nombreSitioWeb}BASEURLYEMINUS", "Machine")

# # Remover la parte "/apiyeminus" de la URL


# # Ahora la URL solo contendrá "http://localhost:8000"
# Invoke-WebRequest $urlYem
# Write-Host $urlYem
