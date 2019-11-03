# Windows CCDC 30 Minute Strategy

## Please Read 
Before you do anything remember to use your head and assess the situation. Don't blindly follow any guide without understanding what you are doing first! 

## First 10 Minutes 
- [ ] Enumerate users, groups, and scored services
  - net user
  - net localgroup
- [ ] Change passwords
- net user _username_ *
- [ ] Create an additional account with creds that we only know. It’s perferable it is named in a way that looks like a system account.
- [ ] Backup Critical Services (IIS, Websites FTP, Databases)
- Copy to new directory
- [ ] Configure firewall - Rules for RDP and the immportant services.
- MMC - Windows Firewall Snap-in
- export existing policy
- Turn Firewall off
- Delete all Firewall Rules
- Command Prompt:
- netsh advfirewall firewall delete rule name=all
- Configure default rules to Block incoming AND outgoing connections
- Create the necessary Inbound rules
- Create the necessary Outbound rules
- Turn Firewall ON
- [ ] Change passwords for any service accounts (e.g. mysql, filezilla)
- [ ] Check for sticky keys backdoor

## By Minute 20 (20 minutes in)  
- [ ] Kill all unknown sessions
- netstat -ano | findstr /I "established"
- taskkill /PID <pid>
- [ ] Configure NLA (Network Level Authentication) for RDP
- [ ] Disable SMB1.0 -> Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
- net stop server
- [ ] Check listening ports
- netstat -ano | findstr /I "listening"
- [ ] Disable LLMNR
- Win + R > gpedit.msc
- Local Computer Policy > Computer Configuration > Administrative Templates > Network > DNS Client
- "Turn OFF Multicast Name Resolution" _Enable_
- [ ] Remove unwanted software and services

## Final 10 Minutes (30 minute) 
- [ ] Check for Backdoors: Run AV, stickey keys, backdoors in services, Autoruns
- [ ] Setup IP blocking software
- [ ] Patch Windows and Critical service
- [ ] Enable UAC
- [ ] Disable CMD & Powershell (if desired)
- Win + R > gpedit.msc
- User > Configuration/Administrative > Templates/System
- “Prevent access to the command prompt“
- [ ] Install Sysmon & enable logging
- [ ] Configure service to be more secure
- [ ] Verify service functionality

## Additional software:
- [ ] Rdpguard - Used for bruteforce protection (IIS, Exchange, MySQL, etc..)
- [ ] Chocolatey
- [ ] Wazuh
- [ ] Wireshark
- [ ] Malwarebytes
- [ ] Sysinternals Suite
- [ ] OSSEC
- [ ] EMET (Enhanced Mitigation Experience Toolkit)
- [ ] Download + Upgrade WMF (Powershell) to version 5.0+
- [ ] Rohos
