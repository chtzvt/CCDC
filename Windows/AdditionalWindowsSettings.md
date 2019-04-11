# Additional Security Settings on Windows

## Windows Server 2008 - 2016


### Windows Firewall with Advanced Security
\\might create an additional document specifically on FW
```md
MMC - Windows Firewall Snap-in
export existing policy
Turn Firewall off
Delete all Firewall Rules
Command Prompt:
netsh advfirewall firewall delete rule name=all
Configure default rules to Block incoming AND outgoing connections
Create the necessary Inbound rules
Create the necessary Outbound rules
Turn Firewall ON
```

### Action Center

```md
Make sure User account control is on
Make sure Defender AND Firewall are on
Windows Smartscreen
```

### Group Policy
\\Still need to create documentation
```
See Group Policy documentation
```

### AppLocker

```
# In Group Policy manager
# Application Control Policies
Configure rule enforcement
Set each section to configured and enforced
For each section (Right Click) and:
Create Default Rules
Automatically Generate Rules
```

### What else should be done?
\\any ideas
```
#	Figure out how else we can do
```
