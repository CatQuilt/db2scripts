# 
# Compare the before and after sqllibs
#

$ACLone = get-childitem "C:\Program Files\IBM\SQLLIB"  -Recurse | where-object {($_.PsIsContainer)} 
$ACLtwo = get-childitem "C:\zDB2_ADMIN_INSTALLS\DB2_9.7.8\SQLLIB_B4"  -Recurse | where-object {($_.PsIsContainer)} 

Write-Host "------------- Compare 1 and 2 ----------------------"

Compare-Object -referenceobject $ACLone -differenceobject $ACLtwo -IncludeEqual | Format-Table -AutoSize | Out-File C:\DB2_ADMIN\DB2_INSTALL\sqllib_compare.txt