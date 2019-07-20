#DNS Configuration

</br>

####Critical Details:
Port: 53
Install: Windows service
Connection: Inbound and outbound (for forwarding)

</br>

####Management:
</br>
**How to start/stop:**

1. Open services.msc
2. Locate "DNS Server"
3. Right click start or stop

**How to add new records:**
1. Open start menu
2. Type in DNS
3. Open DNS management console
3. Locate the zone you want to configure

</br>
#### Security:
</br>
**Disable Zone transfers**:
1. Find your DNS Zone under "forward lookup zones" in "DNS Manager"
2. Open "zone transfers" tab
3. Uncheck "allow zone transfers"

**Enable Logging:**
1. Right click on the server in "DNS Manager".
2. Open "debug logging" tab
3. Enable logging and set the file path to `C:\windows\system32\dns\log.txt`

</br>
####Troubleshoot:
</br>
(Need more in this section)

**Wireshark**
1. Open up wireshark and start sniffing network traffic
2. Observe dns traffic by typing in *dns* in the filter
3. Check what query you are getting and whether you are sendng a response.

Make sure your forwarders are set correctly