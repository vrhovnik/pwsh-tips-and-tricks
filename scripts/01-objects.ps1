### classic object work with PWSH ####
Set-Location "$home\Downloads"
Get-ChildItem | Get-Member | Select-Object TypeName -Unique
# create some dummy data
1..10 | ForEach-Object { New-Item -Type File "file$_.pwshrules" }
# create same ammount of other files
1..(Get-ChildItem | Measure-Object | Select-Object -ExpandProperty Count) | ForEach-Object { New-Item -Type File "file$_.pwshrules2" }
# get more information and traverse through the objects
Get-ChildItem | Format-List -Property * # it gets all of the properties
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

# example using Win 32 API
& ".\01-objects-MaximizeWindow.ps1"

