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
