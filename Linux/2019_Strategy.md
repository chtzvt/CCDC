# 2019 Nationals Strategy

## Starting Off

4 admins:
* 1 Secure local ESXi
* 1 Secure cloud ESXi
* 1 Spray SSH script (root & admin users)
  * Change password
  * IPTables drop all but SSH
  * Manually change passwords on failed boxes
* 1 Login to web apps
  * Move admin directory OR
  * change web admin password

## Key Ideas

* Jumphost - super secure
* SSH remote mount everything - use for:
  * Backups
  * Changing web app passwords
  * Malware scans
  * Tripwire
  * Mass password changes?
* Reliance on tools
  * OSSEC
  * PSSH
  * Ansible

## General Linux Security
* Change passwords (root, sudo users, all users)
* Firewall
* Secure service configuration

## Threat Hunting
* Replaced binaries: `debsums` / `rpm -Va`
* Scheduled tasks: `cat /etc/cron.d/*` / `crontab -l`
* Bad password databases: `cat nsswitch.conf`
* PAM backdoor: `cat /etc/pam.d/*` (esp. `common-auth`)
* Sudoers file: `visudo` / `cat /etc/sudoers.d/*`
* Services: `systemctl` / `service --status-all`
* On boot: `/etc/rc.local`

## Really Good Ideas (from 2018) (need to do something with these - test and document, discard, etc)

* Set permissions on binaries which provide setuid/setgid
  - Find has an option to search files with these bits
  - Should not be accessible to scoring users
  
* UID based firewall rules
  - None of the scoring users need to be able to connect out, period
  
* Restricted Environment for Scoring Server Users
  - Restrict to rbash, set ACL policies to disable access to /bin/bash (they don't need it!)
  - Make it **really** hard to get new files onto the system
    - DISABLE scp
    - Potentially even disable creating new files
    - Possibly also disable making files executable (either at an FS level or perms on chmod)
    - User home directories should be mounted in such a way that disables setuid
    - Possibly disable using python/ruby et al. for these users
    
* limits.conf
  - Super restricted for anything that isn't root or service related
    - Makes attacking shell environments from red team super annoying, but should be permissive enough to pass
    SSH scoring checks
