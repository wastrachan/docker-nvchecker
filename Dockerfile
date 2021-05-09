FROM alpine:latest
LABEL maintainer="Winston Astrachan"
LABEL description="Software on Alpine Linux"

# Add users before any software to prevent UID/GID conflicts
RUN addgroup -S -g 101 software; \
    adduser -S -H -G software -u 101 software

RUN set -eux; \
    apk add --update --no-cache \
        software \
    ; \
    mkdir /config

COPY overlay/ /
VOLUME /config
EXPOSE 80/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/software", "-c", "/config/config.yml"]
