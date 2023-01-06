### PROFILES in PowerShell ###

## run profile from PWSH core
code $profile
## run windows powershell from terminal
$profile

# run powershell with flags and settings file
Start-Process "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.3"
Start-Process "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_config?view=powershell-7.3"
pwsh -NoProfile -NoExit -WorkingDirectory "C:\Work\" -SettingsFile "C:\Work\Documents\PWSH\Settings\powershell.config.json" 