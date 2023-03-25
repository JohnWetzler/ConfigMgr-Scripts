<#Contoso's PCs contain the Username + Date of Hire: jwetzl1120.
By using Excel, we can split the username from the date, then
set add the username to the Computer's Description in Active Directory.
We can also set User Device Affinity within SCCM Console for Primary Users.

Import and set the User Device Affinity from a csv containing Primary Users and Corresponding PCs
***Import will fail if any PC in the CSV is not found in SCCM***

CSV Format should be:
Header Column (A1):         User | Data (A2): Corp\UserID
Header Column (B1):       Device | Data (B2): PCName
#>

#Import SCCM Module for PowerShell
Import-Module "\\cwywsm01\SMS_ACX\AdminConsole\bin\ConfigurationManager.psd1"

#Change Directory to the ConfigManager Site Code
CD ACX:

Import-CMUserDeviceAffinity -FileName "C:\Users\jwetzl\Desktop\UDA.csv" -EnableColumnHeadings $True