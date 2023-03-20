# Script to add the computername on which the script is executed on to specified groups
# Example Command line Powershell.exe -Set-ExecutionPolicy Bypass -File .\Removefromgroup.ps1 ADgroup1:adgroup2:"AD group3"

#$Groups = $args[0].Split(':')
$Groups = 'SCCM-Test-Group'

ForEach($Group in $Groups) {

    Try {

        $ComputerDn = ([ADSISEARCHER]"sAMAccountName=$($env:COMPUTERNAME)$").FindOne().Path
        $GroupDn = ([ADSISEARCHER]"sAMAccountName=$($Group)").FindOne().Path
        $Group = [ADSI]"$GroupDn"

        If(!$Group.IsMember($ComputerDn)) {
            $Group.Add($ComputerDn)
        }
    }
    Catch {
        $_.Exception.Message ; Exit 1
    }
}