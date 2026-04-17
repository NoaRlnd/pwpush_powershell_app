$currentPath = $PSScriptRoot
$basePath = Split-Path -Path $PSScriptRoot
$dataJSONpath = Join-Path $basePath "\backup\backupdata.json"

$txtTest = "pet"

if ($txtTest -ne "") {
    write-host "la condition se fait"
}
else {
    Write-Host "la condi fait pas"
}