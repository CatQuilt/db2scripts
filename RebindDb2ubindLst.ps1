# this is a test script that will be incorporated in RebindSystemPackages.ps1
#

param  (
	[string]$dbname = $(throw "dbname parameter is required.") ,
	[string]$instance = $(throw "instance parameter is required.") 
	) 
	
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'bind_db2ubindlst_output' + $timestamp.Substring(0,19) + '.txt'

Set-Location -Path "C:\Program Files\IBM\SQLLIB\bnd" -PassThru

$fileName = 'db2ubind.lst'

$Content = Get-Content -Path $fileName -raw

$arr = $Content -split '\n'

set-item -path env:DB2CLP -value "**$$**"

$command = { SET DB2INSTANCE=$instance  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 connect to $dbname  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

# the last element in the array is all spaces so it is ignored
# but loop thru all the others, remove the plus sign and attempt to do the bind

for ($i = 0; $i -le ($arr.length - 2); $i += 1) {

# execute the bind command for $BindFile

$BindFile = $arr[$i].Replace([char]0x002B,[char]0x0020)
$command = { db2 BIND $BindFile BLOCKING ALL GRANT PUBLIC ACTION REPLACE }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
write-host $BindFile
}