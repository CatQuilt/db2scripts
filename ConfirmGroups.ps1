# Confirm that db2admin is in the DB2ADMNS group
# written 08/17/2018
#--------------------------------------------------------------
# needs to output the results?


Get-CimInstance win32_group -filter "name='DB2ADMNS'" |
Select Name,@{Name="Members";Expression={ 
 (Get-CimAssociatedInstance -InputObject $_ -ResultClassName Win32_UserAccount).Name -join ";" 
}}


