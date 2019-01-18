# run logged into server as db2admin
 param  (
	[string]$dbname = $(throw "dbname parameter is required.") ,
	[string]$dbuser = $(throw "dbuser parameter is required.") ,
	[string]$dbauth = $(throw "dbauth parameter=password is required.") ,
	[string]$dbhostport = $(throw "dbhostport  parameter is required, format host:port. ")
	) 

write-output "The dbname is $dbname."
write-output "The dbname is $dbuser."
write-output "The dbauth is $dbauth."
write-output "The dbname is $dbhostport."

# added silently continue to rbind statement
# change logdir to relative directory 
#	undo - doesn't come back to parent dir
#	works with full path for LogDir.
# set instance but don't need to because of the port number
# set-item -path env:DB2INSTANCE -value "DCCINSTP"
# setting multiple parameters

$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}

set-item -path env:DB2CLP -value "**$$**"

#$LogDir worked here with the .\ notation, but was lost later
#    when referenced at the end.  PS needs fully qualified paths.
#    The . can be referenced later but needs to be set earlier
#$LogDir = ".\LOGDIR"
#$LogDir = "C:\Users\coreydi\Documents\aMy_Files\DB2_n_ADMIN_dev\automate_db2_install\TEST\LOGDIR"
$LogDir = "C:\temp"
#$startdir = get-item -path .
#$LogDir = "$startdir\LOGDIR"

$factory = [System.Data.Common.DbProviderFactories]::GetFactory("IBM.Data.DB2")
$cstrbld = $factory.CreateConnectionStringBuilder()
$cstrbld.Database = $dbname 
$cstrbld.UserID = $dbuser
$cstrbld.Password = $dbauth
$cstrbld.Server = $dbhostport
$dbconn = $factory.CreateConnection()
$dbconn.ConnectionString = $cstrbld.ConnectionString
$dbconn.Open()

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "select distinct pkgschema, pkgname, valid from syscat.packages where valid <> 'Y' with UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)
$ds.Tables[0] | Format-Table -AutoSize

cd $LogDir
# $command = { db2rbind $dbname -l $dbname_logfile.doc -u $dbuser -p $dbauth all -r any }
$logfile = $dbname + "_logfile.doc" 
$command = { db2rbind $dbname -l $logfile all -u $dbuser -p $dbauth -r any }
write-output $command
Invoke-Command -ScriptBlock $command -ErrorAction SilentlyContinue

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "select distinct pkgschema, pkgname, valid from syscat.packages where valid <> 'Y' with UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)
$ds.Tables[0] | Format-Table -AutoSize

cd $LogDir\..
