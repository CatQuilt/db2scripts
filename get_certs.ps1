
Get-ChildItem Cert:\LocalMachine -Recurse | Where-Object {$_.PSIsContainer -eq
$False} |
Select-Object PsPath, FriendlyName, Issuer, NotAfter,
NotBefore, SerialNumber, ThumbPrint,
DnsNameList, Subject, Version | 
Export-Csv c:\temp\list_certs.csv -NoTypeInformation