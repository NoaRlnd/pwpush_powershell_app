$currentPath = $PSScriptRoot
$basePath = Split-Path -Path $PSScriptRoot
$credentielJSONpath = Join-Path $basePath "\credentiel.json"
$secretJSONpath = Join-Path $basePath "\data\secret.json"
$dataJSONpath = Join-Path $basePath "\data\data.json"


$payload = Get-Content -Raw -Path $secretJSONpath | ConvertFrom-Json

$contentJSONdata = Get-Content -Raw -Path $dataJSONpath | ConvertFrom-Json
$vuesMax = $contentJSONdata.expire_after_views
if ($contentJSONdata.passphrase -eq "") {$passphrase = $null} else {$passphrase = $contentJSONdata.passphrase}
$duree = $contentJSONdata.expire_after_duration
$note = $contentJSONdata.note

$contentCredJSON = Get-Content -Raw -Path $credentielJSONpath | ConvertFrom-Json
$token = $contentCredJSON.APItoken


$headers = @{
    'Authorization' = "Bearer $token"
    'Content-Type' = "application/json"
}

$body = @{
    push = @{
        payload = $payload
        expire_after_duration = $duree
        expire_after_views = $vuesMax
        passphrase = $passphrase
        note = $note
    }
} | ConvertTo-Json -Depth 10

Set-Content -Encoding utf8 -Path $secretJSONpath -Value ""
$response = Invoke-RestMethod -Uri 'https://eu.pwpush.com/api/v2/pushes' -Method Post -Headers $headers -Body $body
$response | ConvertTo-Json | Set-Content -Encoding utf8 -Path $dataJSONpath