$PCList = get-content -path "C:\Users\Me\desktop\PCs.txt"
#PCs.txt should contain a list of the usernames you want to gather AD info from.
$ExportPath = "C:\Users\Me\desktop\PCs.csv"

CD "C:\Program Files (x86)\Microsoft Endpoint Manager\AdminConsole\bin"
Import-Module .\ConfigurationManager.psd1
CD ACX:

ForEach ($PC in $PCList){
	Get-CMUserDeviceAffinity -DeviceName $PC | select UniqueUsername, ResourceName | Export-CSV $ExportPath -Append -NoTypeInformation
}