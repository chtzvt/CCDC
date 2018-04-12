# Strategy

## Initial security (10 minutes)

* Each SSH into 2 (pre-assigned) systems with default creds
* Change local user passwd (`root` and `grep /etc/passwd | grep sh`)
* Start backup of `/etc,` web root, MySQL database to `/backup`
* Change app passwords
  * `mysql_secure_installation`
  * Web app admin page
* Check Sudoers and `/etc/group`
* Quick system audit - what else is running? (`netstat`, `ss`, `ps`, `w`)

## Startup Hardening (10-30 minutes)

* Firewall (ingress & egress)
  * Need to print out examples for `PF` (*BSD), `firewalld` (RHEL), `iPF` (Solaris)
* Secure critical services
  * Check bind port
  * Check what user it runs as
  * Check other configuration file options
  * Change MySQL web app passwords
  * (Web app) Secure PHP

## Automation Setup (30 minutes)

  * Deploy secure ISO on unused laptop to create JumpHost
  * Follow the installation and configuration procedure in **Jump Host Configuration.md**.
  * Start running scripts:
    * Pull backups from `/backup`, move to flash drive
    * Security: Install fail2ban, check permissions, restrict ssh root access

## Rest of Competition (2 days)

  * Do injects
  * Keep Red Team out
  * Keep services up
  * Win
