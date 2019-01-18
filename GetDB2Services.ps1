# get a list of all the DB2 services
# export to a csv
#

# set the diag output file name
$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'c:\temp\'
$ListOutput = $LogDir + 'list_db2_services_output_' + $timestamp.Substring(0,19) + '.txt'

Get-Service "db2*" | Export-Csv $ListOutput