#!/usr/bin/env bash

while [ true ]
do
    echo "Enter the IP address of the machine:"
    read IP
    echo "What hostname should we resolve to $IP?"
    read HOSTNAME
    ssh-copy-id root@$IP
    echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts
    echo $HOSTNAME | sudo tee -a /etc/servers
    mkdir /servers/$HOSTNAME
    echo -e "All done!\n\n"
done
