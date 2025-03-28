#!/bin/sh

set -e

CONFIG_PATH=${CONFIG_PATH:-'/etc/samba/container-default.conf'}
UID=${UID:-1000}
USERNAME=${USERNAME:-'user'}
echo Username: "$USERNAME"
if [ -z "$PASSWORD" ]
then
    PASSWORD=$(head -c 16 /dev/random | base64 | tr -d -c 'a-zA-Z0-9')
    echo Password: "$PASSWORD"
fi

if [ -n "$ALLOW_HOSTS" ]
then
    echo hosts allow = "$ALLOW_HOSTS" > /etc/samba/whitelist.conf
fi

if [ -n "$DENY_HOSTS" ]
then
    echo hosts deny = "$DENY_HOSTS" > /etc/samba/blacklist.conf
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
yes | testparm "$CONFIG_PATH"
echo '---- Starting smbd ----'
smbd --foreground --configfile="$CONFIG_PATH" --debug-stdout --debuglevel=1 --no-process-group "$@"
