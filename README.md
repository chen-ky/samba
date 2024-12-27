# Samba

Containerised samba share that is easy to use

`podman run -it --rm -p 8445:445 -v './share:/share:z' --userns=keep-id:uid=$(id -u),gid=$(id -g) -u root ghcr.io/chen-ky/samba:latest`

## Environment Variables

| Name          | Default Value                       | Description                                                                                                                                                                                                                                                                                                                                 |
| ------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CONFIG_PATH` | `/etc/samba/container-default.conf` |                                                                                                                                                                                                                                                                                                                                             |
| `UID`         | 1000                                | The user ID of the content in the share volume.                                                                                                                                                                                                                                                                                             |
| `USERNAME`    | `user`                              | The SMB user.                                                                                                                                                                                                                                                                                                                               |
| `PASSWORD`    |                                     | The password for the SMB user. Randomly generated and printed to stdout on runtime if not provided,                                                                                                                                                                                                                                         |
| `ALLOW_HOSTS` |                                     | A list of hosts to allow, separated by space. Please see [smb.conf (5) manpage](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#HOSTSALLOW) and [host_access (5) manpage](https://linux.die.net/man/5/hosts_access) for accepted values. Allows hosts from in the private IP range by default.                            |
| `DENY_HOSTS`  |                                     | A list of hosts to deny, separated by space. Please see [smb.conf (5) manpage](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#HOSTSDENY) and [host_access (5) manpage](https://linux.die.net/man/5/hosts_access) for accepted values. Deny any hosts not specified by `ALLOW_HOSTS` by default (`0.0.0.0/0` and `::/0`). |
