# Flow for the demos
## Aliases
## Providers
## Modules
## Objects & Error handling
## Controlling your environment
## Write your own cmdlets and scripts

# 0. Hello to all with version
Write-Ascii "Welcome to PWSH tips and tricks"
Write-Ascii "Currently in PWSH $($PSVersionTable.PSVersion)"

# 1. Introduction PWSH home and keeping up with latest and greatest
# why / what / install PWSH and Windows Terminal
# if you wish to control Console as such, check out Console API here
# https://learn.microsoft.com/en-us/windows/console/console-reference
Start-Process "https://go.azuredemos.net/docs-pwsh-home"
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
Get-ChildItem | Get-Member | Select-Object TypeName -Unique
# create some dummy data
1..10 | ForEach-Object { New-Item -Type File "file$_.pwshrules" }
# create same ammount of other files
1..(Get-ChildItem | Measure-Object | Select-Object -ExpandProperty Count) | ForEach-Object { New-Item -Type File "file$_.pwshrules2" }
# get more information and traverse through the objects
Get-ChildItem | FOrmat-List -Property * # it gets all of the properties
Get-ChildItem | Get-Member
Get-ChildItem | Select-Object -ExpandProperty PsParentPath -Unique | Get-Member
Get-ChildItem | Select-Object -ExpandProperty PsParentPath -Unique -OutVariable data | Get-Member
$data | Get-Member
$data.Split("::")
$data.Split("::")[1]
$home
$data.Split("::")[1] | Set-Location

# example with speech object
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak("Hello, objects and .NET rules")

#example with links and images
Start-Process "https://go.azuredemos.net/caf-tools"
Invoke-WebRequest -Uri "https://go.azuredemos.net/caf" -OutVariable site
$site.Links | ForEach-Object {$_."data-linktype"}
$site.Links | Select-Object -ExpandProperty outerHTML | Select-String "data-linktype=\""external\""" | ForEach-Object {$_ -replace '.*href="(.*?)".*','$1'}

Invoke-WebRequest -Uri "https://www.bing.com/images/search?q=powershell" -OutVariable site
$site.Images | ForEach-Object {$_.src2} | Select-String hero | Select-Object -First 1 -ExpandProperty Line
Start-Process -Path ($site.Images | ForEach-Object {$_.src2} | Select-String hero | Select-Object -First 1 -ExpandProperty Line)

# remove specific folders bin,obj
Get-ChildItem .\ -Include bin,obj -Recurse | ForEach-Object { Remove-Item $_.FullName -Force -Recurse }

# custom formatting
$fields = "Name",@{Label = "Length (MB)"; Expression = {$_.Length / 1mb}; Align = "Right"}
Get-ChildItem "C:\Users\bovrhovn\OneDrive - Microsoft\Documents" -File | Format-Table $fields -Auto

# 3. Providers
Get-PSProvider
Get-ChildItem env:

$env:PSModulePath -split ';'
