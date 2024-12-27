# Samba

![GitHub License](https://img.shields.io/github/license/chen-ky/samba)
[![Container Publish](https://github.com/chen-ky/samba/actions/workflows/container-publish.yml/badge.svg)](https://github.com/chen-ky/samba/actions/workflows/container-publish.yml)

Containerised samba share that is easy to use

```sh
podman pull ghcr.io/chen-ky/samba:latest
```

## Running the Container

### Sharing the volume of another container

```sh
podman run --detach --rm --publish 8445:445 \
    --volumes-from=<container_name> \
    --volume '<volume_name>:/share' \
    ghcr.io/chen-ky/samba:latest
```

### Sharing a local folder

```sh
podman run --detach --rm --publish 8445:445 \
    --volume '<local_directory>:/share:z' \
    --env "UID=$(id -u)" \
    --userns=keep-id:uid=$(id -u),gid=$(id -g) \
    --user root \
    ghcr.io/chen-ky/samba:latest
```

## Environment Variables

| Name          | Default Value                       | Description                                                                                                                                                                                                                                                                                                                                 |
| ------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CONFIG_PATH` | `/etc/samba/container-default.conf` | The path of the configuration file in the container to use.                                                                                                                                                                                                                                                                                 |
| `UID`         | 1000                                | The user ID of the content in the share volume.                                                                                                                                                                                                                                                                                             |
| `USERNAME`    | `user`                              | The SMB username.                                                                                                                                                                                                                                                                                                                           |
| `PASSWORD`    |                                     | The password for the SMB user. Randomly generated and printed to stdout on runtime if not provided.                                                                                                                                                                                                                                         |
| `ALLOW_HOSTS` |                                     | A list of hosts to allow, separated by space. Please see [smb.conf (5) manpage](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#HOSTSALLOW) and [host_access (5) manpage](https://linux.die.net/man/5/hosts_access) for accepted values. Allows hosts in the private IP range by default.                                 |
| `DENY_HOSTS`  |                                     | A list of hosts to deny, separated by space. Please see [smb.conf (5) manpage](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html#HOSTSDENY) and [host_access (5) manpage](https://linux.die.net/man/5/hosts_access) for accepted values. Deny any hosts not specified by `ALLOW_HOSTS` by default (`0.0.0.0/0` and `::/0`). |
