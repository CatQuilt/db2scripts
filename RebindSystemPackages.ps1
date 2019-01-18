# RebindSystemPackages.ps1
# pass the instance, dbname, and federated_switch to the script
#

param  (
	[string]$dbname = $(throw "dbname parameter is required.") ,
	[string]$instance = $(throw "instance parameter is required.") ,
	[string]$fed = $(throw "fed parameter is required. Value should be Y or N")
	) 
	
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'rebind_system_output' + $timestamp.Substring(0,19) + '.txt'

# PS has issues with the @ so hopefully a variable will work
# no - the variables did not work
#$db2ubindlst = '@db2ubind.lst'
#$db2clilst = '@db2cli.lst'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

write-output "The dbname is $dbname."
write-output "The instance is $instance."
write-output "The fed is $fed."

Set-Location -Path "C:\Program Files\IBM\SQLLIB\bnd" -PassThru

set-item -path env:DB2CLP -value "**$$**"

$command = { db2 terminate  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { SET DB2INSTANCE=$instance  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 connect to $dbname  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 BIND db2schema.bnd BLOCKING ALL GRANT PUBLIC SQLERROR CONTINUE }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

#------------------------------------------------------------------------
$fileName = 'db2ubind.lst'

$Content = Get-Content -Path $fileName -raw

$arr = $Content -split '\n'
# the last element in the array is all spaces so it is ignored
# but loop thru all the others, remove the plus sign and attempt to do the bind

for ($i = 0; $i -le ($arr.length - 2); $i += 1) {

# execute the bind command for $BindFile

$BindFile = $arr[$i].Replace([char]0x002B,[char]0x0020)
$command = { db2 BIND $BindFile BLOCKING ALL GRANT PUBLIC ACTION REPLACE }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
write-host $BindFile
}
#------------------------------------------------------------------------------

#$command = { db2 BIND @db2ubind.lst BLOCKING ALL GRANT PUBLIC ACTION ADD }
#Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 


#------------------------------------------------------------------------
$fileName = 'db2cli.lst'

$Content = Get-Content -Path $fileName -raw

$arr = $Content -split '\n'
# the last element in the array is all spaces so it is ignored
# but loop thru all the others, remove the plus sign and attempt to do the bind

for ($i = 0; $i -le ($arr.length - 2); $i += 1) {

# execute the bind command for $BindFile

$BindFile = $arr[$i].Replace([char]0x002B,[char]0x0020)
$command = { db2 BIND $BindFile BLOCKING ALL GRANT PUBLIC ACTION REPLACE }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
write-host $BindFile
}
#------------------------------------------------------------------------------

#$command = { db2 BIND @db2cli.lst BLOCKING ALL GRANT PUBLIC ACTION ADD }
#Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

if ($fed = 'Y') {
$command = { db2 BIND db2dsproc.bnd BLOCKING ALL GRANT PUBLIC }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
$command = { db2 BIND db2stats.bnd BLOCKING ALL GRANT PUBLIC }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile  
write-output "did federated binds"
}

$command = { db2 terminate  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
