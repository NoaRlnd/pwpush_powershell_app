#spaghetti code incoming, désolé :)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$currentPath = $PSScriptRoot
$basePath = Split-Path -Path $PSScriptRoot
$canWorkJSONpath = Join-Path $basePath "\ready.json"
$dataJSONpath = Join-Path $basePath "\data\data.json"
$testDataJSONpath = Join-Path $basePath "\data\testdata.json"
$secretJSONpath = Join-Path $basePath "\data\secret.json"
$visuelsBGpath = Join-Path $basePath "\visuels\arriere_plan_main.png"
$visuelsCHMKpath = Join-Path $basePath "\visuels\checkmark.png"
$visuelsSTTGSpath = Join-Path $basePath "\visuels\settings.png"
$pushPath = Join-Path $currentPath "\push.ps1"
$settingsPagePath = Join-Path $currentPath "\SettingsPage.ps1"
$bootTestPagePath = Join-Path $currentPath "\bootTest.ps1"

$canWork = Get-Content -Raw -Path $canWorkJSONpath | ConvertFrom-Json
$contentJSON = Get-Content -Raw -Path $dataJSONpath | ConvertFrom-Json
$contentJSON.passphrase = ""
$contentJSON | ConvertTo-Json | Set-Content -Encoding utf8 -Path $dataJSONpath

if ($canWork.boot -eq $false) {
    & $bootTestPagePath
}
if ($canWork.steps -lt 2) {
    exit 32
}

$credentielJSONpath = Join-Path $basePath "\credentiel.json"

$Form = New-Object System.Windows.Forms.Form
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.Text = "PWPush GUI"
$Form.Size = New-Object System.Drawing.Size(500, 460)
$Form.StartPosition = "CenterScreen"
$Form.BackgroundImage = [System.Drawing.Image]::FromFile($visuelsBGpath)

# truc de timer, absolument ignoble à comprendre, mais mieux que start-sleep pour pas bloquer l'UI
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 60000  # 60 secondes

# label Secret
$lblSecret = New-Object System.Windows.Forms.Label
$lblSecret.Text = "Secret à envoyer :"
$lblSecret.Location = New-Object System.Drawing.Point(10,20)
$lblSecret.Size = New-Object System.Drawing.Size(130,20)
$Form.Controls.Add($lblSecret)

# bouton paramètres
$btnSettings = New-Object System.Windows.Forms.Button
$btnSettings.Location = New-Object System.Drawing.Point(150,15)
$btnSettings.Size = New-Object System.Drawing.Size(30,30)
$btnSettings.Image = [System.Drawing.Image]::FromFile($visuelsSTTGSpath)
$Form.Controls.Add($btnSettings)

# textbox Secret
$txtSecret = New-Object System.Windows.Forms.TextBox
$txtSecret.Location = New-Object System.Drawing.Point(10,50)
$txtSecret.Size = New-Object System.Drawing.Size(450,20)
$Form.Controls.Add($txtSecret)

# bouton Générer
$btnGenerate = New-Object System.Windows.Forms.Button
$btnGenerate.Text = "Générer lien PWPush"
$btnGenerate.Location = New-Object System.Drawing.Point(10,300)
$btnGenerate.Size = New-Object System.Drawing.Size(200,30)
$Form.Controls.Add($btnGenerate)

# zone résultat
$txtResult = New-Object System.Windows.Forms.TextBox
$txtResult.Text = ""
$txtResult.PlaceholderText = "1 minute entre chaque demandes de liens, par pitié"
$txtResult.Location = New-Object System.Drawing.Point(10,350)
$txtResult.Size = New-Object System.Drawing.Size(450,20)
$txtResult.ReadOnly = $true
$Form.Controls.Add($txtResult)

# Bouton copier
$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copier"
$btnCopy.Location = New-Object System.Drawing.Point(175,380)
$btnCopy.Size = New-Object System.Drawing.Size(100,30)
$Form.Controls.Add($btnCopy)

# icone checkmark 
$btnchkmark = New-Object System.Windows.Forms.Button
$btnchkmark.Location = New-Object System.Drawing.Point(300,380)
$btnchkmark.Size = New-Object System.Drawing.Size(30,30)
$btnchkmark.Enabled = $false
$Form.Controls.Add($btnchkmark)

# logique trigger du timer
$timer.Add_Tick({
    $btnGenerate.Enabled = $true
    $txtSecret.Enabled = $true
    $timer.Stop()
})

# logique du bouton paramètres
$btnSettings.Add_Click({
    & $settingsPagePath
})

#logique du bouton générer
$btnGenerate.Add_Click({
    $btnGenerate.Enabled = $false
    $txtSecret.Enabled = $false
    $txtSecret.Text | ConvertTo-Json | Set-Content -Encoding utf8 -Path $secretJSONpath
    if ($txtResult.Text -eq "") {
        & $pushPath
        $lien = Get-Content -Raw -Path $dataJSONpath | ConvertFrom-Json
        $txtResult.Text = $lien.html_url
    }
    else {
        $txtResult.Text = ""
        & $pushPath
        $lien = Get-Content -Raw -Path $dataJSONpath | ConvertFrom-Json
        $txtResult.Text = $lien.html_url
    }
    $timer.Start()
})

# logique de la checkmark du bouton copier
$btnCopy.Add_Click({
    if ($txtResult.Text -ne "") {
        [System.Windows.Forms.Clipboard]::SetText($txtResult.Text)
        $btnchkmark.Enabled = $true
        $btnchkmark.Image = [System.Drawing.Image]::FromFile($visuelsCHMKpath)
        Start-Sleep -Seconds 1.5
        $btnchkmark.Image = $null
        $btnchkmark.Enabled = $false
    }
})





$Form.ShowDialog()