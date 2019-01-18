# UpdateDbmCfg
#

$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\'
$LogFile = $LogDir + 'temp\dbmcfg_output' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

set-item -path env:DB2CLP -value "**$$**"
$command = { db2 update dbm cfg using SVCENAME 50010 } 
$stuff = $Command | Add-Content -Path $LogFile
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile

$command = { db2 update dbm cfg using SYSADM_GROUP DB2ADMNS } 
$stuff = $Command | Add-Content -Path $LogFile
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile
