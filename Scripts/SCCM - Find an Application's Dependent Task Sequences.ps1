﻿#https://msendpointmgr.com/2018/12/09/detect-and-remove-application-from-dependent-task-sequences-with-powershell/ 
#Site configuration
$ApplicationName = "F5 Edge Client 72.2021.1126.1205" #Complete Name of the application
$SiteServer = "SCCM01.corp.contoso.net" #Your site server name
$SiteCode ="CON" #Your site code ACX/AXM

# Customizations
$initParams = @{}

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

#Get SMS_ApplicationLatest WMI object
$Application = Get-CMApplication -Name "$ApplicationName"

#Get Application Model Names
$ApplicationModelName = $Application.ModelName
$TaskSequencePackageIDs = (Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class "SMS_TaskSequenceAppReferencesInfo" -ComputerName $SiteServer -Filter "RefAppModelName like '$ApplicationModelName'").PackageID
foreach ($TaskSequencePackageId in $TaskSequencePackageIds)
{
    $TaskSquenceName = (Get-CMTaskSequence -TaskSequencePackageId $TaskSequencePackageId).Name
    Write-host "Application name: $($Application.LocalizedDisplayName). Dependent TaskSequence is: $TaskSquenceName." -ForegroundColor Green
}