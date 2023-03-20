#Find Empty SCCM Inbox Directories
#YourSCCMServer\E$\sccm\inboxes\statmgr.box

(gci C:\Scripts -r | ? {$_.PSIsContainer -eq $True}) | ? {$_.GetFiles().Count -eq 0} | select FullName
(gci V:\SCCM\inboxes -r | ? {$_.PSIsContainer -eq $True}) | ? {$_.GetFiles().Count -eq 0} | select FullName
(gci V:\SCCM\inboxes -r | ? {$_.PSIsContainer -eq $False}) | select FullName