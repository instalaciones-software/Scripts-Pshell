$urls = @("farmavet")

foreach ($url in $urls) {
    $url = "http://$url.yeminus.com/api$url/"

    Write-Host "ENVIANDO PETICION AL SITIO WEB $url" -BackgroundColor Red -ForegroundColor White -NoNewline    
    $response = Invoke-RestMethod -Uri $url -Method Get

    
}

$api = @("admin","security")

foreach ($apis in $api) {
    foreach ($apis in @("http://megacentro.yeminus.com/$apis.api/")) {

        Write-Host "RESPUESTA DEL API $apis" -BackgroundColor Red -ForegroundColor White -NoNewline    
        $response = Invoke-RestMethod -Uri $apis -Method Get

        
    }
}

