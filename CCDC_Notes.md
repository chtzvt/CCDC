# CCDC Linux Guides

## IP Tables Commands

##### Allow Established Connections:

```
$ iptables -A <INPUT/OUTPUT> -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

##### Allow Traffic on Port:

```
$ iptables -A <INPUT/OUTPUT> -p <tcp/udp> --dport <port> -j ACCEPT
```

##### Drop Everything Else:

`$ iptables -A <INPUT/OUTPUT> -j REJECT`

##### List Rules:

`$ iptables --line-numbers -vL`

##### Show NAT Table:

`$ iptables -t nat -L`

##### Forward All Traffic on a Port to Another Server:

```
$ iptables -t nat -A PREROUTING -p <tcp/udp> --dport <port> -j DNAT --to-destination <dest-ip-addr>:<port>
$ iptables -t nat -A POSTROUTING -p <tcp/udp> -d <dest-ip-addr> --dport <port> -j SNAT --to-source <source-ip-addr>
```

##### Block an IP Address:

```
$ iptables -I INPUT 1 -s 123.456.789.123 -j REJECT
$ iptables -I OUTPUT 1 -d 123.456.789.123 -j REJECT
```

##### Restrict Outbound Traffic to User:

```
$ iptables -A OUTPUT -m <uid> -p <tcp/udp> --dport <port> -j ACCEPT
```

## Antivirus

```
$ # Install clamav package (yum/apt/zypper/pkg)
$ freshclam
$ clamscan -ril virus.log /home
```

##### Scan another computer:

```
$ # Install sshfs package
$ mkdir /mnt/fs 
$ sshfs -o allow_other root@xxx.xxx.xxx.xxx:/ /mnt/fs
$ clamscan -ril /var/log/virus.log /mnt/fs/homeBackup Directory Securely
```
Note: run all commands as root

##### Setup:

```
$ mkdir /backup
$ chmod g+s /backup
$ chmod 600 /backup
$ setfacl -dPm u::rw,g::---,o::--- /backup
```

## Backup Management
##### Create an Archive:

`$ tar -zcPf /backup/path.to.directory.tar.gz /path/to/directory`

##### Archive & Encrypt:

```
$ tar -zcP /path/to/directory | \
> openssl enc -aes-256-cbc -e > /backup/path.to.directory-pwd#.tar.gz.enc
```

##### Unarchive:

```
$ cd /dir/to/unzip/in
$ tar -zxPf /backup/dirname.tar.gz
```

##### Decrypt & Unarchive:

```
$ cd /dir/to/unzip/in
$ openssl enc -aes-256-cbc -d -in /backup/dirname-pwd#.tar.gz.enc | tar -zxP
```

##### Send to different box:

`$ scp -r /backup user@ip:/backup-name`

## Using Docker (optional):
Installation will vary per version, this is Ubuntu 16.04:

```
$ apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
$ sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
$ apt-get install -y docker-ce
$ docker pull ubuntu
$ cat > /docker <<EOF
> #!/bin/bash
> /usr/bin/docker run --rm -u 65534 -it ubuntu /bin/rbash
> EOF
```

## Adding Users

##### Create file add_users:

```
#!/bin/bash
IFS=$'\n'
read -d '' CSV <<EOL
jromera,James Romera,hr			# Copy in CSV and put here
aplies,Andrew Plies,marketing
EOL
read -rs pass
for line in $CSV; do IFS=\, read user name group <<< "$line"
groupadd group 

# Normally
useradd -m -s `which rbash` -G $group -c $name $user

# Using docker
useradd -m -d /docker -s `which rbash` -G $group -c $name $user

# Using chroot (need to create CHRoot first)
useradd -m -d /home/jail/$user -s `which rbash` -G $group -c $name $user

echo $user:$pass | chpasswd
(echo $pass; echo $pass) | smbpasswd -s -a $user   # samba only
done

chmod +x add_users && ./add_users
```

Enter common password from password sheet
Share add_users script with other linux images (scp, file server, temp web server)
This script can also be used to change all the users passwords (useradd commands just error out)

##### Add Users to System (initially locked, one password for all)

```
$ while IFS=, read user name group; do
> groupadd $group
> useradd -m -s /sbin/nologin -c $name -g $group $user
> done < users.csv
```

##### Unlock All Accounts & Set Password:

```
$ cat > enable.sh <<EOF
> #!/bin/bash
> read -rs pass
> cut -d',' -f1 users.csv | while read user; do
> echo $user:$pass | chpasswd
> usermod -s /bin/rbash $user
> done
> EOF
$ chmod +x enable.sh
```

##### Lock Accounts:

```
$ cut -d',' -f4 users.csv | while read user; do
> usermod -L $user -s /sbin/nologin
> done
```

## MySQL Commands

##### List Users:

```
> use mysql;
> SELECT user,host,authentication_string from user;
(On older systems) > SELECT user,host,password from user;
```

##### List Permissions:

```
> SHOW GRANTS;
> SHOW GRANTS FOR 'user'@'host';
```

##### Create User:

```
> CREATE USER 'user'@'host' IDENTIFIED BY 'password';
```

##### Grant Permissions to User:

```
> GRANT ALL PRIVILEGES ON database.table TO 'user'@'host';
```

##### Change Password:

```
> ALTER USER 'user'@'host' IDENTIFIED BY 'password';
```

##### Remove User:

```
> DROP USER 'user'@'host';
```

##### Recover MySQL Root Password

```
$ systemctl stop mysql
$ mysqld_safe --skip-grant-tables --skip-networking &
$ mysql -u root -p
> use mysql
> update user set authentication_string=PASSWORD('newpass') where User='root' and Host='localhost' limit 1;
> exit
$ systemctl start mysql
```

If step mysql_safe fails:

```
$ cp /var/run
$ systemctl start mysql
$ cp -rp mysqld/ mysqld.bak
$ systemctl stop mysql
$ mv mysql.bak mysql #Add Users to System (common password, CSV in same file)
```

If on CentOS 5.x or earlier:

```
$ echo "bash -r" > /bin/rbash
$ chmod +x /bin/rbash
```

Notes:
'%' is used to match any host (e.g. 'user'@'%')
'*' is used to match all on permissions (e.g. database.* or *.*)


## Convert Static Site to use Wordpress

Install WordPress on server

Move static page.html files to /web-root/wp-content/your-theme/page.php

At the top of each file, insert:

`<?php /* Template Name: YourPageName */ ?>`

In the WordPress admin page, under Pages > All Pages, add a new page, and then under the Page Attributes section, change Template from "Default Template" to "YourPageName".  Give the page an appropriate name and save.

In your theme, set the front page to use a static page, and select your new page.

Repeat step 4 for all the pages you need to include for the site, but for each of those (secondary pages), change the permalink to a sensible name, and update the navigation links in the primary page's source file to point to those permalink names.

Move any images and other content to a folder in the WordPress root, and set the absolute path to them in your template files.

## MediaWiki Convert & Upload

##### Convert Docx (Word Documents) to MediaWiki page:
```
$ cd /dir/with/docx/files
$ find . -name "*.docx" -type f -exec sh -c 'pandoc "${0}" > "${0%.docx}.html"' {} \;
$ find . -name "*.html" -type f -exec sh -c 'pandoc -s -t mediawiki --toc "${0}" -o "${0%.html}.wiki"' {} \;
$ sed -i -e ':a' -e 'N' -e '$!ba' -e 's|<br />\n||g' *.wiki
```

Note: Try this new command for direct conversion: 
`pandoc -s -I -f docx -t mediawiki “$i” -o “$i”.mediawiki`

Also look into [this tool](http://www.donationcoder.com/software/mouser/obsolete-stuff/mwimporter).
 
##### Upload to MediaWiki
```
$ cd /path/to/web/root/maintenance
$ php importTextFiles.php /dir/with/wiki/files/*.wiki --user <mw_username>
```

## Other Security Stuff

##### Mass Delete Pages:
```
$ mysql -u root -p
> use <media_wiki_db_name>
> select page_title from page into outfile '/root/pages.csv';
$ # Delete main page from pages.csv file
$ cd /path/to/web/root/maintenance
$ php deleteBatch.php /root/pages.csv
```

##### Search for PHP Backdoors

```
$ grep -iR 'c99' /path/to/web/root
$ grep -iR 'r57' /path/to/web/root
$ find /path/to/web/root -name \*.php -type f -print0 | xargs -o grep c99
$ grep -RPn "(passthru|shell_exec|system|base64_decode|fopen|fclose|eval)" /path
```

##### Restrict Processes in Limits.conf
Edit /etc/limits.conf (or /etc/security/limits.conf)

```
> * - nproc 5000
> * - nofile 20
```

#### Apply changed without reboot (make apply to any new session):

```
$ echo "session required pam_limits.so" >> /etc/pam.d/common-session  # Debian
$ echo "session required pam_limits.so" >> /etc/pam.d/system-auth     # RHEL
```

##### Check what is applied to current session:
```
$ ulimit -Hn  # number of files
$ ulimit -Hu  # number of processes
```

##### Convert All ARP Entries to Static
```
$ arp -an | awk -F' ' '{print $2 $4}' | cut -d'(' -f2 | while IFS=')' read ip mac
> do arp -s $ip $mac
> done
```

##### Disable IPv6

RHEL:

```
$ sysctl -w net.ipv6.conf.all.disable_ipv6=1
$ sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

Debian-based linux:

```
$ cat >> /etc/sysctl.conf <<EOF
> net.ipv6.conf.all.disable_ipv6 = 1
> net.ipv6.conf.default.disable_ipv6 = 1
> net.ipv6.conf.lo.disable_ipv6 = 1
> EOF
$ sysctl -p
```

##### Checking Files
Find all files and directories with unsafe permissions (including setgid bits):

`$ find / \( -path /proc -o -path /sys -o -path /dev -o -path */rc.d \) -prune -o -perm -755 ! -perm 755`

##### Look at permissions on critical files:

`$ ls -l /etc/passwd /etc/shadow /etc/group ~/.ssh /etc/ssh/sshd_config`

Audit all files  (and check) - without Git:

```
$ ls -Rl -Iproc / > /etc/files.mark
...later
$ mv /etc/files.mark /etc/files.mark.old
$ ls -Rl -Iproc / > /etc/files.mark
$ diff /etc/files.mark /etc/files.mark.old | more
```

##### Audit all files (and check) - with Git:

```
$ mkdir /files
$ cd /files
$ git init
$ ls -Rl -Iproc / > files.mark
$ git commit files.mark -m "$(date)"
...later
$ ls -Rl -Iproc / > files.mark
$ git commit files.mark -m "$(date)"
$ git diff HEAD HEAD^ files.mark  # Compares current with last
```

##### Find files that are more recent than /etc/issue:

`$ find / -newer /etc/issue`

Find files that were modified recently:

`$ find / -mtime -5`


##### Install and Run Lynis
```
$ git clone https://github.com/CISOfy/lynis
$ cd lynis
$ ./lynis audit system
```

## Extra Links

#####Kernel Hardening

- URL: https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
- Google: Linux Kernel Security Hardening sysctl

##### PHP Security

- https://www.cyberciti.biz/tips/php-security-best-practices-tutorial.html
