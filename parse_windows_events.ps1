<#
.SYNOPSIS

"Extracts Informational, Warning, Error and Critical events from evtx files."

.DESCRIPTION

"Copy evtx files to same location as this cmdlet, then run."

.EXAMPLE
Extract events from evtx files.
.\parse_windows_events.ps1
#>

param(
	$LOGGING = $False
	)
	
$MAJOR = 1
$MINOR = 0

$MYPATH = (Get-Item -Path ".\").FullName
$MYRESULTS = Get-Date -Format o | foreach{$_ -replace ":","."}
$MYROOT = $MYPATH + "\" + $MYRESULTS
$MYLOG = $MYROOT + ".log"
$MYLOG_INFO = $MYROOT + "_info.txt"
$MYLOG_WARNING = $MYROOT + "_warnings.txt"
$MYLOG_ERROR = $MYROOT + "_errors.txt"
$MYLOG_CRITICAL = $MYROOT + "_critical.txt"

$MY_COUNT_INFO = 1
$MY_COUNT_WARNING = 1
$MY_COUNT_ERROR = 1
$MY_COUNT_CRITICAL = 1

$MY_LASTBASENAME = "foo"

if($LOGGING -eq $True)
{
	Start-Transcript -Path $MYLOG
}

Write-Host "Parse Windows Events Version $($MAJOR).$($MINOR)"

Get-ChildItem $MYPATH -Filter "*.evtx" | Sort-Object -Property CreationTime | 
Where-Object { $_.Attributes -ne "Directory"} | ForEach-Object {
    Write-Host $_.FullName
	
	Write-Host $_.BaseName $MY_LASTBASENAME
	
	if($MY_LASTBASENAME -eq "foo")
	{
		$MYLOG_INFO = $MYROOT + "_" + $_.BaseName + "_info.txt"
		$MYLOG_WARNING = $MYROOT + "_" + $_.BaseName + "_warnings.txt"
		$MYLOG_ERROR = $MYROOT + "_" + $_.BaseName + "_errors.txt"
		$MYLOG_CRITICAL = $MYROOT + "_" + $_.BaseName + "_critical.txt"
		
		$MY_LASTBASENAME = $_.BaseName
		
		$MY_COUNT_INFO = 1
		$MY_COUNT_WARNING = 1
		$MY_COUNT_ERROR = 1
		$MY_COUNT_CRITICAL = 1
	}
	else
	{
		if($_.BaseName -notmatch $MY_LASTBASENAME)
		{
			$MYLOG_INFO = $MYROOT + "_" + $_.BaseName + "_info.txt"
			$MYLOG_WARNING = $MYROOT + "_" + $_.BaseName + "_warnings.txt"
			$MYLOG_ERROR = $MYROOT + "_" + $_.BaseName + "_errors.txt"
			$MYLOG_CRITICAL = $MYROOT + "_" + $_.BaseName + "_critical.txt"
			
			$MY_LASTBASENAME = $_.BaseName
			
			$MY_COUNT_INFO = 1
			$MY_COUNT_WARNING = 1
			$MY_COUNT_ERROR = 1
			$MY_COUNT_CRITICAL = 1
		}
	}

	Out-File -Append -FilePath $MYLOG_INFO -InputObject $_.FullName
	Out-File -Append -FilePath $MYLOG_WARNING -InputObject $_.FullName
	Out-File -Append -FilePath $MYLOG_ERROR -InputObject $_.FullName
	Out-File -Append -FilePath $MYLOG_CRITICAL -InputObject $_.FullName

    Get-WinEvent -Path $_.FullName | Where-Object {$_.Level -eq 4} | format-table -wrap -autosize | Out-File -Append $MYLOG_INFO
	Get-WinEvent -Path $_.FullName | Where-Object {$_.Level -eq 3} | format-table -wrap -autosize | Out-File -Append $MYLOG_WARNING
	Get-WinEvent -Path $_.FullName | Where-Object {$_.Level -eq 2} | format-table -wrap -autosize | Out-File -Append $MYLOG_ERROR
	Get-WinEvent -Path $_.FullName | Where-Object {$_.Level -eq 1} | format-table -wrap -autosize | Out-File -Append $MYLOG_CRITICAL
	
	if( ((Get-Item $MYLOG_INFO).Length) -gt 100 )
    {
        $MYLOG_INFO = $MYROOT + "_" + $MY_LASTBASENAME + "_info_" + $MY_COUNT_INFO + ".txt"

        $MY_COUNT_INFO = $MY_COUNT_INFO + 1
    }
	
	if( ((Get-Item $MYLOG_WARNING).Length) -gt 100 )
    {
        $MYLOG_WARNING = $MYROOT + "_" + $MY_LASTBASENAME + "_warnings_" + $MY_COUNT_WARNING + ".txt"

        $MY_COUNT_WARNING = $MY_COUNT_WARNING + 1
    }
	
	if( ((Get-Item $MYLOG_ERROR).Length) -gt 100 )
    {
        $MYLOG_ERROR = $MYROOT + "_" + $MY_LASTBASENAME + "_errors_" + $MY_COUNT_ERROR + ".txt"

        $MY_COUNT_ERROR = $MY_COUNT_ERROR + 1
    }
	
	if( ((Get-Item $MYLOG_CRITICAL).Length) -gt 100 )
    {
        $MYLOG_CRITICAL = $MYROOT + "_" + $MY_LASTBASENAME + "_critical_" + $MY_COUNT_CRITICAL + ".txt"

        $MY_COUNT_CRITICAL = $MY_COUNT_CRITICAL + 1
    }
}

if($LOGGING -eq $True)
{
	Stop-Transcript
}





