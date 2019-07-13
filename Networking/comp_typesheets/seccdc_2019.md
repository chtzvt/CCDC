# SECCDCQC 2019
## Competition Metadata
- Wednesday through Thursday April 3rd & 4th 2019
- Peyton Duncan

### Config
Ensure only admin is a user

```config
# show mgt-config users
# delete mgt-config users ANYTHING_NOT_ADMIN
```

Check Management Access

```config
# show deviceconfig system
# set deviceconfig system service disable-http yes
...
# delete deviceconfig setting custom-logo
```

Set Admin Password

```config
# set mgt-config users admin password
```

**GO TO PREBUILT FOR RULES AND ADDRESSES**

**Remember:** Firewall policy uses PRENAT IP Addresses, but POSTNAT Zones

Set Traffic Analysis on ANY-ANY
```config
# set rulebase security rules ANYANY profile-setting profiles vulnerability strict
```

```config
# set rulebase security rules <name> from <source zone> to <destination zone> source <ip> destination <ip> application [<application>] service <any/application-default/service name> action <allow/deny> (press enter)
```

`t` is our Team Number. So if our team number is `Team #9`, then an example IP would be `10.10.19.15`

|Host|External IP|Internal IP|Services?
|---|---|---|---|
|**DB**        |10.10.10t.15   |192.168.1.15   |MySQL, DNS|
|**ECOM**      |10.10.10t.20   |192.168.1.20   |HTTP, HTTPS|
|**MAIL**      |10.10.10t.25   |192.168.1.25   |SSH, SMTP, POP3|
|====|====|====|====|
|**WWW**       |10.10.10t.5    |192.168.1.5    |HTTP, HTTPS|
|**AD**        |10.10.10t.10   |192.168.1.10   |LDAP, DNS|
|====|====|====|====|
|**Manager**   |10.10.10t.99   |192.168.1.99   |HTTP, HTTPS|
|====|====|====|====|

<!-- Set Interzone Rule to Allow
```config
# set rulebase security rule interzone from [___ ___ ___] to [___ ___ ___] source any destination any application any service application-default action allow rule-type interzone
``` -->

Set Ingress Blacklist
```config
# set rulebase security rule DENY_IN from WAN to any source any destionation any application any service application-default action deny
```

Set Egress Blacklist
```config
# set rulebase security rule DENY_OUT from any to WAN source any destionation any application any service application-default action deny
```
