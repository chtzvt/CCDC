# Palo Alto Cheatsheet

## Interzone Rules

Ensure that interzone allow is added in order for traffic to flow by default through said zones. If **inter**zone rules are not implemented, traffic will not flow between ZONES. Traffic will flow between interfaces, but not between zones.

## Profile Policies

This is where you can activate most of Palo's DPI and url filtering.
```admin@palo-vm-50# set rulebase security rules WEB profile-setting profiles```

## Security Policy

**NAT NOTE**: Firewall rules use the PRENAT Destination IP, but the POSTNAT Destination Zones

Basic creation of a security rule
```
> configure (press enter)

# set rulebase security rules <name> from <source zone> to <destination zone> source <ip> destination <ip> application [<application>] service <any/application-default/service name> action <allow/deny> (press enter)

# exit
```

Example:
```
# set rulebase security rules Generic-Security from Outside-L3 to Inside-L3 destination 63.63.63.63 application web-browsing service application-default action allow (press enter)

Note: For help with entry of all CLI commands use "?" or [tab] to get a list of the available commands.
```


To view the Palo Alto Networks Security Policies from the CLI:

```
> show running security-policy
```

The following command will output the entire configuration:
```
> show config running
```


In order to get the rulebase in command format:
```
> set cli config-output-format set

> configure
Entering configuration mode
[edit]

# edit rulebase security
[edit rulebase security]

# show
set rulebase security rules rashi from trust-vwire
set rulebase security rules rashi from untrust-vwire
set rulebase security rules rashi to trust-vwire
set rulebase security rules rashi to untrust-vwire
set rulebase security rules rashi source 10.16.0.21
set rulebase security rules rashi destination any
set rulebase security rules rashi service any
set rulebase security rules rashi application adobe-meeting-remote-control
set rulebase security rules rashi application adobe-meeting
set rulebase security rules rashi application adobe-online-office
set rulebase security rules rashi action deny
set rulebase security rules rashi source-user any
set rulebase security rules rashi option disable-server-response-inspection no
set rulebase security rules rashi negate-source no
set rulebase security rules rashi negate-destination no
set rulebase security rules rashi disabled yes
set rulebase security rules rashi log-start no
set rulebase security rules rashi log-end yes
```

To switch to the default output:

```
From configure mode:

# run set cli config-output-format default

[edit rulebase security]
# show
security {
  rules {
    rashi {
      from [ trust-vwire untrust-vwire];
      to [ trust-vwire untrust-vwire];
      source 10.16.0.21;
      destination any;
      service any;
      application [ adobe-meeting-remote-control adobe-meeting adobe-online-office];
      action deny;
      source-user any;
      option {
        disable-server-response-inspection no;
      }
      negate-source no;
      negate-destination no;
      disabled yes;
      log-start no;
      log-end yes;
      profile-setting {
        profiles {
          file-blocking rashi_file_alert;
          data-filtering rashi_dlp;
        }
```

Also, if you want a shorter way to View and Delete security rules inside configure mode, you can use these 2 commands:

To find a rule:

`show rulebase security rules <rulename>`


To delete or remove a rule:

`delete rulebase security rules <rulename>`

## Generic System Commands

```
Show general system health information.
> show system info

Show percent usage of disk partitions.
> show system disk-space

Show the maximum log file size.
> show system logdb-quota

Show running processes.
> show system software status

Show processes running in the management plane.
> show system resources

Show resource utilization in the dataplane.
> show running resource-monitor

Show the licenses installed on the device.
> request license info

Show when commits, downloads, and/or upgrades are completed.
> show jobs processed

Show session information.
> show session info

Show information about a specific session.
> show session id <session-id>

Show the running security policy.
> show running security-policy

Show the authentication logs.
> less mp-log authd.log

Restart the device.
> request restart system

Show the administrators who are currently logged in to the web interface, CLI, or API.
> show admins

Show the administrators who can access the web interface, CLI, or API, regardless of whether those administrators are currently logged in.
When you run this command on the firewall, the output includes both local administrators and those pushed from a Panorama template.
> show admins all

Configure the management interface as a DHCP client.
For a successful commit, you must include each of the parameters: accept-dhcp-domain, accept-dhcp-hostname, send-client-id, and send-hostname.
# set deviceconfig system type dhcp-client accept-dhcp-domain <yes|no> accept-dhcp-hostname <yes|no> send-client-id <yes|no> send-hostname <yes|no>
```

## Passwords

```
# set mgt-config user admin password
```

## Weird Application Definitions

```
SMB => ms-ds-smb
HTTP => web-browsing (80)
HTTPS => ssl (443)
```

**Remember**: web-browsing only allows port 80 traffic. SSL only allows *generic* port 443 traffic. As such, certain applications such as `google-base` will catch traffic. If you want to allow **ALL** traffic over said ports, create a service definition for it.

```
# set service http protocol tcp port 1337
```

## Routing Troubleshooting
```
Display the routing table
> show routing route

Look at routes for a specific destination
> show routing fib virtual-router <name> | match <x.x.x.x/Y>
```

## Addresses
```
# set address WOW ip-netmask ADDR/MASK
```

**Remember**: Put a `/32` netmask for single addresses. All other netmasks will be parsed as an IP Range. In most cases, this will not be useful.

## Copy Rules
```
# copy rulebase security A to B
```

**Tip**: Use this to easily create many firewall policy rules which are similar to eachother, but be sure to inspect the copied rules to ensure that they are correct. Fields within a firewall rule are not changed by a `copy` operation.

## NAT
### Troubleshooting
```
Show the NAT policy table
> show running nat-policy

Test the NAT policy
> test nat-policy-match

Show NAT pool utilization
> show running ippool
> show running global-ippool
```

### Creation
```
Use the following command to create a NAT rule on the CLI:

# set rulebase nat rules <NAT Rule Name> description <Description of NAT rule> from <Source Zone> to <Destination Zone> service <Service Type> source <Source IP Address>  destination <Destination IP address> source-translation <Type of Source Translation> interface-address interface <Interface Port number>
```

The example below create static NAT translation with dynamic IP and port and uses interface ethernet1/4.
```
> configure

# set rulebase nat rules StaticNAT description staticNAT from DMZ to L3-Untrust service any source any destination any source-translation dynamic-ip-and-port interface-address interface ethernet1/4

# commit

# exit
```


Once committed, use the following command to confirm creation of the NAT rule.
```
> show running nat-policy



StaticNAT {

        from DMZ;

        source any;

        to L3-Untrust;

        to-interface  ;

        destination any;

        service  any/any/any;

        translate-to "src: ethernet1/4 10.46.40.56 (dynamic-ip-and-port) (pool idx: 2)";

        terminal no;

}
```
## Modification of the Management Interface
```
> configure (enter configuration mode)

# set deviceconfig system ip-address 10.1.1.1 netmask 255.255.255.0 default-gateway 10.1.1.2 dns-setting servers primary 4.2.2.2

# commit
```

## Monitoring Capabilities
```
> show session info

-------------------------------------------------------------------------------
number of sessions supported:                   131071
number of active sessions:                      7501
number of active TCP sessions:                  5503
number of active UDP sessions:                  1980
number of active ICMP sessions:                 16
number of active BCAST sessions:                0
number of active MCAST sessions:                0
number of predict sessions:                     914
session table utilization:                      5%
number of sessions created since system bootup: 1054609
Packet rate:                                    3298/s
Throughput:                                     20321 Kbps
-------------------------------------------------------------------------------
session timeout
  TCP default timeout:                          3600 seconds
  TCP session timeout before 3-way handshaking:    5 seconds
  TCP session timeout after FIN/RST:              30 seconds
  UDP default timeout:                            30 seconds
  ICMP default timeout:                            6 seconds
  other IP default timeout:                       30 seconds
  Session timeout in discard state:
    TCP: 90 seconds, UDP: 60 seconds, other IP protocols: 60 seconds
-------------------------------------------------------------------------------
session accelerated aging:                      enabled
  accelerated aging threshold:                  80% of utilization
  scaling factor:                               2 X
-------------------------------------------------------------------------------
session setup
  TCP - reject non-SYN first packet:            no
  hardware session offloading:                  yes
  IPv6 firewalling:                             no
-------------------------------------------------------------------------------
application trickling scan parameters:
  timeout to determine application trickling:   10 seconds
  resource utilization threshold to start scan: 80%
  scan scaling factor over regular aging:       8
-------------------------------------------------------------------------------
```
```
> show session all

ID/vsys   application     state   type flag   src[sport]/zone/proto (translated IP[port])
                                              dst[dport]/zone (translated IP[port]
-------------------------------------------------------------------------------

4583/1    0               ACTIVE  FLOW        10.5.20.110[139]/corp-trust/6 (10.5.20.110[139])
                                              192.168.83.1[4907]/corp-untrust (192.168.83.1[4907])
16407/1   0               ACTIVE  FLOW        10.16.0.200[1475]/corp-trust/6 (10.16.0.200[1475])
                                              10.5.20.110[139]/corp-untrust (10.5.20.110[139])
119943/1  skype           ACTIVE  PRED        0.0.0.0[0]/corp-trust/6 (0.0.0.0[0])
                                              75.111.30.222[443]/corp-untrust (75.111.30.222[443])
```

```
> show session all filter

+ application        Application name
+ destination        destination IP address
+ destination-port   Destination port
+ destination-user   Destination user
+ from               From zone
+ nat                If session is NAT
+ nat-rule           NAT rule name
+ protocol           IP protocol value
+ proxy              session is decrypted
+ rule               Rule name
+ source             source IP address
+ source-port        Source port
+ source-user        Source user
+ state              flow state
+ to                 To zone
+ type               flow type
  |                  Pipe through a command



Example of a filtered display:



> show session all filter source 10.5.20.110

-------------------------------------------------------------------------------
ID        application     state   type flag   src[sport]/zone/proto (translated IP[port])
                                              dst[dport]/zone (translated IP[port]
-------------------------------------------------------------------------------

22306     0               ACTIVE  FLOW        10.5.20.110[139]/corp-trust/6 (10.5.20.110[139])
                                              192.168.83.1[4907]/corp-untrust (192.168.83.1[4907])
20318     0               ACTIVE  FLOW        10.5.20.110[139]/corp-trust/6 (10.5.20.110[139])
                                              192.168.189.1[4492]/corp-untrust (192.168.189.1[4492])
111056    0               ACTIVE  FLOW        10.5.20.110[139]/corp-trust/6 (10.5.20.110[139])
                                              192.168.83.1[3007]/corp-untrust (192.168.83.1[3007])
130911    0               ACTIVE  FLOW        10.5.20.110[139]/corp-trust/6 (10.5.20.110[139])
```

## Advanced Tooling

### URL Filtering
Palo Alto comes with prebuilt databases of URLs for filtering. We are currently not sure if it is blocking based on the `host` header of a HTTP request, but we know that it is finicky. Don't use in competition unless the need arises. Find other options for blocking URLs.

### Wildfire
Wildfire is Palo Alto's file inspection service. We haven't tested to see how effective it is, but if you can turn it on why not?
