FROM python:3.11-alpine
LABEL maintainer="Winston Astrachan"
LABEL description="nvchecker on Alpine Linux"
ARG NVCHECKER_VERSION="2.9"

# Add users before any software to prevent UID/GID conflicts
RUN addgroup -S -g 101 nvchecker; \
    adduser -S -H -G nvchecker -u 101 nvchecker

# Install dependencies
RUN set -eux; \
    apk add --update --no-cache --virtual .dependencies \
        gzip \
        libcurl \
        sudo \
        wget \
    ; \
    pip install -U setuptools pip packaging

# Install nvchecker
ADD https://github.com/lilydjwg/nvchecker/archive/refs/tags/v${NVCHECKER_VERSION}.tar.gz nvchecker.tar.gz
RUN set -eux; \
    apk add --update --no-cache --virtual .build-dependencies \
        curl-dev \
        build-base \
    ; \
    mkdir -p /nvchecker; \
    tar --strip-components=1 -xzvf nvchecker.tar.gz -C /nvchecker; \
    cd /nvchecker; \
    touch nvchecker_source/__init__.py; \
    python3 setup.py install; \
    rm -rf /nvchecker /nvchecker.tar.gz; \
    apk del .build-dependencies;

COPY overlay/ /
VOLUME /config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "-u", "nvchecker", "nvchecker", "-c", "/config/nvchecker.toml"]
