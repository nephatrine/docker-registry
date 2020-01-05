FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

ARG GOPATH="/usr"

RUN echo "====== COMPILE REGISTRY ======" \
 && mkdir /etc/registry \
 && apk add --virtual .build-registry build-base git go \
 && cd /usr/src \
 && go get -u github.com/docker/distribution/cmd/registry \
 && cp github.com/docker/distribution/cmd/registry/config-example.yml /etc/registry/config-example.yml \
 && cp /etc/registry/config-example.yml /etc/registry/config.yml \
 && sed -i 's~/var/lib/registry~/mnt/config/data/registry~g' /etc/registry/config.yml \
 && sed -i 's~/etc/registry~/mnt/config/etc/registry~g' /etc/registry/config.yml \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-registry && rm -rf /var/cache/apk/*

ENV REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/mnt/config/data/registry

EXPOSE 5000/tcp
COPY override /
