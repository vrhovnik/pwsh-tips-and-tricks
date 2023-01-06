### PROFILES in PowerShell ###
# InstallationDirectory\profile.ps1** - Customization of all PowerShell sessions, including PowerShell hosting applications for all users on the system
# InstallationDirectory\Microsoft.PowerShell_profile.ps1** - Customization of pwsh.exe sessions for all users on the system
# My Documents\PowerShell\profile.ps1** - Customization of all PowerShell sessions, including PowerShell hosting applications
# My Documents\PowerShell\Microsoft.PowerShell_profile.ps1** - Typical customization of pwsh.exe sessions

$profile | Format-List -Force

## run profile from PWSH core
code $profile

## run windows powershell from terminal
$profile

# run powershell with flags and settings file
Start-Process "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.3"
Start-Process "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_config?view=powershell-7.3"

pwsh -NoProfile -NoExit -WorkingDirectory "C:\Work\" -SettingsFile "C:\Work\Documents\PWSH\Settings\powershell.config.json" 