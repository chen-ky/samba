# Samba

Containerised samba share that is easy to use

`podman run -it --rm -p 8445:445 -v './share:/share:z' --userns=keep-id:uid=$(id -u),gid=$(id -g) -u root localhost/samba:latest`
