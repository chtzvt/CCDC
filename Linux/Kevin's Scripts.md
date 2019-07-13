# Kevin's Great Ideas


### Docker Auto Installation
```
#!/bin/bash

# Update repos and allow adding https apt repos
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add docker's apt repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update repos and install docker community edition
apt-get update
apt-get install -y docker-ce

# Create docker group
groupadd docker

# Set docker to start on boot
systemctl enable docker
```

### Dockersh (Restricted Shell)
```
#!/bin/bash

# Create temporary directory for Dockerfile
mkdir -p /tmp/dockersh
cp users.txt /tmp/dockersh/
cd /tmp/dockersh

# Create Dockerfile for dockersh
echo "FROM ubuntu:16.04" >Dockerfile

for u in $(cat users.txt); do
cat >>Dockerfile <<EOF
VOLUME $(eval echo "~$u")
RUN useradd -s /bin/bash -U -d $(eval echo "~$u") -u $(id -u "$u") "$u"
EOF
done

# Build docker image
docker rm -f dockersh > /dev/null 2>&1 || true
docker rmi dockersh > /dev/null 2>&1 || true
docker build -t dockersh .

# Spawn docker container, mounting user-related files in /etc and then
# mounting home directories within the container
docker run -itd --name dockersh -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/group:/etc/group:ro -v /etc/gshadow:/etc/gshadow:ro -v /etc/localtime:/etc/localtime:ro $(for u in $(cat users.txt); do echo -n " -v $(eval echo "~$u"):$(eval echo "~$u")"; done) dockersh

# Create dockersh "shell"
cat > /bin/dockersh <<EOF
#!/bin/bash
docker exec -it -u "\$USER" -w "\$HOME" dockersh /bin/bash
EOF
chmod +x /bin/dockersh

# Set shell for each user to /bin/dockersh and add them to the docker group
for u in $(cat users.txt); do
usermod -aG docker -s /bin/dockersh "$u"
done
```

### Git Backups
```
# Put the contents of this file at the end of /root/.bashrc, then run as root:
# source ~/.bashrc

# Example usage:
# root:~# cd /servers/ecom/var/www #Enter ecom's webroot
# root:/servers/ecom/var/www# gbi ecom-www #Git backup initialize to /backups/ecom-www
# root:/servers/ecom/var/www# vim config.php #Change some config files
# root:/servers/ecom/var/www# cd /backups/ecom-www
# root:/backups/ecom-www# gb ecom-www 'Changed MySQL creds' #View changes and add to backup
# root:/backups/ecom-www# gbenter ecom-www #Set GIT_DIR env var to allow running git commands
# root:/backups/ecom-www# git status #View changes since last backup
# root:/backups/ecom-www# git reset --hard #Restore last backup (won't delete newly created files)
# root:/backups/ecom-www# git log #View list of previous backups
# root:/backups/ecom-www# git checkout <commit_hash> #Restore to a specific backup
# root:/backups/ecom-www# gbexit #Unset GIT_DIR env var to make git work normally

function gbi() {
	if [ -z "$1" ]; then
		echo "Usage: gbi <name_of_backup>"
		return 1
	fi
	local gitdir="$PWD"
	cd /backups
	git init --bare "$1"
	cd "$1"
	git config core.worktree "$gitdir"
	git config core.bare false
	git add -A
	git commit -m 'Initial backup'
	git status
	cd $gitdir
}

function gbenter() {
	if [ -z "$1" ]; then
		echo "Usage: gbenter <name_of_backup>"
		return 1
	fi
	export GIT_DIR="/backups/$1"
}

function gbexit() {
	unset GIT_DIR
}

function gb() {
	if [ -z "$1" -o -z "$2" ]; then
		echo "Usage: gb <name_of_backup> <message>"
		return 1
	fi
	gbenter "$1"
	git add -u
	git add -A
	git status
	read -p "Commit backup? [Y/n] " -n 1 -r
	echo
	if [[ "$REPLY" =~ ^[Yy]$ ]]; then
		git commit -m "$2"
		git status
	fi
	gbexit
}
```

### Mass Password Rotation
```
#!/usr/bin/env python
import csv, sys, os
from subprocess import Popen, PIPE

pwlen = 12
creds = []
users = open("users.txt", "r").read().split()
urand = open("/dev/urandom", "rb")
for user in users:
	pwd = urand.read((pwlen + 1) / 2).encode("hex")[:pwlen]
	creds.append([user, pwd])
urand.close()
pwchanges = "\n".join("%s:%s" % tuple(cred) for cred in creds)

i = 0
fname = "pwchanges_%d.csv"
while os.path.exists(fname % i): i += 1
ofp = open(fname % i, "w")
wr = csv.writer(ofp)
wr.writerows(creds)
ofp.close()
raw_input("Press enter to apply password changes...")

p = Popen(["/usr/sbin/chpasswd"], stdin=PIPE)
out, err = p.communicate(pwchanges)
ret = p.wait()
if ret != 0:
	print("Exit code %d:\n%s\n%s" % (ret, out, err))
	sys.exit(ret)
```
