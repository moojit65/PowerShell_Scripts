<#
.SYNOPSIS

"Performs windows updates on remote computer."

.DESCRIPTION

"Connects to multiple systems and schedules windows update."

.EXAMPLE
Enable remote powershell on local computer.
.\windows_update_systems.ps1 -ENABLE_WSMAN $True

.EXAMPLE
Retrieve update history from remote computer.
./windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -HISTORY $True

.EXAMPLE
Retrieve update history from two remote computers.
./windows_update_systems.ps1 -EXT_HOSTS "192.168.100.51,192.168.100.52" -USER Administrator -PASSWORD Password.1 -HISTORY $True

.EXAMPLE
Reboot remote computer.
.\windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -REBOOT $True

.EXAMPLE
Install PSWindowsUpdate module on remote computer.
.\windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -INSTALL $True

.EXAMPLE
Get results of last windows update performed on remote computer.
.\windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -RESULTS $True

.EXAMPLE
Get windows update status of remote computer.
.\windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -STATUS $True

.EXAMPLE
Update PSWindowsUpdate module on remote computer.
.\windows_update_systems.ps1 -EXT_HOSTS 192.168.100.51 -USER Administrator -PASSWORD Password.1 -WU_UPDATE $True
#>

param(
	$EXT_HOSTS = @(),
	$REBOOT = $False,
	$INSTALL = $False,
	$USER = "foo",
	$PASSWORD = "foo",
	$HISTORY = $False,
	$RESULTS = $False,
	$STATUS = $False,
	$WU_UPDATE = $False,
	$ENABLE_WSMAN = $False
	)
	

	
$MAJOR = 1
$MINOR = 0

Write-Host "Remote Windows Update Version $($MAJOR).$($MINOR)"

$pw = ConvertTo-SecureString -AsPlainText -Force -String $PASSWORD

$cred = New-Object -typename System.Management.Automation.PSCredential ($USER,$pw)

if ( $ENABLE_WSMAN -eq $True )
{
	Enable-PSRemoting -Confirm:$False
	Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force -ErrorAction Ignore
	Exit
}
		
if ( $EXT_HOSTS.Length -eq 0 )
{
	Exit
}
else
{
	foreach ($local in $EXT_HOSTS)
	{
		$mysession = New-PSSession -ComputerName $local -Credential $cred
		
		if( $REBOOT -eq $True )
		{
			try
			{
				Write-Host perform reboot on $local at (Get-Date)
				
				Start-Sleep -s 2

				Invoke-Command -Session $mysession -ScriptBlock { hostname }
				Invoke-Command -Session $mysession -ScriptBlock {Unregister-ScheduledTask -TaskName 'jamie' -Confirm:$False -ErrorAction Ignore}
				Invoke-Command -Session $mysession -ScriptBlock {$actions = (New-ScheduledTaskAction -Execute 'shutdown.exe'` -Argument '/r')}
				Invoke-Command -Session $mysession -ScriptBlock {$trigger = New-ScheduledTaskTrigger -Once -At (get-date).AddMinutes(2)}
				Invoke-Command -Session $mysession -ScriptBlock {$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest}
				Invoke-Command -Session $mysession -ScriptBlock {$task = New-ScheduledTask -Action $actions -Trigger $trigger -Principal $principal}
				Invoke-Command -Session $mysession -ScriptBlock {Register-ScheduledTask 'jamie' -InputObject $task}
				Invoke-Command -Session $mysession -ScriptBlock {Get-ScheduledTaskInfo -TaskName 'jamie'}
			}
			catch
			{
				Write-Host "An error occurred:"
				Write-Host $_
			}
		}
		elseif ( $INSTALL -eq $True )
		{
			Invoke-Command -Session $mysession -ScriptBlock { if (Get-InstalledModule -Name PSWindowsUpdate) { Write-Host "Package already installed on $($env:COMPUTERNAME)" } else { Install-PackageProvider -Name NuGet -MinimumVersion 2.2.1.5 -Force -Scope AllUsers -ErrorAction Ignore; Set-PSRepository -Name PSGallery -InstallationPolicy "Trusted"; Install-Module PSWindowsUpdate -Confirm:$false } }
		}
		elseif ( $HISTORY -eq $True )
		{
			Invoke-Command -Session $mysession -ScriptBlock { Get-WUHistory }
		}
		elseif ( $RESULTS -eq $True )
		{
			Invoke-Command -Session $mysession -ScriptBlock { Get-WULastResults }
		}
		elseif ( $STATUS -eq $True )
		{
			Invoke-Command -Session $mysession -ScriptBlock { Get-WUInstallerStatus }
		}
		elseif ( $WU_UPDATE -eq $True )
		{
			Invoke-Command -Session $mysession -ScriptBlock { Update-Module -Name PSWindowsUpdate -Verbose }
		}
		else
		{
			try
			{
				Write-Host scheduling windows update task on $local at (Get-Date)
				
				Start-Sleep -s 2

				Invoke-Command -Session $mysession -ScriptBlock { hostname }
				Invoke-Command -Session $mysession -ScriptBlock {Unregister-ScheduledTask -TaskName 'jamie' -Confirm:$False -ErrorAction Ignore}
				Invoke-Command -Session $mysession -ScriptBlock {$actions = (New-ScheduledTaskAction -Execute 'powershell.exe'` -Argument 'C:\jay\vbscripts\get_windows_update.ps1')}
				Invoke-Command -Session $mysession -ScriptBlock {$trigger = New-ScheduledTaskTrigger -Once -At (get-date).AddMinutes(2)}
				Invoke-Command -Session $mysession -ScriptBlock {$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest}
				Invoke-Command -Session $mysession -ScriptBlock {$task = New-ScheduledTask -Action $actions -Trigger $trigger -Principal $principal}
				Invoke-Command -Session $mysession -ScriptBlock {Register-ScheduledTask 'jamie' -InputObject $task}
				Invoke-Command -Session $mysession -ScriptBlock {Get-ScheduledTaskInfo -TaskName 'jamie'}
			}
			catch
			{
				Write-Host "An error occurred:"
				Write-Host $_
			}
		}
		
		Remove-PSSession -Session $mysession
		
	}
}


