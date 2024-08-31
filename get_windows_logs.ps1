param(
	$var1 = "foo"
	)

$MY_VERSION = "2.0"
$path = (Get-Item -Path ".\").FullName
$results = Get-Date -Format o | foreach{$_ -replace ":","."}
$root = $path + "\" + $results
$mylog = $root + ".log"

Start-Transcript -Path $mylog

Write-Host "RETRIEVE LOGS VERSION" $MY_VERSION

$time1 = Get-Date

Write-Host "Logs will be saved in zip file $($root).zip"

Write-Host "Collecting logs, please wait ..."

#CREATE LOG DIRECTORY
New-Item -Path $root -ItemType Directory | Out-Null

Write-host "$env:SystemRoot\System32\winevt\Logs\"

$LOGS = Get-ChildItem -Path "$env:SystemRoot\System32\winevt\Logs\"

foreach ($log in $LOGS)
{
	Write-Host $log.FullName
	
	Copy-Item $log.Fullname -Destination $root
}

#COMPRESS
Write-Host "Zipping logs, please wait ..."
$destination = $root + ".zip"
Compress-Archive -Path $root -DestinationPath $destination

$time2 = Get-Date

$time_delta = ($time2-$time1).TotalSeconds

Write-Host "Log collection completed in $($time_delta) seconds"

Stop-Transcript