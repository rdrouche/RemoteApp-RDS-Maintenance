function Set-RemoteAppMaintenance{
    param([string]$appname)

    # Init WinForm
    $alertmessage.text = ""

    Write-Debug "Enter in function : Set-RemoteAppMaintenance for App : $appname"

    $RemotesApp = Get-RDRemoteApp -DisplayName $appname

    Foreach($RemoteApp in $RemotesApp){
        # New registry entry for RemoteApp to Set Maintenance
        Push-Location
        Set-Location HKLM:\Software\RemoteAppsMaintenance
        New-Item -Path "HKLM:\Software\RemoteAppsMaintenance\$($RemoteApp.DisplayName)"
        Write-Debug $RemoteApp.DisplayName
        # FilePath
        New-ItemProperty -Path "HKLM:\Software\RemoteAppsMaintenance\$($RemoteApp.DisplayName)" -Name FilePath -PropertyType String -Value $RemoteApp.FilePath
        # CollectionName
        New-ItemProperty -Path "HKLM:\Software\RemoteAppsMaintenance\$($RemoteApp.DisplayName)" -Name CollectionName -PropertyType String -Value $RemoteApp.CollectionName
        # Alias
        New-ItemProperty -Path "HKLM:\Software\RemoteAppsMaintenance\$($RemoteApp.DisplayName)" -Name Alias -PropertyType String -Value $RemoteApp.Alias
        Pop-Location
        Write-Debug "Change FilePath for App"
        Set-RDRemoteApp -CollectionName $RemoteApp.CollectionName -Alias $RemoteApp.Alias -FilePath "C:\maintenance\stop.exe"
        Write-Debug "$appname is offline"
    }

    # Remove App for available in GUI
    $remoteapplist.Items.Remove($appname)
    # Add App in maintenance in GUI
    $remoteappinmaintenance.Items.Add($appname)

    # Show success message in GUI
    $alertmessage.ForeColor = "#417505"
    $alertmessage.text = "Success : App is offiline"

    Write-Debug "Exit from function : Set-RemoteAppMaintenance for App : $appname"   
}

function Set-RemoteAppService{
    param([string]$appname)

    # Init WinForm
    $alertmessage.text = ""

    Write-Debug "Enter in function : Set-RemoteAppService for App : $appname"

    if($appname -eq ""){
        Write-Debug "Invalide app"
        $alertmessage.ForeColor = "#d0021b"
        $alertmessage.text = "Error : app is empty"
        exit
    }

    # Get name current broker server
    $serverbroker = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
    Write-Debug "Current broker server : $serverbroker"

    # Get info app from registry
    $r = Test-Path "HKLM:\Software\RemoteAppsMaintenance\$($appname)"
    if($r -eq $false){
        Write-Debug "Error : App not found in registry."
        $alertmessage.text = "Error : App not found in registry."
    }else{
        Write-Debug "App found in registry"

        # Get Data
        $AppFilePath = (New-Object -ComObject WScript.Shell).RegRead("HKLM\Software\RemoteAppsMaintenance\$($appname)\FilePath")
        Write-Debug "App -FilePath : $AppFilePath"
        $AppCollectionName = (New-Object -ComObject WScript.Shell).RegRead("HKLM\Software\RemoteAppsMaintenance\$($appname)\CollectionName")
        Write-Debug "App -CollectionName : $AppCollectionName"
        $AppAlias = (New-Object -ComObject WScript.Shell).RegRead("HKLM\Software\RemoteAppsMaintenance\$($appname)\Alias")
        Write-Debug "App -Alias : $AppAlias"

        # Restore good exe file
        Write-Debug "Restore FilePath"
        Set-RDRemoteApp -CollectionName $AppCollectionName -Alias $AppAlias -FilePath $AppFilePath

        # Remove App for maintenance in GUI
        $remoteappinmaintenance.Items.Remove($appname)
        # Add App in available in GUI
        $remoteapplist.Items.Add($appname)

        # Remove app infos from registry
        Write-Debug "Remove app infos from registry."
        Push-Location
        Set-Location HKLM:\Software\RemoteAppsMaintenance
        Remove-Item -Path "HKLM:\Software\RemoteAppsMaintenance\$($appname)" -Recurse
        Pop-Location

        # Show success message in GUI
        $alertmessage.ForeColor = "#417505"
        $alertmessage.text = "Success : App is online"
    }

    Write-Debug "Exit from function : Set-RemoteAppService for App : $appname"
    Write-Debug "$appname is online"
}

<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    RemoteAppMaintenance
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$RemoteappWinForm                = New-Object system.Windows.Forms.Form
$RemoteappWinForm.ClientSize     = '400,400'
$RemoteappWinForm.text           = "RDS - RemoteApp - Maintenance"
$RemoteappWinForm.TopMost        = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Liste des RemoteApp :"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(129,29)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$remoteapplist                   = New-Object system.Windows.Forms.ComboBox
$remoteapplist.text              = "Choisir une application"
$remoteapplist.width             = 337
$remoteapplist.height            = 77
$remoteapplist.location          = New-Object System.Drawing.Point(36,62)
$remoteapplist.Font              = 'Microsoft Sans Serif,10'

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Mettre en maintenance"
$Button1.width                   = 187
$Button1.height                  = 32
$Button1.location                = New-Object System.Drawing.Point(105,102)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$alertmessage                    = New-Object system.Windows.Forms.Label
$alertmessage.AutoSize           = $true
$alertmessage.width              = 250
$alertmessage.height             = 100
$alertmessage.location           = New-Object System.Drawing.Point(157,350)
$alertmessage.Font               = 'Microsoft Sans Serif,10'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Application en maintenance :"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(110,195)
$Label2.Font                     = 'Microsoft Sans Serif,10'

$remoteappinmaintenance          = New-Object system.Windows.Forms.ComboBox
$remoteappinmaintenance.text     = "Choisir une application pour la sortie de la maintenance"
$remoteappinmaintenance.width    = 337
$remoteappinmaintenance.height   = 77
$remoteappinmaintenance.location  = New-Object System.Drawing.Point(40,224)
$remoteappinmaintenance.Font     = 'Microsoft Sans Serif,10'

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Mettre en service"
$Button2.width                   = 187
$Button2.height                  = 32
$Button2.location                = New-Object System.Drawing.Point(105,261)
$Button2.Font                    = 'Microsoft Sans Serif,10'

$RemoteappWinForm.controls.AddRange(@($Label1,$remoteapplist,$Button1,$alertmessage,$Label2,$remoteappinmaintenance,$Button2))


#Write your logic code here
$DebugPreference = "Continue"

Push-Location

# Init registry
Set-Location HKLM:\Software
$r = Test-Path HKLM:\Software\RemoteAppsMaintenance

if($r -eq $false){
    New-Item -Path HKLM:\Software\RemoteAppsMaintenance
    Write-Debug "Create registry folder"
}

Pop-Location

#Import-Module RemoteDesktop
$Apps = Get-RDRemoteApp
$Apps | Format-List
Write-Debug "Get list RemoteApp"
Foreach($App in $Apps){
    
    #Write-Debug "App $App.DisplayName found"
    if( $App.FilePath -eq "C:\maintenance\stop.exe" ){
        $remoteappinmaintenance.Items.Add($App.DisplayName)
    }else{
        $remoteapplist.Items.Add($App.DisplayName)
    }
}

# Export RemoteApp in file if a bug
Write-Debug "Export RemoteApp in CSV for memory"
$Apps | Export-Csv -Path C:\ProgramData\RemoteAppListMaintenance-$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv -NoTypeInformation

# Action on Click button
$Button1.add_Click({Set-RemoteAppMaintenance -appname $remoteapplist.SelectedItem})
$Button2.add_Click({Set-RemoteAppService -appname $remoteappinmaintenance.SelectedItem})

[void]$RemoteappWinForm.ShowDialog()