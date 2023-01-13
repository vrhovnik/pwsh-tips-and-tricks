### classic object work with PWSH ####
Set-Location "$home\Downloads"
# create some dummy data
1..10 | ForEach-Object { New-Item -Type File "file$_.pwshrules" }
# get properties of the cmdlets
# Get-Command, Get-Member, Get-Help -Detailed Get-ChildItem
# get return .NET objects properties and methods
Get-ChildItem | Get-Member | Select-Object TypeName -Unique
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

# create same ammount of other files
1..(Get-ChildItem | Measure-Object | Select-Object -ExpandProperty Count) | ForEach-Object { New-Item -Type File "file$_.pwshrules2" }

# multiple variables - how to get multiple values from directory
# get folder numbers, get all of the files and lentgth of all files all together
# Really good video about using this is debugging option https://www.youtube.com/watch?v=tz0pcE1e2us&t=738s
$directories,$files = Get-ChildItem -Force -Recurse | Measure-Object -Sum PSIsContainer, Length -ErrorAction Ignore
$directories,$files

## read rss
## snippet code from https://powershellisfun.com/
Start-Process "https://azurecomcdn.azureedge.net/en-us/blog/feed/"
$total = foreach ($item in Invoke-RestMethod -Uri "https://azurecomcdn.azureedge.net/en-us/blog/feed/" ) {
    [PSCustomObject]@{
        'Date published'   = $item.pubDate
        Title              = $item.Title
        Link               = $item.Link
    }
}

$total | Sort-Object { $_."Date published" -as [datetime] } |  Select-Object -Last 10
$total | Where-Object { $_.Title -like "*cost*" } | Select-Object -ExpandProperty Link -First 1 
Start-Process ($total | Where-Object { $_.Title -like "*cost*" } | Select-Object -ExpandProperty Link -First 1)

#example with web pages links and images
Invoke-WebRequest wttr.in
# show ascii art as it should be in terminal
Invoke-WebRequest wttr.in | Select-Object -ExpandProperty Content
Invoke-WebRequest cheat.sh/powershell | Select-Object -ExpandProperty Content

Start-Process "https://go.azuredemos.net/caf-tools"
Invoke-WebRequest -Uri "https://go.azuredemos.net/caf-tools" -OutVariable site
$site.Links | ForEach-Object {$_."data-linktype"}
$site.Links | Select-Object -ExpandProperty outerHTML | Select-String "data-linktype=\""external\""" | ForEach-Object {$_ -replace '.*href="(.*?)".*','$1'}

Invoke-WebRequest -Uri "https://www.bing.com/images/search?q=powershell" -OutVariable site
$site.Images | ForEach-Object {$_.src2} | Select-String hero | Select-Object -First 1 -ExpandProperty Line
Start-Process -Path ($site.Images | ForEach-Object {$_.src2} | Select-String hero | Select-Object -First 1 -ExpandProperty Line)

# work with json - very easy to work with and really powerfull
Set-Location "C:\Work\Projects\pwsh-tips-and-tricks\files"
$json = Get-Content appsettings.json | ConvertFrom-Json
Write-Output $json
# get azure domain value
$json.AzureAd.Domain
# change azure domain value to microsoft.onmicrosoft.com
$json.AzureAd.Domain = "microsoft.onmicrosoft.com"
# write back to file
$json | ConvertTo-Json | Set-Content appsettings.json
#read new values
$json = Get-Content appsettings.json | ConvertFrom-Json
$json.AzureAd.Domain

# example with speech object
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak("Öbjects and .NET rules")

# example native windows commands - Win 32 API
Set-Location "C:\Work\Projects\pwsh-tips-and-tricks\scripts"
& ".\01-objects-MaximizeWindow.ps1"