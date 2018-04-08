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

## Automation Setup (20 minutes)

  * Deploy secure ISO on unused laptop to create JumpHost
  * Install `molly-guard`, `oathtool`, `ansible`, `htop`, `git`
  * Start installing `xubuntu-deskptop` in background
  * Remove (and purge) `avahi-daemon`, `cups`, `gvfs`
  * Install `libpam-google-authenticator`
    * Do you want authentication tokens to be time-based (y/n) y
    * Do you want me to update your "~/.google_authenticator" file (y/n) y
    * Do you want to disallow multiple uses of the same authentication token? ... (y/n) n
    * By default, tokens are good for 30 seconds and in order to compensate for
possible time-skew between the client and the server ... (y/n) n
    * Do you want to enable rate-limiting (y/n) y
    * Follow rest of steps from DigitalOcean article, starting from step 2 (google: "google authenticator ssh")
    * Don't comment `@include common-auth` in `/etc/pam.d/sshd`
    * Use `AuthenticationMethods publickey,password keyboard-interactive`
    * Write down recovery keys on paper
  * Configure `molly-guard`
    * Set `ALWAYS_QUERY_HOSTNAME` to `yes` in `/etc/molly-guard/rc`
  * Configure `oathtool`
    * Put in `/usr/local/bin/token`: `oathtool --base32 --totp "<secret_key>"`
  * Firewall - only port 22 tcp in and out
  * Generate ssh keys (4096 bit)
    * Copy ssh keys to flash drive
  * Create ansible inventory from network map
  * (Optional) Add system aliases to `/etc/host`
  * (Optional) Replace Firefox with Chrome (need to install `libappindicator1` and `libindicator7` first)
  * Start running scripts:
    * Deploy keys
    * Backup `/home` and `/src/` into `/backup`
    * Pull backups from `/backup`, move to flash drive
    * Install fail2ban
  * Type scripts to use later:
    * Get status
    * Change all user passwords

