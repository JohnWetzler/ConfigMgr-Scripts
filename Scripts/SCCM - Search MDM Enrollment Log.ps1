<#
https://stackoverflow.com/questions/8153750/how-to-search-a-string-in-multiple-files-and-return-the-names-of-files-in-powers
Get-ChildItem -Recurse | Select-String "dummy" -List | Select Path
#>
#Filename = CoManagementHandler.log
$FileTypes = "*.log","*.xml"
$Files = Get-ChildItem -Path C:\Windows\CCM\Logs\ -Include $FileTypes -Recurse -Force -ErrorAction SilentlyContinue | Select-String "MDM enrollment succeeded" -List | Select Path
ForEach ($File in $Files){Write-Host $File.Path
#Remove-Item -Path $File.Path -Force
}