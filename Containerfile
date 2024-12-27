FROM docker.io/library/alpine:edge

RUN apk add --no-cache perl samba

COPY conf/ /etc/samba/
COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/share" ]

RUN chmod u+x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
