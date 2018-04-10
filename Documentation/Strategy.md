# Strategy

## Initial security (10 minutes)

* Each SSH into 2 (pre-assigned) systems with default creds
* Change local user passwd (`root` and `grep /etc/passwd | grep sh`)
* Start backup of `/etc,` web root, MySQL database to `/backup`
* Change app passwords
  * `mysql_secure_installation`
  * Web app admin page
* Quick system audit - what else is running? (`netstat`, `ss`, `ps`, `w`)

## Startup Hardening (10-30 minutes)

* Firewall (ingress & egress)
  * Need to print out examples for `PF` (*BSD), `firewalld` (RHEL), `iPF` (Solaris)
* Install Tripwire
* Secure critical services
  * Check bind port
  * Check what user it runs as
  * Check other configuration file options
  * Change MySQL web app passwords
  * (Web app) Secure PHP

## Automation Setup (30 minutes)

  * Deploy secure ISO on unused laptop to create JumpHost
  * Follow the installation and configuration procedure in **Jump Host Configuration.md**.
  * Type up and run `copy_keys.sh`
  * Create ansible inventory from network map in `/etc/ansible/hosts`
    * Organize by service and OS (e.g. `all`, `webservers`, `ssh`, `debain`, `rhel`, `solaris`, `bsd`, ...)
  * Install python on all FreeBSD:
    * `pkg install -y python27`
    * `[freebsd:vars]\nansible_python_interpreter=/usr/local/bin/python2.7` in `/etc/ansible/hosts`
  * Install `python-simplejson` on CentOS
  * Start running scripts:
    * Backup `/home` and `/src/` into `/backup`
    * Pull backups from `/backup`, move to flash drive
    * Install fail2ban
    * `chattr` all of `/etc` and web root
  * Type scripts to use later:
    * Get status
    * Change all user passwords

## Rest of Competition (2 days)

  * Do injects
  * Keep Red Team out
  * Keep services up
  * Win
