# CCDC Linux Guides

## NFT firewall
A Linux kernel >= 3.13 is required.

### Install NFT Firewall Tools

#### For debian based 

```
$ apt install nftables
```
#### For RHEL

```
$ yum install nftables
```

#### For arch:
```
$ pacman -S nftables 
```

#### For gentoo:
```
$ emerge --ask net-firewall/nftables
```

#### For opensuse:
```
$ zypper install nftables
```
### Use iptables-nft

#### Implement a log rule for SSH inbound:

```
$ iptables-nft -A INPUT -p tcp --dport 22 -j LOG
```
#### Save your firewall rules:

```
$ iptables-nft-save
```



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

```
$ iptables -A <INPUT/OUTPUT> -j REJECT
```

##### List Rules:

```
$ iptables --line-numbers -vL
```

##### Show NAT Table:

```
$ iptables -t nat -L
```

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

## Firewall with PfCTL (for \*BSD systems):

### Firewall Service Management:

#### Add the following to `/etc/rc.conf`:

```
pf_enable="YES"
pf_rules="/usr/local/etc/pf.conf"
pflog_enable="YES"
pflog_logfile="/var/log/pflog"
```

### Firewall Rules Management:

#### Firewall rules in `/usr/local/etc/pfc.conf`:

```
pass in quick on em0 inet proto tcp from $your_ip to em0 port 22 keep state
pass in quick on em0 inet proto tcp from $jumphost_ip to em0 port 22 keep state
block out all
```

## Solaris 11 Firewall:
### Firewall Service Management

#### First check to see if the firewall service is running:
```
$	svcs -a | grep pfil
```

#### To enable/start the firewall service:
```
$	svcadm enable svc:/network/ipfilter:default
```

#### View all current firewall rules:
```
$	ipfstat -io
```

#### To add/remove firewall rules edit the `ipf.conf` file:
```
$	vim /etc/ipf/ipf.conf
```

#### To refresh the ipfilter rules:
```
$	ipf -Fa -f /etc/ipf/ipf.conf
```

### Firewall Rules Configurations
These are all settings stored in the `/etc/ipf/ipf.conf` file.

If you want to allow all traffic through on the `net0` interface:
```
pass in on net0 all
pass out on net0 all
```
#### Block short packets which are packets fragmented too short to be real.
```
block in log quick all with short
```

#### This will by default block all incoming network traffic:
```
block in log on net0 from any to any head 100
```
#### This will allow in 22/tcp:
```
pass in quick on net0 proto tcp from any \
to net0/32 port = 22 flag S keep state group 100
```

## Backup Management

##### Setup:

```
$ mkdir /backup
$ chmod g+s /backup
$ chmod 600 /backup
$ setfacl -dPm u::rw,g::---,o::--- /backup
```

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

##### MySQL database backup:
```
$ mysqldump -u root -p --all-databases > /backups/db_dump
$ tar -zcP /backup/db_dump | openssl enc -aes-256-cbc -e > /backup/db_dump-pwd#.tar.gz.enc
$ # Verify
$ rm /backup/db_dump
```

##### Restore from MySQL database backup:
```
$ openssl enc -aes-256-cbc -d -in /backup/db_dump-pwd#.tar.gz.enc | tar -zxP
$ mysql -u root -p < db_dump
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

## Injects (Business tasks)

### Adding Users

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

### Network Scan (Inventory/Vulnerabilities)
```
$ nmap -n -sV {RANGE} -oX /nmap_scan.xml
```

### Disk Image Analysis Inject
```
$ screen ssh user@remote "dd if=/dev/sda | gzip -9 -" | dd of=image.gz
```

### SSH BruteForce Protection

```
$ /usr/sbin/iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
$ /usr/sbin/iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j DROP
```
OR
`apt install fail2ban` / `yum install fail2ban`

### Antivirus

```
$ # Install clamtk package (yum/apt/zypper/pkg)
$ vi /etc/freshclam.conf   # Remove example line near top
$ freshclam
$ clamscan -ril scan.log /bin /etc /home /root /usr /var /sbin
```

##### Scan another computer:

```
$ # Install sshfs package
$ mkdir /mnt/fs 
$ sshfs -o allow_other root@xxx.xxx.xxx.xxx:/ /mnt/fs
$ clamscan -ril /var/log/virus.log /mnt/fs/homeBackup Directory Securely
```
Note: run all commands as root

### Convert Static Site to use Wordpress

Install WordPress on server

Move static page.html files to /web-root/wp-content/your-theme/page.php

At the top of each file, insert:

`<?php /* Template Name: YourPageName */ ?>`

In the WordPress admin page, under Pages > All Pages, add a new page, and then under the Page Attributes section, change Template from "Default Template" to "YourPageName".  Give the page an appropriate name and save.

In your theme, set the front page to use a static page, and select your new page.

Repeat step 4 for all the pages you need to include for the site, but for each of those (secondary pages), change the permalink to a sensible name, and update the navigation links in the primary page's source file to point to those permalink names.

Move any images and other content to a folder in the WordPress root, and set the absolute path to them in your template files.

### MediaWiki Convert & Upload

#### Server setup

Use ubuntu 18.04lts 

```
$ sudo apt install fish apache2 mariadb-server -y
$ sudo apt-get install software-properties-common
$ sudo add-apt-repository ppa:ondrej/php -y
$ sudo apt-get update -y
$ sudo apt-get install php7.2 libapache2-mod-php7.2 php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-mcrypt php7.2-zip php7.2-curl -y

$ sudo systemctl start apache2
$ sudo systemctl enable apache2
$ sudo systemctl start mariadb
$ sudo systemctl enable mariadb
$ sudo systemctl stop cron

$ sudo mysql_secure_installation
$ mysql -u root -p
MariaDB [(none)]> CREATE DATABASE mediadb;
MariaDB [(none)]> CREATE USER 'media'@'localhost' IDENTIFIED BY 'password';
MariaDB [(none)]> GRANT ALL ON mediadb.* TO 'media'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;

$ wget https://releases.wikimedia.org/mediawiki/1.31/mediawiki-1.31.0.tar.gz
$ tar -xvzf mediawiki-1.31.0.tar.gz
$ sudo cp -r mediawiki-1.31.0 /var/www/html/mediawiki
$ sudo chown -R www-data:www-data /var/www/html/mediawiki
$ sudo chmod -R 777 /var/www/html/mediawiki
 
$ sudo nano /etc/apache2/sites-enabled/mediawiki.conf
```

Add the following lines:
```
 <VirtualHost *:80>
   DocumentRoot /var/www/html/mediawiki/
   <Directory /var/www/html/mediawiki/>
     Options +FollowSymLinks
     AllowOverride All
   </Directory>
   ErrorLog /var/log/apache2/media-error_log
   CustomLog /var/log/apache2/media-access_log common
 </VirtualHost>
 ```

#### Convert Docx (Word Documents) to MediaWiki page:
```
$ for i in HalPolicies/*/*.docx; do pandoc -s -f docx -t mediawiki “$i” -o “$i”.mediawiki; done
```

Backup method:
```
$ cd /dir/with/docx/files
$ find . -name "*.docx" -type f -exec sh -c 'pandoc "${0}" > "${0%.docx}.html"' {} \;
$ find . -name "*.html" -type f -exec sh -c 'pandoc -s -t mediawiki --toc "${0}" -o "${0%.html}.wiki"' {} \;
$ sed -i -e ':a' -e 'N' -e '$!ba' -e 's|<br />\n||g' *.wiki
```
 
#### Upload to MediaWiki
```
$ cd /path/to/web/root/maintenance
$ php importTextFiles.php /dir/with/wiki/files/*.wiki --user <mw_username>
```

#### Mass Delete Pages:
```
$ mysql -u root -p
> use <media_wiki_db_name>
> select page_title from page into outfile '/root/pages.csv';
$ # Delete main page from pages.csv file
$ cd /path/to/web/root/maintenance
$ php deleteBatch.php /root/pages.csv
```

### HTTPS ON E-Commerce

```
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/selfsigned.key -out /etc/ssl/certs/selfsigned.crt
$ sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```
Nginx (add to current config) 
```
# SSL configuration
listen 443 ssl default_server;
ssl_certificate /etc/ssl/certs/selfsigned.crt;
ssl_certificate_key /etc/ssl/private/selfsigned.key;
```

### OSSEC Install
```
wget -U ossec https://github.com/ossec/ossec-hids/archive/3.2.0.tar.gz
tar -zxf ossec-hids-2.8.1.tar.gz
cd ossec-hids-*
./install.sh
/var/ossec/bin/ossec-control start
/var/ossec/bin/manage_agents
iptables -A INPUT -p UDP --dport 1514 -s your_agent_ip -j ACCEPT
/var/ossec/bin/ossec-control restart
/var/ossec/bin/list_agents -c
```

## MySQL Commands
##### Enable Query logs 
```
>SET GLOBAL general_log = 'ON';
>SET GLOBAL slow_query_log = 'ON';
```
  check mysqlroot such as /var/db/mysql

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

## Bind Configuration

##### Disable Zone Transfers (`/etc/named.conf`):
```
allow-transfer {"none";};
```

##### Turn on logging (`/etc/named.conf`):
```
logging {
    channel queries_file {
        file "/var/log/named/queries.log" versions 3 size 5m;
        severity dynamic;
        print-time yes;
    };
    category queries { queries_file; };
};
```

##### Check configuration
```
named-checkconf /etc/named.conf
```


## Web App Security

##### Search for PHP Backdoors

```
$ grep -iR 'c99' /path/to/web/root
$ grep -iR 'r57' /path/to/web/root
$ find /path/to/web/root -name \*.php -type f -print0 | xargs -o grep c99
$ grep -RPn "(passthru|shell_exec|system|base64_decode|fopen|fclose|eval)" /path
```

##### Secure PHP
Edit `php.ini`:

```
upload_tmp_dir = "/var/php_tmp"
session.save_path = "/var/lib/php/sessions"
open_basedir = "/var/www:/var/lib/php/sessions:/var/php_tmp"
file_uploads = Off
allow_url_fopen = Off
disable_functions = "php_uname, getmyuid, getmypid, passthru, leak, listen, diskfreespace, tmpfile, link, ignore_user_abord, shell_exec, dl, set_time_limit, exec, system, highlight_file, source, show_source, fpaththru, virtual, posix_ctermid, posix_getcwd, posix_getegid, posix_geteuid, posix_getgid, posix_getgrgid, posix_getgrnam, posix_getgroups, posix_getlogin, posix_getpgid, posix_getpgrp, posix_getpid, posix, _getppid, posix_getpwnam, posix_getpwuid, posix_getrlimit, posix_getsid, posix_getuid, posix_isatty, posix_kill, posix_mkfifo, posix_setegid, posix_seteuid, posix_setgid, posix_setpgid, posix_setsid, posix_setuid, posix_times, posix_ttyname, posix_uname, proc_open, proc_close, proc_get_status, proc_nice, proc_terminate, phpinfo"
expose_php = Off
error_reporting = E_ALL
display_error = Off
display_startup_errors = Off
```

## Process Limits

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

## Network Security

### Convert All ARP Entries to Static
```
$ arp -an | awk -F' ' '{print $2 $4}' | cut -d'(' -f2 | while IFS=')' read ip mac
> do arp -s $ip $mac
> done
```

### Disable IPv6

##### RHEL:

```
$ sysctl -w net.ipv6.conf.all.disable_ipv6=1
$ sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

##### Debian-based linux:

```
$ cat >> /etc/sysctl.conf <<EOF
> net.ipv6.conf.all.disable_ipv6 = 1
> net.ipv6.conf.default.disable_ipv6 = 1
> net.ipv6.conf.lo.disable_ipv6 = 1
> EOF
$ sysctl -p
```

## Checking Files

##### Find all files and directories with unsafe permissions (including setgid bits):

`$ find / \( -path /proc -o -path /sys -o -path /dev -o -path */rc.d \) -prune -o -perm -755 ! -perm 755`

##### Look at permissions on critical files:

`$ ls -l /etc/passwd /etc/shadow /etc/group ~/.ssh /etc/ssh/sshd_config`

##### Audit all files (and check) - without Git:

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

##### Find files that were modified recently:

`$ find / -mtime -5`

## Install and configure DNSMasq:

```
$ sudo systemctl disable systemd-resolved
$ sudo systemctl stop systemd-resolved
$ echo "nameserver nameserver-ip" > /etc/resolv.conf
$ sudo apt-get install dnsmasq
$ sudo vim /etc/dnsmasq.conf #Have the service listen on the appropriate port and IP
```

## Install and Run Wazuh
### Install Wazuh-Manager

```
$ wget https://packages.wazuh.com/3.x/apt/pool/main/w/wazuh-manager/wazuh-manager_3.8.2-1_amd64.deb
$ dpkg -i wazuh-manager_3.8.2-1_amd64.deb  
Make sure the service is started(it starts by default)
$ cd /var/ossec/bin
$ ./ossec-control start
```
### Install Wazuh-Agent


## Install and Run Lynis
```
$ git clone https://github.com/CISOfy/lynis
$ cd lynis
$ ./lynis audit system
```

## Extra Links

##### Kernel Hardening

- URL: https://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/
- Google: Linux Kernel Security Hardening sysctl

##### PHP Security

- https://www.cyberciti.biz/tips/php-security-best-practices-tutorial.html

