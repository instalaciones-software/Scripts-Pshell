
function Generate-RandomString {
    param (
        [int]$length = 12
    )
    
    $chars = "QWERTYUIOPLKJHGFDASAZXCVBNMabcdefghjklmnbvcxz!#$%&'()*+,-./:;<=>?@[\]^_`{|}~123456789"
    
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    
    return $randomString

}

$user = Read-Host "Cual es el nombre de usuario"


$params = @{
    Name        = $user
    Password    = $randomString
    FullName    = 'Usuario $user'
    Description = '$user'
}
New-LocalUser @params