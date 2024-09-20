<#
.SYNOPSIS

"Performs CA Root Certificate add/delete/list."

.DESCRIPTION

"Adds and deletes custom CA root certificates.  Lists all CA Root Certificates."

.EXAMPLE
List All CA Root Certificates with logging enabled.
.\certificates.ps1 -LIST $True -LOGGING $True

.EXAMPLE
List All CA Root Certificates.
.\certificates.ps1 -LIST $True

.EXAMPLE
Add custom CA Root Certificate.
.\certificates.ps1 -ADD $True -FILE .\foo_bar.pem

.EXAMPLE
Delete custom CA Root Certificate.
.\certificates.ps1 -DELETE $True -CN SECURITY
#>

param(
	$LOGGING = $False,
	$LIST = $False,
	$DELETE = $False,
	$ADD = $False,
	$CN = "foo",
	$FILE = "foo"
	)
	
$MAJOR = 1
$MINOR = 0

$MYPATH = (Get-Item -Path ".\").FullName
$MYRESULTS = Get-Date -Format o | foreach{$_ -replace ":","."}
$MYROOT = $MYPATH + "\" + $MYRESULTS
$MYLOG = $MYROOT + ".log"

if($LOGGING -eq $True)
{
	Write-Host "LOGGING ENABLED $($MYLOG)"
	Start-Transcript -Path $MYLOG
}

Write-Host "CA Root Certificate ADD/DELETE/LIST Version $($MAJOR).$($MINOR)"

$CERTS = Get-Childitem cert:\LocalMachine\root

if($DELETE -eq $True)
{
	foreach( $cert in $CERTS )
	{
		if($cert.Subject -cmatch $CN)
		{
			Write-Host "FOUND! Cert:\LocalMachine\Root\$($cert.Thumbprint)"
			remove-item "Cert:\LocalMachine\Root\$($cert.Thumbprint)" -DeleteKey
		}
	}
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($ADD -eq $True)
{
	Write-Host "$($FILE)"
	Import-Certificate -FilePath "$($FILE)" -CertStoreLocation "Cert:\LocalMachine\Root"
	
	if($LOGGING -eq $True)
	{
		Stop-Transcript
	}
	
	Exit
}

if($LIST -eq $True)
{
	$MYCOUNT = 0
	
	foreach( $cert in $CERTS )
	{
		Write-Host "[$($MYCOUNT)] $($cert.Subject)"
		
		$MYCOUNT = $MYCOUNT + 1
	}
}

if($LOGGING -eq $True)
{
	Stop-Transcript
}





