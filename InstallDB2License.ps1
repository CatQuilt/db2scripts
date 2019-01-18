# InstallDB2License.ps1
# pass the license path
#

param  (
	[string]$licpath = $(throw "license path parameter is required.") 
	) 
	
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'install_license_output' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

write-output "The license path is $licpath."

set-item -path env:DB2CLP -value "**$$**"

$command = { db2licm -l }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2licm -a $licpath }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2licm -l }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
