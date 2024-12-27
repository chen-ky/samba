#!/bin/sh

set -e

CONFIGPATH=${CONFIGPATH:-'/etc/samba/container-default.conf'}
UID=${UID:-1000}
USERNAME=${USERNAME:-'user'}
echo Username: "$USERNAME"
if [ -z "$PASSWORD" ]
then
    PASSWORD=$(head -c 16 /dev/random | base64 | tr -d -c 'a-zA-Z0-9')
    echo Password: "$PASSWORD"
fi

if ! getent passwd "$UID" > /dev/null;
then
    # -s SHELL        Login shell
    # -H              Don't create home directory
    # -D              Don't assign a password
    # -u UID          User id
    adduser -s /sbin/nologin -H -D -u "$UID" "$USERNAME"
    echo "$USERNAME":"$PASSWORD" | chpasswd > /dev/null 2>&1
fi

# -s                   use stdin for password prompt
# -a                   add user
printf '%s\n%s\n' "$PASSWORD" "$PASSWORD" | smbpasswd -s -a "$USERNAME" > /dev/null

USERNAME=$USERNAME perl -p -i -e 's/^\s*valid users\s*\=\s*nobody\s*$/   valid users \= $ENV{USERNAME}\n/g' '/etc/samba/container-default.conf'

echo '---- smbd Config ----'
yes | testparm "$CONFIGPATH"
echo '---- Starting smbd ----'
smbd --foreground --configfile="$CONFIGPATH" --debug-stdout --debuglevel=1 --no-process-group "$@"
