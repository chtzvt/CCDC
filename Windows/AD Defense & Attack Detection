## Defense & Detection
### Tools & Scripts
* [SAMRi10](https://gallery.technet.microsoft.com/SAMRi10-Hardening-Remote-48d94b5b)  - Hardening SAM Remote Access in Windows 10/Server 2016
* [Net Cease](https://gallery.technet.microsoft.com/Net-Cease-Blocking-Net-1e8dcb5b)  - Hardening Net Session Enumeration
* [PingCastle](https://www.pingcastle.com/) - A tool designed to assess quickly the Active Directory security level with a methodology based on risk assessment and a maturity framework
* [Aorato Skeleton Key Malware Remote DC Scanner](https://gallery.technet.microsoft.com/Aorato-Skeleton-Key-24e46b73) - Remotely scans for the existence of the Skeleton Key Malware
* [Reset the krbtgt account password/keys](https://gallery.technet.microsoft.com/Reset-the-krbtgt-account-581a9e51) - This script will enable you to reset the krbtgt account password and related keys while minimizing the likelihood of Kerberos authentication issues being caused by the operation
* [Deploy-Deception](https://github.com/samratashok/Deploy-Deception) -  A PowerShell module to deploy active directory decoy objects
* [dcept](https://github.com/secureworks/dcept) - A tool for deploying and detecting use of Active Directory honeytokens
* [LogonTracer](https://github.com/JPCERTCC/LogonTracer) - Investigate malicious Windows logon by visualizing and analyzing Windows event log
* [DCSYNCMonitor](https://github.com/shellster/DCSYNCMonitor) - Monitors for DCSYNC and DCSHADOW attacks and create custom Windows Events for these events

### Detection
|Attack|Event ID|
|------|--------|
|Account and Group Enumeration|4798: A user's local group membership was enumerated<br>4799: A security-enabled local group membership was enumerated|
|AdminSDHolder|4780: The ACL was set on accounts which are members of administrators groups|
|Kekeo|4624: Account Logon<br>4672: Admin Logon<br>4768: Kerberos TGS Request|
|Silver	Ticket|4624: Account Logon<br>4634: Account Logoff<br>4672: Admin Logon|
|Golden	Ticket|4624: Account Logon<br>4672: Admin Logon|
|PowerShell|4103: Script Block Logging<br>400: Engine Lifecycle<br>403: Engine Lifecycle<br>4103: Module Logging<br>600: Provider Lifecycle<br>|
|DCShadow|4742: A computer account was changed<br>5137: A directory service object was created<br>5141: A directory service object was deleted<br>4929: An Active Directory replica source naming context was removed|
|Skeleton Keys|4673: A privileged service was called<br>4611: A trusted logon process has been registered with the Local Security Authority<br>4688: A new process has been created<br>4689: A new process has exited|
|PYKEK MS14-068|4672: Admin Logon<br>4624: Account Logon<br>4768: Kerberos TGS Request|
|Kerberoasting|4769: A Kerberos ticket was requested|
|Lateral Movement|4688: A new process has been created<br>4689: A process has exited<br>4624: An account was successfully logged on<br>4625: An account failed to log on|
|DCSync|4662: An operation was performed on an object|
|Password Spraying|4625: An account failed to log on<br>4771: Kerberos pre-authentication failed<br>4648: A logon was attempted using explicit credentials|

### Resources
* [Reducing the Active Directory Attack Surface](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/reducing-the-active-directory-attack-surface)
* [Securing Domain Controllers to Improve Active Directory Security](https://adsecurity.org/?p=3377)
* [Securing Windows Workstations: Developing a Secure Baseline](https://adsecurity.org/?p=3299)
* [Implementing Secure Administrative Hosts](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/implementing-secure-administrative-hosts)
* [Privileged Access Management for Active Directory Domain Services](https://docs.microsoft.com/en-us/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services)
* [Awesome Windows Domain Hardening](https://github.com/PaulSec/awesome-windows-domain-hardening)
* [Best Practices for Securing Active Directory](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/best-practices-for-securing-active-directory)
* [Introducing the Adversary Resilience Methodology — Part One](https://posts.specterops.io/introducing-the-adversary-resilience-methodology-part-one-e38e06ffd604)
* [Introducing the Adversary Resilience Methodology — Part Two](https://posts.specterops.io/introducing-the-adversary-resilience-methodology-part-two-279a1ed7863d)
* [Mitigating Pass-the-Hash and Other Credential Theft, version 2](https://download.microsoft.com/download/7/7/A/77ABC5BD-8320-41AF-863C-6ECFB10CB4B9/Mitigating-Pass-the-Hash-Attacks-and-Other-Credential-Theft-Version-2.pdf)
* [Configuration guidance for implementing the Windows 10 and Windows Server 2016 DoD Secure Host Baseline settings](https://github.com/nsacyber/Windows-Secure-Host-Baseline)
* [Monitoring Active Directory for Signs of Compromise](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/monitoring-active-directory-for-signs-of-compromise)
* [Detecting Lateral Movement through Tracking Event Logs](https://www.jpcert.or.jp/english/pub/sr/Detecting%20Lateral%20Movement%20through%20Tracking%20Event%20Logs_version2.pdf)
* [Kerberos Golden Ticket Protection Mitigating Pass-the-Ticket on Active Directory](https://cert.europa.eu/static/WhitePapers/UPDATED%20-%20CERT-EU_Security_Whitepaper_2014-007_Kerberos_Golden_Ticket_Protection_v1_4.pdf)
* [Overview of Microsoft's "Best Practices for Securing Active Directory"](https://digital-forensics.sans.org/blog/2013/06/20/overview-of-microsofts-best-practices-for-securing-active-directory)
* [The Keys to the Kingdom: Limiting Active Directory Administrators](https://dsimg.ubm-us.net/envelope/155422/314202/1330537912_Keys_to_the_Kingdom_Limiting_AD_Admins.pdf)
* [The Most Common Active Directory Security Issues and What You Can Do to Fix Them](https://adsecurity.org/?p=1684)
* [Event Forwarding Guidance](https://github.com/nsacyber/Event-Forwarding-Guidance)
* [Planting the Red Forest: Improving AD on the Road to ESAE](https://www.mwrinfosecurity.com/our-thinking/planting-the-red-forest-improving-ad-on-the-road-to-esae/)
* [Detecting Kerberoasting Activity](https://adsecurity.org/?p=3458)
* [Security Considerations for Trusts](https://docs.microsoft.com/pt-pt/previous-versions/windows/server/cc755321(v=ws.10))
* [Advanced Threat Analytics suspicious activity guide](https://docs.microsoft.com/en-us/advanced-threat-analytics/suspicious-activity-guide)
* [Windows 10 Credential Theft Mitigation Guide](https://download.microsoft.com/download/C/1/4/C14579CA-E564-4743-8B51-61C0882662AC/Windows%2010%20credential%20theft%20mitigation%20guide.docx)
* [Detecting Pass-The- Ticket and Pass-The- Hash Attack Using Simple WMI Commands](https://blog.javelin-networks.com/detecting-pass-the-ticket-and-pass-the-hash-attack-using-simple-wmi-commands-2c46102b76bc)
* [Step by Step Deploy Microsoft Local Administrator Password Solution](https://gallery.technet.microsoft.com/Step-by-Step-Deploy-Local-7c9ef772)
* [Active Directory Security Best Practices](https://www.troopers.de/downloads/troopers17/TR17_AD_signed.pdf)
* [Finally Deploy and Audit LAPS with Project VAST, Part 1 of 2](https://blogs.technet.microsoft.com/jonsh/2018/10/03/finally-deploy-and-audit-laps-with-project-vast-part-1-of-2/)
* [Windows Security Log Events](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx)
* [Talk Transcript BSidesCharm Detecting the Elusive: Active Directory Threat Hunting](https://www.trimarcsecurity.com/single-post/Detecting-the-Elusive-Active-Directory-Threat-Hunting)
* [Preventing Mimikatz Attacks](https://medium.com/blue-team/preventing-mimikatz-attacks-ed283e7ebdd5)
* [Understanding "Red Forest" - The 3-Tier ESAE and Alternative Ways to Protect Privileged Credentials](https://www.slideshare.net/QuestSoftware/understanding-red-forest-the-3tier-esae-and-alternative-ways-to-protect-privileged-credentials)
* [AD Reading: Active Directory Backup and Disaster Recovery](https://adsecurity.org/?p=22)
* [Ten Process Injection Techniques: A Technical Survey Of Common And Trending Process Injection Techniques](https://www.endgame.com/blog/technical-blog/ten-process-injection-techniques-technical-survey-common-and-trending-process)
* [Hunting For In-Memory .NET Attacks](https://www.endgame.com/blog/technical-blog/hunting-memory-net-attacks)
* [Mimikatz Overview, Defenses and Detection](https://www.sans.org/reading-room/whitepapers/detection/mimikatz-overview-defenses-detection-36780)
* [Trimarc Research: Detecting Password Spraying with Security Event Auditing](https://www.trimarcsecurity.com/single-post/2018/05/06/Trimarc-Research-Detecting-Password-Spraying-with-Security-Event-Auditing)
* [Hunting for Gargoyle Memory Scanning Evasion](https://www.countercept.com/blog/hunting-for-gargoyle/)
* [Planning and getting started on the Windows Defender Application Control deployment process](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/windows-defender-application-control-deployment-guide)
* [How to Go from Responding to Hunting with Sysinternals Sysmon](https://onedrive.live.com/view.aspx?resid=D026B4699190F1E6!2843&ithint=file%2cpptx&app=PowerPoint&authkey=!AMvCRTKB_V1J5ow)
