$fileToCheck = "C:\windows\SysWOW64\msxml4.dll"
	if (-not (Test-Path $fileToCheck -PathType leaf)){
		Write-Host "Installed"
	}
	Else{
		regsvr32 /u msxml4.dll
		Remove-Item -Path C:\Windows\SysWOW64\msxml4.dll -Force
		Remove-Item -Path C:\Windows\SysWOW64\msxml4.inf -Force
		Remove-Item -Path C:\Windows\SysWOW64\msxml4a.dll -Force
		Remove-Item -Path C:\Windows\SysWOW64\msxml4r.dll -Force
	}