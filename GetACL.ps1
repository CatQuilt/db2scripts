# GetACL.ps1
# gets the ACL of the DB2 directories on a server
# and the ACLs of all files
# written by LFlatley 8/23/2018
# source: https://gallery.technet.microsoft.com/scriptcenter/Getting-Usable-ACLs-for-a-df292dac
#
# not ready for use yet in DB2DEV install
#

<#$Path = "C:\DB2_DATABASE" 
$Directory = Get-Acl -Path $Path 
ForEach ($Dir in $Directory.Access){ 
[PSCustomObject]@{ 
Path = $Path 
Owner = $Directory.Owner 
Group = $Dir.IdentityReference 
AccessType = $Dir.AccessControlType 
Rights = $Dir.FileSystemRights 
} #EndPSCustomObject 
} #EndForEach 
#>
Out-
$Path = "C:\DB2_DATABASE" 
Get-ChildItem -Path $Path -Recurse | Where-Object {($_.PsIsContainer)} | Get-Acl  
ForEach ($Dir in $Directory.Access){ 
[PSCustomObject]@{ 
Path = $Path 
Owner = $Directory.Owner 
Group = $Dir.IdentityReference 
AccessType = $Dir.AccessControlType 
Rights = $Dir.FileSystemRights 
}  | Format-Table -AutoSize -HideTableHeaders | Set-Content C:\DB2_ADMIN\acl_dirs_wip.txt
}

#Get-ChildItem -Path "C:\DB2_DATABASE" -Recurse | Where-Object {($_.PsIsContainer)} | Get-ACL | Format-List | Out-File C:\DB2_ADMIN\DB2_INSTALL\acl_dirs_only.txt

#Get-ChildItem -Path "C:\DB2_DATABASE" -Recurse | Get-ACL | Format-List | Out-File C:\DB2_ADMIN\DB2_INSTALL\acl_all_files.txt