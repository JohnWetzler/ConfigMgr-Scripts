$CCMComObject = New-Object -ComObject ‘UIResource.UIResourceMgr’## Get the CacheElementIDs to delete
$cache = $CCMComObject.GetCacheInfo()
#$Cache.totalsize = 10240
$Cache.totalsize = 20480 #MegaBytes