# SECCDCQC 2019
## Competition Metadata
- Saturday, February 23rd, 2019
- Peyton Duncan

### Config
Ensure only admin is a user

```config
# show mgt-config users
```

Check Management Access

```config
# show deviceconfig system
```

Set Admin Password

```config
# set mgt-config users admin password
```

Set Address Objects
```config
# set address WOW ip-netmask ADDR/MASK
```

Set ANY-ANY Rule
```config
# set rulebase security rules ANYANY from any to WAN source any destination any application any service any action allow
```

Set Traffic Analysis on ANY-ANY
```config
# set rulebase security rules ANYANY profile-setting profiles vulnerability strict
```

Set Rulebase for Whitelists
**Remember:** Firewall policy uses PRENAT IP Addresses, but POSTNAT Zones

```config
# set rulebase security rules <name> from <source zone> to <destination zone> source <ip> destination <ip> application [<application>] service <any/application-default/service name> action <allow/deny> (press enter)
```

`x` is our Team Number. So if our team number is `Team #9`, then an example IP would be `172.25.209.97`

|Host|External IP|Internal IP|Services?
|---|---|---|---|
|**Phantom**                   |172.25.20x.97   |172.20.240.10   |---|
|**Debian MySQL**              |172.25.20x.20   |172.20.240.20   |SQL, SSH?|
|====|====|====|====|
|**Ubuntu DNS**                |172.25.20x.23   |172.20.242.10   |DNS, SSH?|
|**2008 R2 AD/DNS/Exchange**   |172.25.20x.27   |172.20.242.200   |LDAP, DNS, POP3/IMAP?|
|**Windows 8.1 **              |dynamic   |172.20.242.100   |---|
|====|====|====|====|
|**Splunk  **                  |172.25.20x.9   |172.20.241.20   |---|
|**CentOS E-Comm **            |172.25.20x.11   |172.20.241.30   |WEB, SSH?|
|**Fedora Webmail/WebApps**    |172.25.20x.39   |172.20.241.40   |WEB, IMAP,POP3, SSH?|
|====|====|====|====|

Set Interzone Rule to Allow
```config
# set rulebase security rule interzone from [___ ___ ___] to [___ ___ ___] source any destination any application any service application-default action allow rule-type interzone
```

Set Ingress Blacklist
```config
# set rulebase security rule DENY_IN from WAN to any source any destionation any application any service application-default action deny
```

Set Egress Blacklist
```config
# set rulebase security rule DENY_OUT from any to WAN source any destionation any application any service application-default action deny
```
