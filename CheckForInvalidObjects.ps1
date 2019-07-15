# check sql for invalid objects
#
#

set-item -path env:DB2CLP -value "**$$**"

$factory = [System.Data.Common.DbProviderFactories]::GetFactory("IBM.Data.DB2")
$cstrbld = $factory.CreateConnectionStringBuilder()
$cstrbld.Database = "staging"
$cstrbld.UserID = "tfmsowner"
$cstrbld.Password = "????????"
$cstrbld.Server = "localhost:50000"
$dbconn = $factory.CreateConnection()
$dbconn.ConnectionString = $cstrbld.ConnectionString
$dbconn.Open()

$dbcmd = $factory.CreateCommand()
$dbcmd.Connection = $dbconn
$dbcmd.CommandText = "select objectschema, objectname, objecttype, routinename, last_regen_time from syscat.invalidobjects WITH UR"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)
$ds.Tables[0] | Format-Table -AutoSize

$dbcmd.CommandText = "call sysproc.admin_revalidate_db_objects(null, null, null)"
$dbcmd.CommandType = [System.Data.CommandType]::Text
$da = $factory.CreateDataAdapter()
$da.SelectCommand = $dbcmd
$ds = New-Object System.Data.DataSet
$da.Fill($ds)
$ds.Tables[0] | Format-Table -AutoSize

$dbconn.Close()
#$ds.Tables[0] | export-csv c:\sql\ps_test_data.csv

