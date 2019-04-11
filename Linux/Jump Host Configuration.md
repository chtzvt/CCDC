# Jump Host Configuration

## Initial Setup :frog::100:

### Basic Setup

  - Download and install a recent LTS release of Ubuntu Server. If applicable,
  provision CPU, RAM, and disk space in amounts that would be suitable for an active, multi-user system.

  - Select **only** the Core Utilities and OpenSSH packages to be installed.

  - Appropriately configure the system HTTP proxy for the competition environment (You will be prompted by the installer to provide this).

  - While installing, create the user `toads` with a randomly chosen password from the sheet.

### Installing Misc. Dependencies

`sudo apt-get update && sudo apt-get -y install libpam-google-authenticator molly-guard pssh ansible oathtool mysql-client sshpass sshfs`

### Installing a Desktop Environment

The following command will install the Xubuntu desktop environment, which is based on XFCE. It will also
remove superfluous packages that could potentially increase the host's attack surface (Avahi, CUPS, and network discovery services):

`sudo apt-get install xubuntu-desktop libappindicator1 libindicator7 && sudo apt-get remove --purge avahi-daemon cups gvfs`


_Note: It is recommended that this be run only after system-critical packages and updates have
been installed. You may also want to consider running this in a `screen` session, as the install process for desktop environments is lengthy._

### Final System Upgrades

The following will upgrade the system's installed packages and automatically remove any orphaned dependencies.

`sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get autoremove --purge`

---

## Host Configuration

### SSH Configuration

Update `/etc/ssh/sshd_config` accordingly to reflect the following configuration options:

```
PermitRootLogin no
AllowUsers toads
PasswordAuthentication yes
PubkeyAuthentication no
```

You may optionally install anti-brute forcing measures such as `fail2ban`, but you should note that
Google Authenticator has a facility for such rate limiting built-in.

Additionally, add the following to `/home/toads/.ssh/config` and `/etc/ssh/ssh_config`:

```
Host *
  ForwardX11 no
  ForwardAgent no
```

This configuration will globally disable SSH agent forwarding, which will reduce the likelihood of key compromise.

Finally, you'll need to type up and run `copy_keys.sh` to copy your jump host's public keys to each of your managed servers.
Additionally, you'll want to type up and run the `mount_sshfs.sh` script in order to connect each system's root filesystem
mounts.

### SSHFS Options

Run the following:

`echo "user_allow_other" | sudo tee -a /etc/fuse.conf`

### Google Authenticator

After installing `libpam-google-authenticator`, run `google-authenticator` as the user to be exposed via SSH and follow the prompts accordingly:

  * _Do you want authentication tokens to be time-based? (y/n)_ **y**

  * *Do you want me to update your "~/.google\_authenticator" file? (y/n)* **y**

  * _Do you want to disallow multiple uses of the same authentication token? [...]_ (y/n) **n**
    
    - We can permit token reuse, as it is only a second factor. As the jump box is a shared resource,
    Google authenticator will be providing session tokens for a number of members on the team, so reuse
    allows multiple sessions to be opened at once.
    
    
  * _By default, tokens are good for 30 seconds and in order to compensate for possible time-skew [...]_ (y/n) **n**

    - Shorter windows mean that less valid tokens are active within the same window. Refusing this prompt
    should keep this to a minimum, with only 3 active codes in a single 1:30 frame of time.
  
  
  * _Do you want to enable rate-limiting? (y/n)_ **y**
  
Follow rest of steps from DigitalOcean article _(google keywords: "google authenticator ssh")_, starting from Step 2:

  * **Don't** comment `@include common-auth` in `/etc/pam.d/sshd`
    
    - We need this to ensure SSH still prompts for passwords. Otherwise, you'll be able to log in using *only* a TOTP token,
    which isn't secure enough.
    
  
  * In place of the article's provided SSH configuration for authentication methods, use the following:
  
    - `AuthenticationMethods password keyboard-interactive`
    
      - This allows authentication to the Jump Box's SSH server using either a public key or a combination of password and token. Note that you
      *will* need to update this if you want to enable authentication via other methods.
  
  
  * Write down backup tokens on paper (Alternatively, these can be extracted from `~/.google_authenticator`)
```

------------------------      ------------------------      ------------------------

------------------------      ------------------------      ------------------------

------------------------      ------------------------      ------------------------

```
After you have completed configuring Google Authenticator, verify and test the installation using `ssh toads@localhost`.


### Configure Oathtool

Oathtool provides a local mechanism for generating TOTP tokens on the local machine. As the Jump
Box will be shared among multiple teammates, it's important to provide a global mechanism for
dispensing these tokens, for the sake of convenience.

Write the following to `/usr/local/bin/token`:

```
#!/usr/bin/env bash
oathtool --base32 --totp "((secret key goes here))"
```

Finally, `chmod +x /usr/local/bin/token`


### SSH Key Generation

Generate a 4096 bit SSH keypair, which will be used to manage
our fleet of servers. Optionally encrypt this key with a passphrase **AFTER** conferring
with your teammates.

`ssh-keygen -b 4096`

Save this keypair for the local user from which Ansible scripts will be launched (`toads`, in this case). The keypair
should additionally be backed up to some kind of removable media.


### Molly-Guard

Molly-guard provides an important mechanism to prevent unintentional shutdowns of the host machine.
As the Jump Box is a shared resource, this protection is vital. The following configuration will ensure that Molly-guard remains active for any open tty:

  * Set `ALWAYS_QUERY_HOSTNAME` to `true` in `/etc/molly-guard/rc`

### Tripwire

We want to use Tripwire to scan all the mounted SSH systems for changes.

```
apt install tripwire
```
Enter site and local passphrases when prompted.

Then, run `procedually_generate_tripwire_policy.sh`.
```
twadmin -m P ~/twpol.txt
tripwire --init
```

### Firewall

- As the Jump Box will be used purely for configuration management, allow only port 22 tcp in and out.

- It is recommended that ARP entries be frozen at some point in time.

  - _Note: If you have installed a web server on this machine, you will need to update the system firewall accordingly_

### Ansible

Open the `/etc/ansible/hosts` file:
  * Add `[all:vars] ansible_user=admin` at top of file
  * Look through /etc/hosts and add all of the servers to the appropriate categories
    * Put all servers under the `[all]` header
    * Put web servers under the `[web]` header
    * Put ssh servers under the `[ssh]` header
    * Put debian-based servers under the `[debian]` header
    * Put RHEL-based servers under the `[rhel]` header
    * So on and so forth

Some *BSD systems may not have python installed:
  * Run `pkg install -y python27` on *BSD servers
  * Add `[freebsd:vars] ansible_python_interpreter=/usr/local/bin/python2.7` to `/etc/ansible/hosts`

Other servers (such as CentOS) may not have `python-simplejson` installed:
  * Install `python-simplejson` using yum, apt, etc

Database servers will need MySQL python packages installed:
  * Fedora: `yum install MySQL-python`
  * Debian/Ubuntu: `apt-get install python-mysqldb`


### Configure External Media

More likely than not, some kind of removable (external) media will be attached to the system for the purpose
of secure backups. This is very important, especially in a hostile environment where the possibility of host
compromise remains real, though (hopefully) unlikely.

Please refer to the Linux knowledge base for more information about formatting file systems, creating mount points,
and mounting/unmounting devices.


### Optional Configuration

  * Replace Firefox with Chrome
