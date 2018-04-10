```
# vim /etc/tripwire/twpol.txt
```

```
( rulename = "Call of Time", severity = 100)

{
        /bin               -> $(ReadOnly) (recurse = true) ;
        /boot              -> $(ReadOnly) (recurse = true) ;
        /dev             -> $(ReadOnly) (recurse = true) ;
        /etc              -> $(ReadOnly) (recurse = true) ;
        /home               -> $(ReadOnly) (recurse = true) ;
        /lib               -> $(ReadOnly) (recurse = true) ;
        /media               -> $(ReadOnly) (recurse = true) ;
        /mnt               -> $(ReadOnly) (recurse = true) ;
        /opt               -> $(ReadOnly) (recurse = true) ;
        /root               -> $(ReadOnly) (recurse = true) ;
        /sbin               -> $(ReadOnly) (recurse = true) ;
        /srv               -> $(ReadOnly) (recurse = true) ;
        /tmp               -> $(ReadOnly) (recurse = true) ;
        /usr               -> $(ReadOnly) (recurse = true) ;
        /var               -> $(ReadOnly) (recurse = true) ;
}
```
