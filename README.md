# CCDC Strategy and Documentation

## A note on the enclosed information
This information is **HIGHLY-CONFIDENTIAL**. Period. Do not share it with *ANYONE* outside of the club. No Normies allowed (Ree).

## Nationals 2018

### Linux

#### Needed scripts
* Panolpy-style set root ssh PubKey and kick everyone else out script
* Ansible Tasks:
  * Backup
    * Backup /home and /srv on all systems
  * Firewall
    * Set firewall to log and connection limit
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

### Windows

### Needed Items
* Add existing scripts, including but not limited to:
  * Bulk import users
  * Bulk change passwords
  * Registry modifications
  * etc.

* Documentation on Nationals/rare services like Hmail, openssh, etc.

* 30 Minute strategy
