# ESXi Security Guide

## Configure ReadOnly Vsphere Client Access(5.5 and lower):
1. Go to the view option in the vSphere Client and select "Administration" and then select "Roles".
2. Select "Add a Role" and enter the roll name "CCDC Role".
3. Click on the "Virtual Machine" permission.
4. Click on the "Interactaction" permission.
5. Grant permission to "ConsoleInteract" and "Power On".
6. Go back to the "Snapshot Managment" Permission under "Virtual Machine" and allow permission to Create Snapshots.
7. Switch views to the inventory tab. Under the Local Users & Groups tab, right click to add a new user.
8. Create a user with the name "readonly" and a password from the password sheet.
9. Switch to the Permissions Tab
10. Right click to Add Permission. Select the user "readonly" and select the "ccdc role".
11. Click the "OK" button at the bottom.

## Configure ReadOnly VSphere Web Access (6.0+):

1. Browse to the manage option in the vSphere Web Client.
2. Under Security and Users, select Users.
3. Click "Add User" and create a user with the name "readonly" and a password from the password sheet.
4. Under Security and Users, select Roles.
5. Select "Add a Role".
6. Enter the roll name "CCDC Role".
7. Click on the "Virtual Machine" permission.
8. Click on the "Interact" permission.
9. Grant permission to "CreateScreenshot" and "ConsoleInteract".
10. Go to the Host option in the vSphere Web Client.
11. Click the "Actions" drop down.
12. Select the "Permissions" option.
13. Click "Add User" and select the user "readonly" and select the "ccdc role".
14. Click the "Add User" option at the bottom.

### ESXi Firewall Strategy:
* Set the firewall to only allow one IP to ssh in
```
$ esxcli network firewall set -d t #Pass Through all traffic(insecure)
$ esxcli network firewall ruleset allowedip list --ruleset-id sshServer #Delete other IPs in here
$ esxcli network firewall ruleset set --ruleset-id sshServer --allowed-all false 
$ esxcli network firewall ruleset allowedip add --ruleset-id sshServer --ip-address $martin_ip
$ esxcli network firewall set -d f
```

* Set the firewall to only allow our teams range to use VSphere Web/Client Access
```
$ esxcli network firewall set -d t #Pass Through all traffic(insecure)
$ esxcli network firewall ruleset allowedip list #Delete other IPs in here
$ esxcli network firewall ruleset set -r vSphereClient --allowed-all f
$ esxcli network firewall ruleset set -r webAccess --allowed-all f #6.0 and up
$ esxcli network firewall ruleset allowedip add -r vSphereClient -i $martin_ip
$ esxcli network firewall ruleset allowedip add -r webAccess -i $martin_ip
$ esxcli network firewall set -d f
```

* Listing the ruleset names:
```
$ esxcli network firewall ruleset list
```

* Remove an IP from a ruleset:
```
$ esxcli network firewall ruleset allowedip remove --ruleset-id sshServer --ip-address $ip_to_remove
```

### Recoverable lockdown mode

##### Setup:
* Change VPX user's shell to '/bin/sh'
```
$ vi /etc/passwd
```

* Change SSH KeyPath in /etc/ssh/sshd_config
```
$ vi /etc/ssh/sshd_config
Look for AuthorizedKeysFile and change path to /etc/ssh/new-keys-%u/authorized_keys
```

* Change SSH Port in /etc/ssh/sshd_config
```
$ vi /etc/ssh/sshd_config
Look for Port and change port to 9000
```

* Drop SSH keys on VPX user
```
$ mkdir /etc/ssh/new-keys-vpxuser  # in the location seen above
$ vi /etc/ssh/new-keys-vpxuser/authorized_keys  # put keys in here
```
* verify it works by logging in with ssh (From host that has the ssh keypair)
```
$ ssh vpxuser@ESX_IP
```

##### To put in lockdown mode:
```
$ vim-cmd -U dcui vimsvc/auth/lockdown_mode_enter
```

##### To kill all ssh sessions:
```
$ pkill sshd
```

##### To exit lockdoown mode:
```
$ vim-cmd -U dcui vimsvc/auth/lockdown_mode_exit
```

## Google Authenticator
https://labs.vmware.com/flings/esxi-google-authenticator#instructions

```
$ esxcli software vib install --no-sig-check -f -v /esx_google-authenticator_1.0.0-0.vib
```
```
$ sed -i -e ‘3iauth required pam_google_authenticator.so\’ /etc/pam.d/sshd
```
```
$ sed -i -e ‘3iauth required pam_google_authenticator.so\’ /etc/pam.d/login
```

##### Remove users from exception list:
1. Browse to the host in the vSphere Web Client inventory.
2. Click Configure.
3. Under System, select Security Profile.
4. In the Lockdown Mode panel, click Edit.
5. Click Exception Users and remove users from the list.


##### Get VMID's:
```
$ vim-cmd vmsvc/getallvms
```
##### SnapShot all VMs:
```
$ for vm in $(vim-cmd vmsvc/getallvms | awk '{print $1}');do vim-cmd vmsvc/snapshot.create $vm "snapshot" snapshot; done 
```
##### SnapShot VM without memory(recommended for 5.5):
```
vim-cmd vmsvc/snapshot.create VMID "Snap_Name" "Snap_Description"
```

##### SnapShot VM with memory:
```
vim-cmd vmsvc/snapshot.create VMID "Snap_Name_Time" "Snap_Description_Time" 1 1
```

##### List Snapshots for a VM:
```
vim-cmd vmsvc/snapshot.get VMID
```


##### Restore VM Snapshot:
```
vim-cmd vmsvc/snapshot.revert VMID 1 0

First Number: SnapshotID
Second Number: powerOff state (please always do 0.)
```
##### Kick People out of VSphere:
```
/etc/init.d/hostd restart
```

##### Get the current state of a virtual machine by running this command:
```
$ vim-cmd vmsvc/power.getstate VMID
```

##### Shutdown VM:
```
$ vim-cmd vmsvc/power.shutdown VMID
```

##### PowerOff VM:
```
vim-cmd vmsvc/power.off VMID
```

##### List Unsigned VMkernel modules in ESXi:
```
esxcli software vib list
```

