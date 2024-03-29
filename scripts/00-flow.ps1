﻿# PowerShell is a cross-platform task automation solution made up 
# of a command-line shell, 
# a scripting language, and a configuration management framework. 
# PowerShell runs on Windows, Linux, and macOS
Start-Process "https://go.azuredemos.net/docs-pwsh-home"
# PowerShell is a modern command shell that includes the best features of other popular shells. 
# Unlike most shells that only accept and return text, 
# PowerShell accepts and returns .NET objects.
Start-Process "https://github.com/PowerShell/PowerShell.git"
# use Windows Terminal to run PowerShell and all other solutions
Start-Process "https://go.azuredemos.net/docs-terminal-home"
Start-Process "https://github.com/microsoft/terminal.git"
# if you wish to control Console as such, check out Console API here
# https://learn.microsoft.com/en-us/windows/console/console-reference

# Flow for the demos
## 1. Objects
## 2. Profiles & Aliases
## 3. Providers and write your own
## 4. Modules and Write your own cmdlets and scripts
## 5. random (useful) stuff
function global:prompt { Write-host ""; return 'MPGA (CSA)> ' }

# 0. Hello to all with ASCII version
# Install-Module -Name WriteAscii -Force
Write-Ascii "Welcome to PWSH tips and tricks"
Write-Ascii "PWSH $($PSVersionTable.PSVersion)"

# what is new as a module
# Install-Module Microsoft.PowerShell.WhatsNew -Force
Get-WhatsNew
Get-WhatsNew | Select-String security
Get-WhatsNew -Online

# 2. PowerShell is built on the .NET Framework, 
#    so you can use all the .NET Framework cmdlets and providers.
code "01-objects.ps1"

# 3.profiles and aliases
code "02-profiles.ps1"

# 4. Providers
code "03-providers.ps1"

# 5. modules
code "04-modules.ps1"

# 6. random / useful stuff
code "05-random.ps1"