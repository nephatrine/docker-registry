FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

ARG REGISTRY_VERSION=release/2.7
ARG GOPATH="/usr"

RUN echo "====== COMPILE REGISTRY ======" \
 && mkdir /etc/registry \
 && apk add python3 \
 && apk add --virtual .build-registry build-base git go \
 && mkdir -p /usr/src/github.com/docker \
 && git -C /usr/src/github.com/docker clone -b "$REGISTRY_VERSION" --single-branch --depth=1 https://github.com/docker/distribution.git \
 && cd /usr/src && go install github.com/docker/distribution/cmd/registry \
 && cp github.com/docker/distribution/cmd/registry/config-example.yml /etc/registry/config-example.yml \
 && cp /etc/registry/config-example.yml /etc/registry/config.yml \
 && sed -i 's~/var/lib/registry~/mnt/config/data~g' /etc/registry/config.yml \
 && sed -i 's~/etc/registry~/mnt/config/etc/registry~g' /etc/registry/config.yml \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-registry && rm -rf /var/cache/apk/*

ENV REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/mnt/config/data
ENV REGISTRY_DATA_DIR=${REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY}/docker/registry/v2
COPY override /

EXPOSE 5000/tcp