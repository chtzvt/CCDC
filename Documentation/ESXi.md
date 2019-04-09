# ESXi Security Guide

### Recoverable lockdown mode

##### Setup:
* Change VPX user's shell to '/bin/sh'
* Drop SSH keys on VPX user

```
$ vi /etc/ssh/sshd_config
$ # ChallengeResponseAuthentication yes
$ grep authorized_keys /etc/ssh/sshd_config
$ mkdir vpxuser  # in the location seen above
$ vi authorized_keys  # put keys in here
$ chown vpxuser:vpxuser authorized_keys
```
* verify it works by logging in with ssh

##### To put in lockdown mode:
```
$ vim-cmd -U dcui vimsvc/auth/lockdown_mode_enter
```

##### To exit:
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


##### List Snapshots for a VM:
```
vim-cmd vmsvc/snapshot.get VMID
```

##### SnapShot VM without memory:
```
vim-cmd vmsvc/snapshot.create VMID "Snap_Name" "Snap_Description" 0 0
```

##### SnapShot VM with memory (recommended):
```
vim-cmd vmsvc/snapshot.create VMID "Snap_Name_Time" "Snap_Description_Time" 1 1
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
