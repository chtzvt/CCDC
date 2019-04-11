# Windows CCDC 30 Minute Strategy

## Please Read 
Before you do anything remember to use your head and assess the situation. Don't blindly follow any guide without understanding what you are doing first! 

## First 10 Minutes 
- [ ] Enumerate users, groups, and scored services
- [ ] Change passwords
- [ ] Create an additional account with creds that we only know. It’s perferable it is named in a way that looks like a system account.
- [ ] Backup Critical Services (IIS, Websites FTP, Databases)
- [ ] Configure firewall - Rules for RDP and the immportant services.
- [ ] Change passwords for any service accounts (e.g. mysql, filezilla)

## By Minute 20 (20 minutes in)  
- [ ] Kill all unknown sessions
- [ ] Configure NLA (Network Level Authentication) for RDP
- [ ] Disable SMB1.0 -> Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
- [ ] Check listening ports
- [ ] Remove unwanted software and services

## Final 10 Minutes (30 minute) 
- [ ] Check for Backdoors: Run AV, stickey keys, backdoors in services, Autoruns
- [ ] Setup IP blocking software
- [ ] Patch Windows and Critical service
- [ ] UAC, disable CMD & Powershell (if desired)
- [ ] Sysmon, enable logging
- [ ] Configure service to be more secure
- [ ] Verify service functionality

## Additional software:
- [ ] Rdpguard - Used for bruteforce protection (IIS, Exchange, MySQL, etc..)
- [ ] rohos
- [ ] Malwarebytes
- [ ] Sysinternals suite
- [ ] EMET (Enhanced Mitigation Experience Toolkit)
- [ ] Download + Upgrade WMF (Powershell) to version 5.0+
