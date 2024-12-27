# Samba

Containerised samba share that is easy to use

`podman run -it --rm -p 8445:445 -v './share:/share:z' --userns=keep-id:uid=$(id -u),gid=$(id -g) -u root ghcr.io/chen-ky/samba:latest`

- CONFIGPATH=${CONFIGPATH:-'/etc/samba/container-default.conf'}
- UID=${UID:-1000}
- USERNAME=${USERNAME:-'user'}
- PASSWORD
- ALLOW_HOSTS
- DENY_HOSTS
