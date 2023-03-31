<#.
    Description:
        The purpose of this script is to create bulk SCCM device collections with Query Membership Rules and other attributes specified within a .csv file.
        The .csv file and script can be modified to accommodate for a number of collection variables/attributes.

    Notes:
        Created by: John Wetzler
        Created date: March 16, 2023
        Updated date: March 31, 2023
        References: https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdevicecollection?view=sccm-ps
#>

$SiteCode = "Your3DigitSiteCode"
$SiteServer = "YourServer.FQDN.com"
$CsvPath = "C:\Temp\SCCM-CreateCollectionFromCSV.csv"
$CollectionTargetPath = $SiteCode+":\DeviceCollection\Johnz"

#Find SCCM Module Path
If (Test-Path "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -PathType Leaf){
    $ModulePath = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
    }
        Elseif (Test-Path "C:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -PathType Leaf){
            $ModulePath = "C:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
        }

#If the SCCM Module Path is not found from the above locations then EXIT the script.
If ($null -eq $ModulePath){
Write-Host "Could not find the path to: \Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1. Please ensure the Configuration Manager console is installed."
Exit
}

#Connect to SCCM Site
Import-Module $ModulePath
    If((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null){
        New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SiteServer
        Set-Location $SiteCode":"
    }
    Else{
        Set-Location $SiteCode":"
        }

#Import CSV File:
$CSV = Import-csv $CsvPath -Verbose

<#Set Refresh Schedule:
Create the schedule: $TestSchedule = New-CMSchedule -RecurInterval Days -RecurCount 7 -Start "9:00:00 PM"
The default schedule is: Full Update, Every 7 days, Effective date/time of script run time

Apply to a collection:
Set-CMCollection -Name $Collection.CollectionName -RefreshSchedule $TestSchedule -RefreshType Periodic
## Refresh Types: [Manual, Periodic (full), Continuous (incremental), Both (Periodic and Continuous).
#>

#Create the collections and apply properties.
ForEach($Collection in $CSV){
    
    #Check to see if Collection name already exists, if so, skip it.    
    If($CollectionExists = Get-CMCollection -Name $Collection.CollectionName){
        Write-Host $Collection.CollectionName": Already exists, no action taken."
    }
        Else{
            Write-Host $Collection.CollectionName": Does not exist, creating..."
            
            #Create the collection
            New-CMDeviceCollection -Name $Collection.CollectionName -LimitingCollectionName $Collection.LimitingCollectionName -Comment $Collection.Comment | Out-Null
                
                #If collection is created then apply Membership Query and Refresh Schedule
                If($CollectionCreated = Get-CMCollection -Name $Collection.CollectionName){
                    
                    #Add Query for Membership Rule
                    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection.CollectionName -RuleName $Collection.QueryName -QueryExpression $Collection.QueryRule | Out-Null
                    
                    #Add RefreshSchedule here if desired.

                    #Move collection to target folder.
                    Move-CMOBject -FolderPath $CollectionTargetPath -InputObject $CollectionCreated -Verbose
                    
                    Write-Host $Collection.CollectionName": Created succesfully."
                }
        }
}