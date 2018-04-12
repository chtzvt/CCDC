for L in `ls /`; do echo "/$L -> /$(ReadOnly) (recurse = true);">>/etc/tripwire/twpol.txt; done
