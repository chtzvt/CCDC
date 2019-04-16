## Powershell Command to change every users password
Powershell -Command "&{Get-Wmiobject -class -win32_useraccount | foreach-object { net user $_.Name Password }}"

### Security Scripts 
reg add "HKEY_Local_Machine\Software\policies\Microsoft\Windows\system" /v EnableSmartScreen /t REG_DWORD /d 2 /f
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v SMB1 /t REG_DWORD /d 0 /f 

### Other Security stuff need to check out more
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v SMB1 /t REG_DWORD /d 0 /f 
reg ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters /v EnableSecuritySignature /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters /v RequireSecuritySignature /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa /v DisableRestrictedAdmin /t REG_DWORD /d 0 /f


## Firewall commands
netsh advfirewall export $env:userprofile\desktop\originalpolicy.wfw
netsh advfirewall set allprofiles state off
netsh advfirewall firewall delete rule name=all
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
netsh firewall set service type = REMOTEDESKTOP mode = ENABLE
netsh advfirewall set allprofiles state on



## Random AD commands
set-adaccountpassword -reset -newpassword (convertto-securestring -string Password123! -asplaintext -force) -identity Administrator
Disable-ADAccount -Identity Administrator
set-aduser -identity poweruser -cannotchangepassword $true
New-ADUser -SamAccountName team7 -AccountPassword (ConvertTo-SecureString Password123! -AsPlainText -force) -Name team7 -Enabled $TRUE
Add-ADGroupMember -Identity 'Enterprise Admins' -Member team7

## Download tools
Invoke-WebRequest -usebasicparsing -URI http://download.sysinternals.com/files/ProcessExplorer.zip -OutFile $env:userprofile\downloads\ProcessExplorer.zip
Expand-Archive -LiteralPath $env:userprofile\Downloads\ProcessExplorer.zip -DestinationPath $env:userprofile\Downloads\ProcessExplorer\ -Force

Invoke-WebRequest -usebasicparsing -URI http://download.sysinternals.com/files/Sysmon.zip -OutFile $env:userprofile\downloads\Sysmon.zip
Expand-Archive -LiteralPath $env:userprofile\Downloads\Sysmon.zip -DestinationPath $env:userprofile\Downloads\Sysmon\ -Force

Invoke-WebRequest -usebasicparsing -URI http://download.sysinternals.com/files/Autoruns.zip -OutFile $env:userprofile\downloads\Autoruns.zip
Expand-Archive -LiteralPath $env:userprofile\Downloads\Autoruns.zip -DestinationPath $env:userprofile\Downloads\Autoruns\ -Force

Invoke-WebRequest -usebasicparsing -URI http://raw.githubusercontent.com/MotiBa/Sysmon/master/config_v17.xml -Outfile $env:userprofile\downloads\Sysmon\sysmonconfig.xml

#### Need to find url of patch
Invoke-WebRequest -usebasicparsing -URI http://microsoft.com/patches -Outfile $env:userprofile\downloads\ms1710patch.exe

