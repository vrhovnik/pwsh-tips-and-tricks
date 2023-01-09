### PROVIDERS in POWERSHELL ###

# Get all providers
Get-PSProvider

# Navigate environment variables
Get-ChildItem env:
Get-ChildItem variable:

Set-Location Cert:
Get-ChildItem
# navigate to my certs
Set-Location "CurrentUser\My\"
Get-ChildItem

# control windows by setting registry item
Set-Location "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
# enable center
New-ItemProperty -Name "TaskbarAl" -Path  ($pwd | Select-Object -Expand Path).Replace("HKLM:", "Registry::HKEY_CURRENT_USER") -Value 1 -Type DWord -Force
# go back to Left
New-ItemProperty -Name "TaskbarAl" -Path  ($pwd | Select-Object -Expand Path).Replace("HKLM:", "Registry::HKEY_CURRENT_USER") -Value 0 -Type DWord -Force

# create your own drive by using an existing provider
Set-Location $HOME
New-PSDrive -PSProvider FileSystem -Name "WRK" -Root "C:\Work\" -Scope Global

# built your own provider - check src folder
Get-Content ".\src\PWSHDemos\PWSH.K8S\KProvider.cs"
