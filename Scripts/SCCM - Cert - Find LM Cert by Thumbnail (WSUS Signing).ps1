<#if (Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Thumbprint -eq "0edef690226f7a527afbfb8682b0387cc2a7fba9"})
{Write-Host "Installed"}
#>

function DetectCert {
$ThumbPrint = "0edef690226f7a527afbfb8682b0387cc2a7fba9"
$FindCert = (Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Thumbprint -eq $ThumbPrint})
	If ([boolean]$FindCert -eq $true) {
		Return $True
	} else {
		Return $False
	}
}

DetectCert