# Strategy

## Initial security (10 minutes)

* Each SSH's onto 2 (pre-assigned) systems with default creds
* Start backup of `/etc,` web root, MySQL database
* Change passwords
  * root
  * `mysql_secure_installation`
  * Web app admin page
* Quick system audit - what else is running? (`netstat`, `ss`, `ps`, `w`)

## Startup Hardening (10-30 minutes)

* Firewall (ingress & egress)
  * Need to print out examples for `PF` (*BSD), `firewalld` (RHEL), `iPF` (Solaris)
* Secure critical services
  * Check bind port
  * Check what user it runs as
  * Check other configuration file options
  * (Web app) Secure PHP

## Automation Setup (20 minutes)

  * Deploy secure ISO on unused laptop to create JumpHost
  * Follow the installation and configuration procedure in **Jump Host Configuration.md**.
  * Create ansible inventory from network map  
  * Start running scripts:
    * Deploy keys
    * Backup `/home` and `/src/` into `/backup`
    * Pull backups from `/backup`, move to flash drive
    * Install fail2ban
  * Type scripts to use later:
    * Get status
    * Change all user passwords
