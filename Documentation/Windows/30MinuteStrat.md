# Windows CCDC 30 Minute Strategy

## Please Read 
Before you do anything remember to use your 

## First 10 Minutes 
[x] Enumerate users, groups, and scored services
[x] Change passwords
[x] Create an additional account with creds that we only know. It’s perferable it is named in a way that looks like a system account.
[x] Backup Critical Services (IIS, Websites FTP, Databases)
[x] Configure firewall - Rules for RDP and the immportant services.
[x] Change passwords for any service accounts (e.g. mysql, filezilla)

## By Minute 20 (20 minutes in)  
[x] Kill all unknown sessions
[x] Configure NLA (Network Level Authentication) for RDP
[x] Disable SMB1.0 -> Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
[x] Check listening ports
[x] Remove unwanted software and services


## Final 10 Minutes (30 minute
[x] Check for Backdoors: Run AV, stickey keys, backdoors in services, Autoruns
[x] Setup ip blocking software
[x] Patch Windows and Critical service
[x] UAC, disable CMD & Powershell (if desired)
[x] Sysmon
[x] Configure service to be more secure
[x] Verify service functionality

Additional software:
rdguard
rohos
malwarebytes
sysinternals
EMET
Upgrade Powershell and WMF
