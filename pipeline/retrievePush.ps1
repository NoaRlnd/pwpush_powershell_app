$pushId = "hmmmejwp9vcm2epk6g8"
$contentPassphrase = ""
if ($contentPassphrase -ne "") {$passphrase = "?passphrase=" + $contentPassphrase } else {$passphrase = "" }

$response = Invoke-RestMethod -Uri "https://pwpush.com/p/$pushId.json$passphrase" -Method Get
$response | ConvertTo-Json | Set-Content -Encoding utf8 -Path $dataJSONpath