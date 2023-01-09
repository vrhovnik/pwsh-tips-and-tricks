### Modules in POWERSHELL ###
$env:PSModulePath -split ';'

# add module from gallery
# https://github.com/dfinke/PowerShellHumanizer
# https://humanizr.net/
Start-Process "https://humanizr.net/"
Install-Module -Name PowerShellHumanizer -Force
"ConvertTo-Quantity: {0}"       -f (1111 | ConvertTo-Quantity test -showQuantityAs Words)
"ConvertTo-HumanDate: {0}"      -f (ConvertTo-HumanDate (Get-Date).AddDays(-1) )
"ConvertTo-HumanDate: {0}"      -f (ConvertTo-HumanDate (Get-Date).AddDays(1) )
"ConvertTo-RomanNumeral: {0}"   -f (ConvertTo-RomanNumeral 42)
"ConvertFrom-RomanNumeral: {0}" -f (ConvertTo-RomanNumeral 42|ConvertFrom-RomanNumeral)
"ConvertTo-Casing: {0}"         -f (ConvertTo-Casing "some text this is" -Case Title)
"ConvertTo-Ordinal: {0}"        -f (ConvertTo-Ordinal 1111)
"ConvertTo-Singular: {0}"       -f (ConvertTo-Singular people)
"great_king" | ConvertTo-Plural
"mr_chatgp_the_ai" | ConvertTo-HyphenatedString

Start-Process "https://psframework.org/"
Install-Module -Name PSUtil -Force
1..3 | format "192.168.2.{0}"

# custom module import and work with it
Set-Location "C:\Work\Projects\pwsh-tips-and-tricks\src\PWSHDemos\PWSH.K8S\bin\Debug\net7.0"
Import-Module "PWSH.K8S.dll"
Get-NsPods -NamespaceName "portainer"

# get me only containers with name and other information
Get-NsPods -NamespaceName portainer | Select-Object -ExpandProperty Spec | Select-Object -ExpandProperty Containers