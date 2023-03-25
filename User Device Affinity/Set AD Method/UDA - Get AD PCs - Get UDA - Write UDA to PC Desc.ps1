#Import SCCM Module for PowerShell
Import-Module "\\YourSCCM01\SMS_JON\AdminConsole\bin\ConfigurationManager.psd1"

#Change Directory to the ConfigManager Site Code
CD JON:

#Load list of PCs from OU
#$Computers = Get-ADComputer -Filter * -SearchBase "OU=DisableComputers,OU=Workstations,OU=US,DC=Corp,DC=Acxiom,DC=net" | Select name | Sort name

$Computers = Get-ADComputer -SearchBase "OU=Desktops,OU=Acxiom,OU=Windows 10,OU=Workstations,OU=US,DC=Corp,DC=Acxiom,DC=net" -Filter * -Properties * | where Description -eq $null  | Select Name, Description | Sort Name

#Should clean this up with less embedded If/ElseIf statements. Could use just separate Ifs and achieve the same thing.
ForEach ($Computer in $Computers){
$uda = Get-CMUserDeviceAffinity -DeviceName $Computer.Name

#Find UDA:
#If it's $null do nothing.
#If it's not $null then find and remove upper/lower "corp\"

	#If UDA is $null do nothing.	
	If (($uda.UniqueUserName).count -lt 1)
		{Write-Host $Computer.Name "Null"}
		Else
		{
			#LOWERCASE - If UDA contains "corp\" then remove it.
			If (($uda.uniqueusername).contains('corp\')){	
				$uda.uniqueusername = ($uda.uniqueusername).replace('corp\',"")
				Write-Host $Computer.Name $uda.UniqueUserName "Found and removed corp\"
			}
		
				#UPPERCASE - If UDA contains "CORP\" then remove it.
				ElseIf (($uda.uniqueusername).contains('CORP\')){
					$uda.uniqueusername = ($uda.uniqueusername).replace('CORP\',"")
					Write-Host $Computer.Name $uda.UniqueUserName "Found and removed CORP\"
					#Set-ADComputer -Identity $uda.ResourceName -Description $uda.uniqueUserName
				}
		}
	}
	

	If (($uda.UniqueUserName).count -eq 1){
		Write-Host $Computer.Name $uda.UniqueUserName
		Set-ADComputer -Identity $uda.ResourceName -Description $uda.uniqueUserName
	}
		ElseIf (($uda.UniqueUserName).count -gt 1){
			#Write-Host $Computer.Name "multiples"
			Write-Host $Computer.Name $uda.UniqueUserName[1]
			Set-ADComputer -Identity $Computer.Name -Description $uda.UniqueUserName[1]
		}
}