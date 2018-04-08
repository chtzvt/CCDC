# Strategy

## Initial security (3 minutes)

* Each SSH's onto 2 (pre-assigned) systems with default creds
* Change passwords
  * root
  * `mysql_secure_installation`
  * Web app admin page
* Start backup of `/etc,` web root, MySQL database
* Quick system audit - what else is running? (`netstat`, `ss`, `ps`, `w`)

## Startup Hardening (10-30 minutes)

* Firewall (ingress & egress)
  * Need to print out examples for `PF` (*BSD), `firewalld` (RHEL), `iPF` (Solaris)
* Secure critical services
  * Check bind port
  * Check what user it runs as
  * Check other configuration file options
  * (Web app) Secure PHP

## Automation Setup (10 minutes)

  * Deploy secure ISO on unused laptop to create JumpHost
  * Firewall - only port 22 tcp in and out
  * Setup SSH server and 2FA (google: "google authenticator ssh")
  * Generate ssh keys (4096 bit)
  * Install ansible, mollyguard
  * Create ansible inventory from network map
  * (Optional) Add system aliases to `/etc/host`
  * Start running scripts:
    * Deploy keys
    * Backup `/home` and `/src/` into `/backup`
    * Pull backups from `/backup`, move to flash drive
    * Install fail2ban
  * Type scripts to use later:
    * Get status
    * Change all user passwords

