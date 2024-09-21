<#
.SYNOPSIS

"Performs EICAR malware testing."

.DESCRIPTION

"Downloads EICAR test files over non-TLS and TLS connections.  Also, test C&C host detection."

.EXAMPLE
Test TLS EICAR
.\eicar_test.ps1 -SSL $True

.EXAMPLE
Test non-TLS EICAR
.\eicar_test.ps1

.EXAMPLE
Disable logging
.\eicar_test.ps1 -LOGGING $False
#>

param(
	$SSL = $False,
	$LOGGING = $True
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

Write-Host "EICAR Malware and CC Host Tester Version $($MAJOR).$($MINOR)"

$time1 = Get-Date

if($SSL -eq $True)
{
	Write-Host "Testing Corrupted Archives EICAR, please wait ..."

	Write-Host "Corrupted ZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt.zip -OutFile ./corrupt.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt.zip -OutFile ./corrupt.zip

	Sleep 10

	Write-Host "Corrupted ZIP-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_zip_in_zip.zip -OutFile ./corrupt_zip_in_zip.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_zip_in_zip.zip -OutFile ./corrupt_zip_in_zip.zip

	Sleep 10

	Write-Host "Corrupted GZIP-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_gzip_in_zip.zip -OutFile ./corrupt_gzip_in_zip.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_gzip_in_zip.zip -OutFile ./corrupt_gzip_in_zip.zip

	Sleep 10

	Write-Host "Corrupted TAR-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_tar_in_zip.zip -OutFile ./corrupt_tar_in_zip.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_tar_in_zip.zip -OutFile ./corrupt_tar_in_zip.zip

	Sleep 10

	Write-Host "Testing Common Archives EICAR, please wait ..."

	Write-Host "ZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar.zip -OutFile ./eicar.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar.zip -OutFile ./eicar.zip

	Sleep 10

	Write-Host "ZIP-Archive (Password protected)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar_password.zip -OutFile ./eicar_password.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar_password.zip -OutFile ./eicar_password.zip

	Sleep 10

	Write-Host "ZIP-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar.exe -OutFile ./eicar_1.exe"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar.exe -OutFile ./eicar_1.exe

	Sleep 10

	Write-Host "GZIP-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/gz/eicar.gz -OutFile ./eicar.gz"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/gz/eicar.gz -OutFile ./eicar.gz

	Sleep 10

	Write-Host "RAR-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar.rar -OutFile ./eicar.rar"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar.rar -OutFile ./eicar.rar

	Sleep 10

	Write-Host "RAR-Archive (Password protected)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar_password.rar -OutFile ./eicar_password.rar"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar_password.rar -OutFile ./eicar_password.rar

	Sleep 10

	Write-Host "RAR-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar.exe -OutFile ./eicar_2.exe"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/rar/eicar.exe -OutFile ./eicar_2.exe

	Sleep 10

	Write-Host "Cabinet-Archive"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/cab/eicar.cab -OutFile ./eicar.cab"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/cab/eicar.cab -OutFile ./eicar.cab

	Sleep 10

	Write-Host "Cabinet-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/cab/eicar.exe -OutFile ./eicar_3.exe"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/cab/eicar.exe -OutFile ./eicar_3.exe

	Write-Host "Testing More Archives EICAR, please wait ..."

	Write-Host "ZIP-Archive (nested archive 2x)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar2.zip -OutFile ./eicar2.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar2.zip -OutFile ./eicar2.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 5x)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar10.zip -OutFile ./eicar10.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar10.zip -OutFile ./eicar10.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 20x)"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar20.zip -OutFile ./eicar20.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar20.zip -OutFile ./eicar20.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 25x)"
	Write-Host "https://www.csm-testcenter.org/csm-download/archives/zip/eicar25.zip -OutFile ./eicar25.zip"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-download/archives/zip/eicar25.zip -OutFile ./eicar25.zip

	Sleep 10

	Write-Host "Testing Content Types EICAR, please wait ..."

	Write-Host "The plain EICAR.COM file can be used to test your configuration. It should definitly be detected by every virus scanner."
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com -OutFile ./csm-eicar.com"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com -OutFile ./csm-eicar.com

	Sleep 10

	Write-Host "The same file as plain text file may be bypassed by some scanners. Most browsers will display the file as text and won't execute it; still users would be able to save the file as eicar.com"
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.txt -OutFile ./csm-eicar.txt"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.txt -OutFile ./csm-eicar.txt

	Sleep 10

	Write-Host "The EICAR test file coming as GIF image although it is not a GIF; depending on your browser this may be shown as a broken image or as text."
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.gif -OutFile ./csm-eicar.gif"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.gif -OutFile ./csm-eicar.gif

	Sleep 10

	Write-Host "The file with Content-Disposition header has not the .com file name extension but a Content-Diposition header that tells the browser with which name to save the file on disk."
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar?dispo=eicar.com -OutFile ./eicar_1.com"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar?dispo=eicar.com -OutFile ./eicar_1.com

	Sleep 10

	Write-Host "Testing Content Encodings EICAR, please wait ..."

	Write-Host "The EICAR.com file with gzip content encoding. If your browser does not advertise support of this content encoding, you will see a notification where you can decide to try this encoding anyway in order to test your scanner."
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com?content=gzipped"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com?content=gzipped

	Sleep 10

	Write-Host "Testing Transfer Encodings EICAR, please wait ..."

	Write-Host "The EICAR.com file with chunked transfer encoding. This encoding must be supported by all HTTP version 1.1 agents. If the request is of HTTP version 1.0, you will see a notification where you can decide to try this encoding anyway in order to test your scanner. Data transferred in chunked encoding will be sent in three chunks."
	Write-Host "Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com?transfer=chunked"
	Invoke-WebRequest https://www.csm-testcenter.org/csm-eicar.com?transfer=chunked

	Sleep 10
}
else
{
	Write-Host "Testing Corrupted Archives EICAR, please wait ..."

	Write-Host "Corrupted ZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt.zip -OutFile ./corrupt.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt.zip -OutFile ./corrupt.zip

	Sleep 10

	Write-Host "Corrupted ZIP-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_zip_in_zip.zip -OutFile ./corrupt_zip_in_zip.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_zip_in_zip.zip -OutFile ./corrupt_zip_in_zip.zip

	Sleep 10

	Write-Host "Corrupted GZIP-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_gzip_in_zip.zip -OutFile ./corrupt_gzip_in_zip.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_gzip_in_zip.zip -OutFile ./corrupt_gzip_in_zip.zip

	Sleep 10

	Write-Host "Corrupted TAR-Archive nested in a ZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_tar_in_zip.zip -OutFile ./corrupt_tar_in_zip.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/corrupted/corrupt_tar_in_zip.zip -OutFile ./corrupt_tar_in_zip.zip

	Sleep 10

	Write-Host "Testing Common Archives EICAR, please wait ..."

	Write-Host "ZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar.zip -OutFile ./eicar.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar.zip -OutFile ./eicar.zip

	Sleep 10

	Write-Host "ZIP-Archive (Password protected)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar_password.zip -OutFile ./eicar_password.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar_password.zip -OutFile ./eicar_password.zip

	Sleep 10

	Write-Host "ZIP-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar.exe -OutFile ./eicar_1.exe"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar.exe -OutFile ./eicar_1.exe

	Sleep 10

	Write-Host "GZIP-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/gz/eicar.gz -OutFile ./eicar.gz"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/gz/eicar.gz -OutFile ./eicar.gz

	Sleep 10

	Write-Host "RAR-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar.rar -OutFile ./eicar.rar"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar.rar -OutFile ./eicar.rar

	Sleep 10

	Write-Host "RAR-Archive (Password protected)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar_password.rar -OutFile ./eicar_password.rar"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar_password.rar -OutFile ./eicar_password.rar

	Sleep 10

	Write-Host "RAR-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar.exe -OutFile ./eicar_2.exe"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/rar/eicar.exe -OutFile ./eicar_2.exe

	Sleep 10

	Write-Host "Cabinet-Archive"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/cab/eicar.cab -OutFile ./eicar.cab"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/cab/eicar.cab -OutFile ./eicar.cab

	Sleep 10

	Write-Host "Cabinet-Archive (Self-Extracted)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/cab/eicar.exe -OutFile ./eicar_3.exe"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/cab/eicar.exe -OutFile ./eicar_3.exe

	Write-Host "Testing More Archives EICAR, please wait ..."

	Write-Host "ZIP-Archive (nested archive 2x)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar2.zip -OutFile ./eicar2.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar2.zip -OutFile ./eicar2.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 5x)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar10.zip -OutFile ./eicar10.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar10.zip -OutFile ./eicar10.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 20x)"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar20.zip -OutFile ./eicar20.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar20.zip -OutFile ./eicar20.zip

	Sleep 10

	Write-Host "ZIP-Archive (nested archive 25x)"
	Write-Host "http://www.csm-testcenter.org/csm-download/archives/zip/eicar25.zip -OutFile ./eicar25.zip"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-download/archives/zip/eicar25.zip -OutFile ./eicar25.zip

	Sleep 10

	Write-Host "Testing Content Types EICAR, please wait ..."

	Write-Host "The plain EICAR.COM file can be used to test your configuration. It should definitly be detected by every virus scanner."
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com -OutFile ./csm-eicar.com"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com -OutFile ./csm-eicar.com

	Sleep 10

	Write-Host "The same file as plain text file may be bypassed by some scanners. Most browsers will display the file as text and won't execute it; still users would be able to save the file as eicar.com"
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.txt -OutFile ./csm-eicar.txt"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.txt -OutFile ./csm-eicar.txt

	Sleep 10

	Write-Host "The EICAR test file coming as GIF image although it is not a GIF; depending on your browser this may be shown as a broken image or as text."
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.gif -OutFile ./csm-eicar.gif"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.gif -OutFile ./csm-eicar.gif

	Sleep 10

	Write-Host "The file with Content-Disposition header has not the .com file name extension but a Content-Diposition header that tells the browser with which name to save the file on disk."
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar?dispo=eicar.com -OutFile ./eicar_1.com"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar?dispo=eicar.com -OutFile ./eicar_1.com

	Sleep 10

	Write-Host "Testing Content Encodings EICAR, please wait ..."

	Write-Host "The EICAR.com file with gzip content encoding. If your browser does not advertise support of this content encoding, you will see a notification where you can decide to try this encoding anyway in order to test your scanner."
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com?content=gzipped"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com?content=gzipped

	Sleep 10

	Write-Host "Testing Transfer Encodings EICAR, please wait ..."

	Write-Host "The EICAR.com file with chunked transfer encoding. This encoding must be supported by all HTTP version 1.1 agents. If the request is of HTTP version 1.0, you will see a notification where you can decide to try this encoding anyway in order to test your scanner. Data transferred in chunked encoding will be sent in three chunks."
	Write-Host "Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com?transfer=chunked"
	Invoke-WebRequest http://www.csm-testcenter.org/csm-eicar.com?transfer=chunked

	Sleep 10
}

Write-Host "Testing CC and Infected Hosts, please wait ..."

$BADIPS = @("8.8.8.8","45.148.10.251","205.210.31.197","206.168.34.118","139.59.37.187","152.32.235.85","154.212.141.143","170.64.154.131")

foreach ($ip in $BADIPS)
{
	Write-Host "TESTING CONNECTIVITY $($ip) --> "
	Test-Connection $ip

	Sleep 10
}

$time2 = Get-Date

Write-Host "Log collection completed in"$($time2-$time1).TotalSeconds"seconds"

if($LOGGING -eq $True)
{
	Stop-Transcript
}