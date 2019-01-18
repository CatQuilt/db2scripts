# RunDB2Sample
#
#


$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'create_sample_db_output' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

set-item -path env:DB2CLP -value "**$$**"

$command = { db2sampl -xml }

Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile

# add other steps to validate the data

