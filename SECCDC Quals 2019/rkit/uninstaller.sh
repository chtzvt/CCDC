#!/bin/bash

chattr -i /usr/local/bin/pan_dns
rm /usr/local/bin/pan_dns
rm /etc/init.d/pan_dns

chattr -i /usr/local/bin/pan_ntp
rm /usr/local/bin/pan_ntp
rm /etc/init.d/pan_ntp

chattr -i /usr/local/bin/pan_upgrader
rm /usr/local/bin/pan_upgrader
rm /etc/init.d/pan_upgrader

chattr -i /etc/cron.d/pan-threat-updater
rm /etc/cron.d/pan-threat-updater

chattr -i /usr/local/bin/pan_slogger
rm /usr/local/bin/pan_slogger

chattr -i /usr/local/bin/pan_threat_updater
rm /usr/local/bin/pan_threat_updater

chattr -i /var/appweb/htdocs/composer.php
rm /var/appweb/htdocs/composer.php

chattr -i /opt/panrepo/pending/rkit.tgz
rm /opt/panrepo/pending/rkit.tgz

