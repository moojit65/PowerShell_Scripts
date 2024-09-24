<#
.SYNOPSIS

"Application Firewall Rule Cmdlet."

.DESCRIPTION

"Adds, removes, enables, disables, and lists application firewall rules."

.EXAMPLE
Lists All Firewall Rules.
.\new_firewall_app_rule.ps1 -LIST $True

.EXAMPLE
Retrieves detail on one specific firewall rule.
.\new_firewall_app_rule.ps1 -DisplayName "Core Networking - DNS (UDP-Out)"

.EXAMPLE
Adds application firewall rule (default direction is Inbound).
.\new_firewall_app_rule.ps1 -ADD $True -PROGRAM 'C:\Windows\notepad.exe' -DISPLAY_NAME "All Notepad (IN)"

.EXAMPLE
Disables firewall rule.
.\new_firewall_app_rule.ps1 -DISABLE $True -DISPLAY_NAME "All Notepad (IN)"

.EXAMPLE
Enables firewall rule.
.\new_firewall_app_rule.ps1 -ENABLE $True -DISPLAY_NAME "All Notepad (IN)"

.EXAMPLE
Removes firewall rule.
.\new_firewall_app_rule.ps1 -REMOVE $True -DISPLAY_NAME "All Notepad (IN)"

.EXAMPLE
Gets detail on one firewall rule.
.\new_firewall_app_rule.ps1 -DETAIL $True -DISPLAY_NAME "All Notepad (IN)"
#>

param(
	$LOGGING = $False,
	$LIST =  $False,
	$ADD = $False,
	[Parameter(Mandatory=$False, ParameterSetName="foo")]
	$PROGRAM,
	[Parameter(Mandatory=$False, ParameterSetName="foo")]
	$DISPLAY_NAME,
	$DIRECTION = "Inbound",
	$ENABLE = $False,
	$DISABLE = $False,
	$REMOVE = $False,
	$DETAIL = $False
	)
	
$MAJOR = 1
$MINOR = 0

$MYPATH = (Get-Item -Path ".\").FullName
$MYRESULTS = Get-Date -Format o | foreach{$_ -replace ":","."}
$MYROOT = $MYPATH + "\" + $MYRESULTS
$MYLOG = $MYROOT + ".log"

if($LOGGING -eq $True)
{
	Start-Transcript -Path $MYLOG
}

Write-Host "Application Firewall Cmdlet Version $($MAJOR).$($MINOR)"

if($ADD -eq $True -and $PROGRAM -ne "foo" -and $DISPLAY_NAME -ne "foo")
{
	Write-Host "New-NetFirewallRule -Program $($PROGRAM) -Action Allow -DisplayName $($DISPLAY_NAME)"
	New-NetFirewallRule -Program $PROGRAM -Action Allow -DisplayName $DISPLAY_NAME -Direction $DIRECTION
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($ENABLE -eq $True -and $DISPLAY_NAME -ne "foo")
{
	Write-Host "Enable-NetFirewallRule -DisplayName $($DISPLAY_NAME)"
	Enable-NetFirewallRule -DisplayName $DISPLAY_NAME
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($DISABLE -eq $True -and $DISPLAY_NAME -ne "foo")
{
	Write-Host "Disable-NetFirewallRule -DisplayName $($DISPLAY_NAME)"
	Disable-NetFirewallRule -DisplayName $DISPLAY_NAME
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($DETAIL -eq $True -and $DISPLAY_NAME -ne "foo")
{
	Write-Host "Get-NetFirewallRule -DisplayName $($DISPLAY_NAME)"
	Get-NetFirewallRule -DisplayName $DISPLAY_NAME
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($REMOVE -eq $True -and $DISPLAY_NAME -ne "foo")
{
	Write-Host "Remove-NetFirewallRule -DisplayName $($DISPLAY_NAME)"
	Remove-NetFirewallRule -DisplayName $DISPLAY_NAME
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

$MYCOUNTER = 0
$MYMAXLENGTH = 0

if($LIST -eq $True)
{
	$MYRULES = Show-NetFirewallRule
	
	foreach($rule in $MYRULES)
	{
		if($rule -match "MSFT_NetFirewallRule")
		{
			if($rule.DisplayName.Length -gt $MYMAXLENGTH)
			{
				$MYMAXLENGTH = $rule.DisplayName.Length
			}
		}
	}
	
	foreach($rule in $MYRULES)
	{
		if($rule -match "MSFT_NetFirewallRule")
		{
			$MYSPACES = " " * ($MYMAXLENGTH - $rule.DisplayName.Length)
			
			Write-Host "[$($MYCOUNTER)] $($rule.DisplayName) $($MYSPACES) Enabled $($rule.Enabled)"
			
			$MYCOUNTER = $MYCOUNTER + 1
		}
	}
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($LOGGING -eq $True)
{
	Stop-Transcript
}





