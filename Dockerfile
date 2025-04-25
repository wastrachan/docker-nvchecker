FROM python:3.13-alpine

LABEL org.opencontainers.image.title="Docker nvchecker"
LABEL org.opencontainers.image.description="nvchecker on Alpine Linux"
LABEL org.opencontainers.image.authors="Winston Astrachan"
LABEL org.opencontainers.image.source="https://github.com/wastrachan/docker-nvchecker/"
LABEL org.opencontainers.image.licenses="MIT"

ARG NVCHECKER_VERSION="2.15.1"

# Add users before any software to prevent UID/GID conflicts
RUN <<EOF
    set -eux
    addgroup -S -g 101 nvchecker
    adduser -S -H -G nvchecker -u 101 nvchecker
EOF

# Install dependencies
RUN <<EOF
    set -eux
    apk add --update --no-cache --virtual .dependencies \
        gzip \
        libcurl \
        sudo \
        wget
    pip install -U setuptools pip packaging
EOF

# Install nvchecker
ADD https://github.com/lilydjwg/nvchecker/archive/refs/tags/v${NVCHECKER_VERSION}.tar.gz nvchecker.tar.gz
RUN <<EOF
    set -eux
    apk add --update --no-cache --virtual .build-dependencies \
        curl-dev \
        build-base
    mkdir -p /nvchecker
    tar --strip-components=1 -xzvf nvchecker.tar.gz -C /nvchecker
    cd /nvchecker
    pip install .
    rm -rf /nvchecker /nvchecker.tar.gz
    apk del .build-dependencies
EOF

COPY overlay/ /
VOLUME /config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "-u", "nvchecker", "nvchecker", "-c", "/config/nvchecker.toml"]
