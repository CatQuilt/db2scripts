#----------------------------------------------------------------------------------------------------------
# pre-install steps
#
# 1. grant rights to db2admin
# 2. get rights for db2admin, to confirm that they are correct
# 3. confirm that db2admin is in DB2ADMNS
# 4. list all certicates, we need VeriSign G5
#----------------------------------------------------------------------------------------------------------

#
# grant rights
#
#Import-Module -Name UserRights

#Grant-UserRight "db2admin" -Right SeTcbPrivilege,SeIncreaseQuotaPrivilege,SeCreateTokenPrivilege,SeLockMemoryPrivilege,SeServiceLogonRight,SeAssignPrimaryTokenPrivilege -Computer $env:COMPUTERNAME

#
# get rights
#

#$UserRights = Get-UserRightsGrantedToAccount -Account "db2admin" -Computer $env:COMPUTERNAME

#$UserRights | Write-Host

#
# confirm that db2admin is in DB2ADMNS
#

<# Get-CimInstance win32_group -filter "name='DB2ADMNS'" |
Select Name,@{Name="Members";Expression={ 
 (Get-CimAssociatedInstance -InputObject $_ -ResultClassName Win32_UserAccount).Name -join ";" 
}} #>

#
# list all certificates
#

Get-ChildItem Cert:\LocalMachine -Recurse | Where-Object {$_.PSIsContainer -eq
$False} |
Select-Object PsPath, FriendlyName, Issuer, NotAfter,
NotBefore, SerialNumber, ThumbPrint,
DnsNameList, Subject, Version | 
Export-Csv c:\temp\list_certs.csv -NoTypeInformation