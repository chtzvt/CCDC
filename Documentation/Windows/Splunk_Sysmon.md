# Sysmon + Splunk Shit

## Splunk

RobbieTw
101Dongs!


### Change Splunk Administrator Password
1) Go to Administrator
2) Go to "Account Settings"


## Deploying Sysmon on Windows
1) Go to Sysinternals Site 
2) Download Sysmon v7.01 
3) Open up command prompt (-n is for network)
4) `sysmon64.exe -i sysmon-config.xml -n`
    5) add -h MD5,SHA256 if needed
    6) -l for image load events 
6) Sysmon Logs will be located at 
    - `C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx`
7) System    
## Connecting Sysmon to Splunk Enterprise
Requires Splunk-TA app 


## Sysmon configs 


``` 

#Sysmon config
#Log network connections
 <NetworkConnect onmatch="include"> 
     <DestinationPort condition="is">80</DestinationPort> 
   <DestinationPort condition="is">443</DestinationPort> 
   <DestinationPort condition="is">8080</DestinationPort> 
   <DestinationPort condition="is">3389</DestinationPort> 
   <Image condition="contains">cmd.exe</Image> 
   <Image condition="contains">PsExe</Image> |
   <Image condition="contains">winexe</Image> 
   <Image condition="contains">powershell</Image> 
   <Image condition="contains">cscript</Image> 
   <Image condition="contains">mstsc</Image> 
   <Image condition="contains">RTS2App</Image> 
   <Image condition="contains">RTS3App</Image> 
   <Image condition="contains">wmic</Image> 
   </NetworkConnect> 
   </EventFiltering> 
   </Sysmon> 

``` 
Best config
```
<Sysmon schemaversion="4.00">
  <HashAlgorithms>md5,imphash</HashAlgorithms>
  <EventFiltering>
    <ProcessCreate onmatch="include">
	      <Image condition="contains">cmd.exe</Image>
  	      <Image condition="contains">powershell.exe</Image>
  	      <Image condition="contains">wmic.exe</Image>
  	      <Image condition="contains">cscirpt.exe</Image>
  	      <Image condition="contains">wscript.exe</Image>
          <Image condition="contains">net.exe</Image>
          <Image condition="contains">psexec.exe</Image>
          <ParentImage condition="contains">cmd.exe</ParentImage>
          <ParentImage condition="contains">powershell.exe</ParentImage>
          <ParentImage condition="contains">wmic.exe</ParentImage>
          <ParentImage condition="contains">cscirpt.exe</ParentImage>
          <ParentImage condition="contains">wscript.exe</ParentImage>
          <ParentImage condition="contains">net.exe</ParentImage>
          <ParentImage condition="contains">psexec.exe</ParentImage>
          <ParentImage condition="contains">explorer.exe</ParentImage>
    </ProcessCreate>
    
<NetworkConnect onmatch="include"> 
<DestinationPort condition="is">80</DestinationPort> 
   <DestinationPort condition="is">443</DestinationPort> 
   <DestinationPort condition="is">8080</DestinationPort> 
   <DestinationPort condition="is">3389</DestinationPort>
<!--COMMENT: Takes a very conservative approach to network logging.-->
			<!--Suspicious sources-->
			<Image condition="begin with">C:\Users</Image>
			<Image condition="begin with">C:\ProgramData</Image>
			<Image condition="begin with">C:\Windows\Temp</Image>
			<Image condition="image">powershell.exe</Image> 
			<Image condition="image">cmd.exe</Image> 
			<Image condition="image">wmic.exe</Image> 
			<Image condition="image">cscript.exe</Image> 
			<Image condition="image">wscript.exe</Image> 
			<Image condition="image">rundll32.exe</Image> 
			<Image condition="image">notepad.exe</Image> 
			<Image condition="image">regsvr32.exe</Image>
			</NetworkConnect>
  </EventFiltering>
</Sysmon>
```




# Splunk + Sysmon 

- Edit splunk.confs
    - `C:\\Program Files\\SplunkUniversalForwarder\\etc\\apps\\SplunkUniversalForwarder\\local\\inputs.conf`
    - Add this shit
```
[WinEventLog://Microsoft-Windows-Sysmon/Operational]  
checkpointInterval = 5  
current_only = 0  
disabled = 0  
start_from = oldest
```




## Sample Queries

`source="wineventlog:microsoft-windows-sysmon/operational" EventCode=3 Protocol=tcp | iplocation DestinationIp | stats count by Region | geom geo_us_states featureIdField=Region` 

### Get all Command Lines
source="wineventlog:microsoft-windows-sysmon/operational" | stats count by CommandLine

### Get all CommandLines by Machine
source="wineventlog:microsoft-windows-sysmon/operational" | stats count by ComputerName,CommandLine

### Get all CommandLines by Machine for Powershell
source="wineventlog:microsoft-windows-sysmon/operational" | search Image="*powershell.exe" | stats count by ComputerName, CommandLine

### Find psexec
`index=sysmon ParentImage="*\\\PSEXESVC.EXE" | stats count by Image,Hashes` 

### Find schtasks

`index=sysmon Image="*\\\schtasks.exe" CommandLine="*" `

### Find Enumeration
`index=sysmon CommandLine="net group*" CommandLine="*/domain*"` 

### Query for long powershell command lines
`sourcetype=”WinEventLog:Microsoft-Windows-Sysmon/Operational” eventcode=1   image=”C:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe” OR   image=”C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe” | eval   c_length=len(commandline) | where c_length>1000`

### Query for suspicious strings
`
sourcetype=”WinEventLog:Microsoft-Windows-Sysmon/Operational” eventcode=1   powershell.exe Invoke* OR IEX   OR Download* | table _time, computername, processid, image,commandline, parentprocessid,parentimage,parentcommandline`


## Create scxy ass Dashboards/Maps to ip find those chinese APTS

### network connections by country:
`source="wineventlog:microsoft-windows-sysmon/operational" EventCode=3 Protocol=tcp | iplocation DestinationIp | stats count by Country | geom geo_countries featureIdField=Country`

### Network Connections by US state regions
`EventCode=3 Protocol=tcp | iplocation DestinationIp | stats count by Region | geom geo_us_states featureIdField=Region`

### Analyze the EventID 3 for non-browsers executables with abnormal number of connections to Internet

`sourcetype=”WinEventLog:Microsoft-Windows-Sysmon/Operational” eventcode = 3 rundll32.exe | timechart count(_raw) by computername`
