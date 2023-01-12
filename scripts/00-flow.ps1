# Flow for the demos
## 1. Objects
## 2. Profiles & Aliases
## 3. Providers and write your own
## 4. Modules and Write your own cmdlets and scripts
## 5. random (useful) stuff
function global:prompt { Write-host ""; return 'MPGA (CSA)> ' }

# 0. Hello to all with ASCII version
Write-Ascii "Welcome to PWSH tips and tricks"
Write-Ascii "PWSH $($PSVersionTable.PSVersion)"

# 1. Introduction PWSH home and keeping up with latest and greatest
# why / what / install PWSH and Windows Terminal
# if you wish to control Console as such, check out Console API here
# https://learn.microsoft.com/en-us/windows/console/console-reference
Start-Process "https://go.azuredemos.net/docs-pwsh-home"
Start-Process "https://github.com/PowerShell/PowerShell.git"
Start-Process "https://go.azuredemos.net/docs-terminal-home"
Start-Process "https://github.com/microsoft/terminal.git"

# what is new as a module
# Install-Module Microsoft.PowerShell.WhatsNew -Force
Get-WhatsNew
Get-WhatsNew | Select-String security
Get-WhatsNew -Online

# 2. What is PWSH and difference between other shells
# PowerShell is a modern command shell that includes the best features of other popular shells. 
# Unlike most shells that only accept and return text, PowerShell accepts and returns .NET objects.
# PowerShell is built on the .NET Framework, so you can use all the .NET Framework cmdlets and providers.
code "01-objects.ps1"

# 3.profiles and aliases
code "02-profiles.ps1"

# 4. Providers
code "03-providers.ps1"

# 5. modules
code "04-modules.ps1"

# 6. random / useful stuff
code "05-random.ps1"