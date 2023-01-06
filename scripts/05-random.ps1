### random useful stuff in PWSH ###
Set-Location "c:\Work\Documents\PWSH\Scripts"
(Get-Acl $(Get-Item .\dynamic-variable.ps1)).Owner

# remove specific folders bin,obj
# shared by Ardalis
Get-ChildItem .\ -Include bin,obj -Recurse | ForEach-Object { Remove-Item $_.FullName -Force -Recurse }

# custom formatting
$fields = "Name",@{Label = "Length (MB)"; Expression = {$_.Length / 1mb}; Align = "Right"}
Get-ChildItem "C:\Users\bovrhovn\OneDrive - Microsoft\Documents" -File | Format-Table $fields -Auto