## Powershell Command to change every users password
Powershell -Command "&{Get-Wmiobject -class -win32_useraccount | foreach-object { net user $_.Name Password }}"

