<# Import user device affinities from a file:
https://docs.microsoft.com/en-us/powershell/module/configurationmanager/import-cmuserdeviceaffinity?view=sccm-ps
https://docs.microsoft.com/en-us/mem/configmgr/apps/deploy-use/link-users-and-devices-with-user-device-affinity

To create many relationships at one time, import a file that has the details for multiple user device affinities. 
Make sure the target devices are already discovered by the site and exist as resources in the Configuration Manager database.

In the Configuration Manager console, go to Assets & Compliance> Users or Devices node.
From the Home tab ribbon> Create group> choose Import User Device Affinity.
In the Import User Device Affinity Wizard, on the Choose Mapping page, set this information:

File name. Specify a comma-separated values (CSV) file that has a list of users and devices between which you want to create an affinity. 
In this file, each user-and-device pair must be on its own row, with values separated by a comma. 
Use this format: <domain>\<username>,<device NetBIOS name>

This file has column headings for reference purposes. If the .csv file has a top-row header, select this option. 
The site ignores the header row during the import.

If the file you import has more than two items in each row, use Column and Assign to specify which columns represent users and devices, 
and which columns to ignore during import.
Complete the wizard.
#>

<#File Example:
user (ColumnA)    device (ColumnB)
Contoso\ASMITH	ASMITH1219
Contoso\BSMITH	BSMITH0620
Contoso\CSMITH	CSMITH1020
#>

#Import SCCM Module for PowerShell
Import-Module "\\SCCMServer01\SMS_ACX\AdminConsole\bin\ConfigurationManager.psd1"

#Change Directory to the ConfigManager Site Code
CD ACX:

Import-CMUserDeviceAffinity -FileName "C:\Users\Me\Desktop\test.csv" -EnableColumnHeadings $True