# UpdateDb_Cfg
#
# for STAGING and CONSOL only

#$command = { Get-EventLog -log "Windows PowerShell" | where {$_.Message -like "*certificate*"} }

# initialize the log file with today's date
Get-Date | Set-Content  -Path d:\temp\dbcfg_output.txt

set-item -path env:DB2CLP -value "**$$**"
$command = { db2 update db cfg using LOCKLIST 5000 }
Invoke-Command -ScriptBlock $command | Add-Content -Path d:\temp\dbcfg_output.txt

$command = { db2 update db cfg using MAXLOCKS 90 }
Invoke-Command -ScriptBlock $command | Add-Content -Path d:\temp\dbcfg_output.txt
