# CCDC

## Nationals 2018

### Linux

#### Needed scripts
* Panolpy-style set root ssh PubKey and kick everyone else out script
* Ansible Tasks:
  * Backup
    * Backup /etc on all systems, move offsite
    * Backup /var/www on all web systems (or other webroot)
  * Firewall
    * Set basic IPTables to allow us to SSH in
    * Set firewall to log and connection limit
    * Set firewall for all SSH boxes to let
    * Set firewall for all web/http boxes
    * Other??
  * Setup
    * Install tripwire & setup
    * Install fail2ban on ssh servers
    * Install mod_evasive and mod_security (?) on web servers
  * Status
    * Run `w` and `netstat -planet` and `ss`, filter and print for all servers
    * Cat access logs and filter for all web servers
    * Cat auth logs and filter for all ssh servers
    * Tripwire status
  * Users
    * Add linuxuser
    * Add list of users from CSV
    * Change all user passwords
    * Change all root passwords
  * Other ??

#### Strategy

##### First Tasks

4 People (all logged on to same server):
  * One person starts securing our base server
  * One person types password list into file, generates SSH PubKey
  * One person types up Panoply-style script to change root passwords and keys (using password list and generated keys)
  * One person types systems into ansible inventory (`/etc/ansible/hosts`)

##### Next Tasks

* Secure MySQL
* Secure Web App admin accounts

#### Notes

### Windows (?)
