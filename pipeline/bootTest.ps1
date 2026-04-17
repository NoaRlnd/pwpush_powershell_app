Add-Type -AssemblyName System.Windows.Forms

$basePath = Split-Path -Path $PSScriptRoot
$credentielJSONpath = Join-Path $basePath "\credentiel.json"
$canWorkJSONpath = Join-Path $basePath "\ready.json"
$mainScriptPath = Join-Path $currentPath "\main.ps1"

$credExist = Test-Path -Path $credentielJSONpath


    $popUp = [Microsoft.VisualBasic.Interaction]::InputBox("entrez votre token API", "Pop-up", "")
    if ($popUp.length -lt 15 -or $popUp -match "\s") {
        [System.Windows.Forms.MessageBox]::Show("veuillez remplir avec une vraie clé API, ou correctement")
        & $mainScriptPath
    }
    else {
        $canWork = Get-Content -Raw -Path $canWorkJSONpath | ConvertFrom-Json
        $canWork.boot = $true
        $canWork.steps ++
        if ($credExist -eq $false) {
            New-Item -Path $credentielJSONpath -ItemType "File"
            $canWork.steps ++
        }
        else {
            $canWork.steps ++
        }
        $canWork | ConvertTo-Json | Set-Content -Encoding utf8 -Path $canWorkJSONpath
        $popUp = @{
            "APItoken" = $popUp
        }
        $popUp | ConvertTo-Json | Set-Content -Encoding utf8 -Path $credentielJSONpath
    }


if ($canWork.steps -ge 2) {
    $secretClear = ""
    $dataClear = @{
        "expire_after_duration" = 0
        "expire_after_views" = 1
        "passphrase" = ""
        "note" = "envoi depuis application PWPusherGUI"
    }
    $secretClear | ConvertTo-Json | Set-Content -Encoding utf8 -Path $secretJSONpath
    $dataClear | ConvertTo-Json | Set-Content -Encoding utf8 -Path $dataJSONpath
    & $mainScriptPath
}