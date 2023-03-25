$UserNamesList = get-content -path "C:\Users\Me\desktop\Users.txt"
#AD_Users.txt should contain a list of the usernames you want to gather AD info from.
#Usernames should have "Contos\YourUsername" or Domain\username
$ExportPath = "C:\Users\Me\desktop\UsersPrimaryPCs.csv"

CD "C:\Program Files (x86)\Microsoft Endpoint Manager\AdminConsole\bin"
Import-Module .\ConfigurationManager.psd1
CD ACX:

ForEach ($name in $UserNamesList){
	Get-CMUserDeviceAffinity -UserName $name | select UniqueUsername, ResourceName | Export-CSV $ExportPath -Append -NoTypeInformation
}