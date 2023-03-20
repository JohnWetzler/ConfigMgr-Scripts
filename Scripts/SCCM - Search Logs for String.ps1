#Search SCCM Log Files for Specific String:
$FileTypes = "*.log","*.xml"
Get-ChildItem -Path C:\Windows\CCM -Include $FileTypes -Recurse -Force -ErrorAction SilentlyContinue | Select-String "autologon64.exe" -List | Select Path | Out-GridView


#Search SCCM Log Files for Specific String and Delete Containing Files:
#Several of these Log Files are In Use by Client and can't be deleted. 
$FileTypes = "*.log","*.xml"
$Files = Get-ChildItem -Path C:\Windows\CCM -Include $FileTypes -Recurse -Force -ErrorAction SilentlyContinue | Select-String "autologon64.exe" -List | Select Path
	ForEach ($File in $Files){
		Write-Host $File.Path
		Remove-Item -Path $File.Path -Force
	}