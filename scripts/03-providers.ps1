### PROVIDERS in POWERSHELL ###

# Get all providers
Get-PSProvider

# Navigate environment variables
Get-ChildItem env:
Get-ChildItem variable:

# create your own drive by using a provider
New-PSDrive -PSProvider FileSystem -Name "WRK" -Root "C:\Work\" -Scope Global



