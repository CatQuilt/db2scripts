# ValidateSampleDB.ps1
# pass the dbname, user, password and port to the script
#

param  (
	[string]$dbname = $(throw "dbname parameter is required.") ,
	[string]$dbuser = $(throw "dbuser parameter is required.") ,
	[string]$dbauth = $(throw "dbauth parameter=password is required.") ,
	[string]$dbport = $(throw "dbport  parameter is required.")
	) 
	

$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'validate_sample_db_output' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

write-output "The dbname is $dbname."
write-output "The dbuser is $dbuser."
write-output "The dbauth is $dbauth."
write-output "The dbport is $dbport."

$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\temp\'
$LogFile = $LogDir + 'validateSample_output' + $timestamp.Substring(0,19) + '.txt'

set-item -path env:DB2CLP -value "**$$**"

$factory = [System.Data.Common.DbProviderFactories]::GetFactory("IBM.Data.DB2")
$cstrbld = $factory.CreateConnectionStringBuilder()
$cstrbld.Database = $dbname
$cstrbld.UserID = $dbuser
$cstrbld.Password = $dbauth
$cstrbld.Server = "localhost:" + $dbport

$dbconn = $factory.CreateConnection()
$dbconn.ConnectionString = $cstrbld.ConnectionString
$dbconn.Open()

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "select tabschema, tabname, card from syscat.tables where not tabschema like 'SYS%' WITH UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)

#$dbconn.Close()

$export = $LogDir + 'sample_db_tables' + $timestamp.Substring(0,19) + '.csv'
$ds.Tables[0] | export-csv $export 

<#  we do not need to open another connection?

$factory = [System.Data.Common.DbProviderFactories]::GetFactory("IBM.Data.DB2")
$cstrbld = $factory.CreateConnectionStringBuilder()
$cstrbld.Database = $dbname
$cstrbld.UserID = $dbuser
$cstrbld.Password = $dbauth
$cstrbld.Server = "localhost:" + $dbport

$dbconn = $factory.CreateConnection()
$dbconn.ConnectionString = $cstrbld.ConnectionString
$dbconn.Open() #>

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "SELECT SID, ADDR FROM DB2ADMIN.SUPPLIERS WITH UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)

# new command - does it help close the connection?
$dbcmd.Dispose()
$dbconn.Close()

$export = $LogDir + 'sample_supplier_table_data' + $timestamp.Substring(0,19) + '.csv'
$ds.Tables[0] | export-csv $export 

$command = { db2 list applications }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 terminate }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 list applications }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile 

$command = { db2 drop db sample }
Invoke-Command -ScriptBlock $command | Add-Content -Path $LogFile