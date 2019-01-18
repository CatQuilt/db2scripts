# RebindApplicationPackages.ps1
# pass the instance and dbname to the script
#

param  (
	[string]$dbname = $(throw "dbname parameter is required.") ,
	[string]$instance = $(throw "instance parameter is required.") ,
    [string]$dbauth = $(throw "dbauth parameter is required.") 
	) 
	
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'c:\temp\'
$LogFile = $LogDir + 'rebind_application_packages_output' + $timestamp.Substring(0,19) + '.txt'
$Rbindlog = $LogDir + $dbname + '_rbindlog' + $timestamp.Substring(0,19) + '.doc'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

write-output "The dbname is $dbname."
write-output "The instance is $instance."

set-item -path env:DB2CLP -value "**$$**"

$command = { SET DB2INSTANCE=$instance  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2rbind $dbname -l $Rbindlog -u db2admin -p $dbauth all  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 terminate  }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 
