# ESXi Security Guide
## ESXi 5.x:

### Recoverable lockdown mode

##### Setup:
* Change VPX user's shell to something usable
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

## ESXi 6.x:

Add users to exception list:
1. Procedure
2. Browse to the host in the vSphere Web Client inventory.
3. Click Configure.
4. Under System, select Security Profile.
5. In the Lockdown Mode panel, click Edit.
6. Click Exception Users and click the plus icon to add exception users.


Note: Still Needs to be Tested against 6.0 and 6.5

##### Get VMIDs:
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

##### SnapShot VM:
```
vim-cmd vmsvc/snapshot.create 23 "Snap_Name_Time" "Snap_Description_Time" 0 0
```

