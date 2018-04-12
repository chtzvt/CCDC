#!/usr/bin/env bash

sudo mkdir /servers
sudo chown root:toads /servers
sudo chmod 0775 /servers
echo "#!/usr/bin/env bash" >>~/mount_sshfs.sh
chmod +x ~/mount_sshfs.sh

while [ true ]
do
    echo "Enter the IP address of the machine:"
    read IP
    echo "What hostname should we resolve to $IP?"
    read HOSTNAME
    ssh-copy-id root@$IP
    echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts
    echo $HOSTNAME | sudo tee -a /etc/servers
    echo "sshfs -o reconnect,ServerAliveInterval=20 root@$IP:/ /servers/$HOSTNAME" >>~/mount_sshfs.sh
    mkdir /servers/$HOSTNAME
    echo -e "All done!\n\n"
done
