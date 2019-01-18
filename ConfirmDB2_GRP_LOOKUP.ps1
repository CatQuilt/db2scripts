# ConfirmDB2_GRP_LOOKUP.ps1
#
#

set-item -path env:DB2CLP -value "**$$**"
$command = { db2set -g DB2_GRP_LOOKUP }
#$response = Invoke-Command -ScriptBlock $command
Invoke-Command -ScriptBlock $command | Select-String -Pattern LOCAL,TOKENLOCAL
#Invoke-Command -ScriptBlock $command | Set-Content -Path D:\DB2_ADMIN\create_sample_db.txt

