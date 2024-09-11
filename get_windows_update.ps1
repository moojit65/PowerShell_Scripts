<#
.SYNOPSIS

"Performs windows updates on local computer."

.DESCRIPTION

"Cmdlet that performs windows updates."

.EXAMPLE
Perform windows update.
.\get_windows_update.ps1
#>

param(
	[string]$ProxyServer = "foo",
	$ProxyServerEnable = $False
	)
	
$MAJOR = 1
$MINOR = 0

Write-Host "Windows Update Version $($MAJOR).$($MINOR)"

Write-Host $MyInvocation.MyCommand.Name "-ProxyServer" $ProxyServer "-ProxyServerEnable" $ProxyServerEnable

if( $ProxyServerEnable -eq $True )
{
	if( $ProxyServer -ne "foo" )
	{
		#ENABLE AND SETUP IE PROXY
		set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name "ProxyEnable" -Value 1
		set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name "ProxyServer" -Value $ProxyServer
		set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name "ProxyOverride" -Value "<local>"

		#SET SYSTEM HTTP PROXY
		netsh winhttp set proxy proxy-server="$($ProxyServer)" bypass-list="<local>"
	}
}

if( $PSVersionTable.PSVersion.Major -lt 5 )
{
	Write-Host "Exiting, please need to update to powershell version 5.1 or greater ..."
	Exit
}
	
#INSTALL WINDOWS-UPDATE FEATURE SET
Write-Host "Getting latest windows updates ..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (Get-InstalledModule -Name PSWindowsUpdate)
{
}
else
{
	Install-PackageProvider -Name NuGet -MinimumVersion 2.2.1.5 -Force -Scope AllUsers -ErrorAction Ignore
	Set-PSRepository -Name PSGallery -InstallationPolicy "Trusted"
	Install-Module PSWindowsUpdate -Confirm:$false
}


Get-WindowsUpdate -Verbose -WindowsUpdate -UpdateType Software
Install-WindowsUpdate -Verbose -WindowsUpdate -UpdateType Software -IgnoreReboot -Confirm:$False 
