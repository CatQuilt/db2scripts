#
#
#

$timestamp = Get-Date -Format o | foreach {$_ -replace 'T', '_'} | foreach {$_ -replace ':', '-'}
$LogDir = 'd:\'
$LogFile = $LogDir + 'temp\list_users_output' + $timestamp.Substring(0,19) + '.txt'

# initialize the log file with today's date
Get-Date | Set-Content  -Path $LogFile 

$Server   = $Env:ComputerName

$computer = [ADSI]"WinNT://$Server,computer"

$stuff = $Server | Add-Content -Path $LogFile

$computer.psbase.children | where { $_.psbase.schemaClassName -eq 'group' } | foreach {
    $stuff = $_.name | Add-Content -Path $LogFile 
    $stuff = "------" | Add-Content -Path $LogFile 
    $group =[ADSI]$_.psbase.Path
    $group.psbase.Invoke("Members") | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) | Add-Content -Path $LogFile }
     #write-host
}

# Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | select name, fullname
# Get-LocalUser