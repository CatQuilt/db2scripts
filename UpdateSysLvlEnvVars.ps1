# UpdateSysLvlEnvVars
# 

# get the current date/time
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'

# append the date and time to the filename
$output = $LogDir + 'db2set_output_' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $output

# issue the command
set-item -path env:DB2CLP -value "**$$**"
$command = { db2set -g DB2CODEPAGE=1208 }
Invoke-Command -ScriptBlock $command | Add-Content -Path $output

$command = { db2set -g DB2_GRP_LOOKUP=LOCAL,TOKENLOCAL }
Invoke-Command -ScriptBlock $command | Add-Content -Path $output

# issue the command
#set-item -path env:DB2CLP -value "**$$**"
$command = { db2set -all }
Invoke-Command -ScriptBlock $command | Add-Content -Path $output
