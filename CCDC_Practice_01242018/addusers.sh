#!/bin/bash
while IFS= read -r line
do

# For each line of the CSV, pull fields into their own variables
        USERNAME=`echo "$line" | cut -d';' -f1`
        FULLNAME=`echo "$line" | cut -d';' -f2`
        GROUP=`echo "$line" | cut -d';' -f3`
        PASSWD=`echo "$line" | cut -d';' -f4`
# For setting passwords initially, you can do a first run using my little
# 8-character password generator. Just swap $PASSWD for $RANDPASS.
        RANDPASS=`head -n 10 /dev/urandom | sha1sum | cut -d' ' -f1 | cut -c1-8`

# Add users to system/set group, fullname, and password
#       useradd -G $GROUP -c "$FULLNAME" $USERNAME
# Change $PASSWD to $RANDPASS to randomly generate a password for each user
# Otherwise, $PASSWD will correspond to the password entry for that user in the CSV file
#       echo $USERNAME:$PASSWD | chpasswd
#       echo "Password for $USERNAME set to $RANDPASS"

#
#       htpasswd -d -p -b /etc/vsftpd.passwd $USERNAME $RANDPASS
#       mkdir -p /var/vsftpd/$GROUP
#       echo "local_root=/var/vsftpd/$GROUP" >> /etc/vsftpd_users/$USERNAME

# Set passwords for and activate Samba user account
#       (echo $PASSWD; echo $PASSWD) | smbpasswd -s -a

# CSV data will be read line by line from the file users.txt in $CURDIR
done < "./users.txt"
