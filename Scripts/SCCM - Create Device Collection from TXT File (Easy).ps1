#SCCM Console> Top Left Blue drop down> Connect via Windows PowerShell ISE: 

Get-Content "C:\Users\Me\Desktop\Test-Collection.txt" | foreach {
	Add-CMDeviceCollectionDirectMembershipRule -CollectionName "Test-PowerShellCollection" -ResourceID (Get-CMDevice -Name $_).ResourceID
}