# run logged into server as db2admin

set-item -path env:DB2CLP -value "**$$**"
$LogDir = C:\DB2_ADMIN\

$factory = [System.Data.Common.DbProviderFactories]::GetFactory("IBM.Data.DB2")
$cstrbld = $factory.CreateConnectionStringBuilder()
$cstrbld.Database = "staging"
$cstrbld.UserID = "db2admin"
$cstrbld.Password = "LANlan123"
$cstrbld.Server = "localhost:50000"
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
$command = { db2rbind staging -l staging_logfile.doc all -r any }
Invoke-Command -ScriptBlock $command

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "select distinct pkgschema, pkgname, valid from syscat.packages where valid <> 'Y' with UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)
$ds.Tables[0] | Format-Table -AutoSize
