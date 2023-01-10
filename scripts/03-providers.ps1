### PROVIDERS in POWERSHELL ###
## Provider defines the logic that is used to access, navigate, and edit a data store, 
## while a drive specifies a specific entry point to a data store

# Get all providers registered on the system
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
# check the code for the provider 
# Get-Content ".\src\PWSHDemos\PWSH.K8S\KProvider.cs"
Set-Location "C:\Work\Projects\pwsh-tips-and-tricks\src\PWSHDemos\PWSH.K8S\bin\Debug\net7.0"
Import-Module ".\PWSH.K8S.dll"
Get-PSProvider

# navigate to the provider and get child items as it would be a drive
Set-Location K8D:
# get all namespaces
Get-ChildItem
Set-Location "portainer"
# get all pods
Get-ChildItem
