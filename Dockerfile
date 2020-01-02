FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

ARG GOPATH="/usr"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add --virtual .build-registry build-base git go \
 \
 && echo "====== COMPILE REGISTRY ======" \
 && cd /usr/src \
 && go get -u github.com/docker/distribution/cmd/registry \
 && mkdir /etc/registry \
 && cp github.com/docker/distribution/cmd/registry/config-example.yml /etc/registry/config-example.yml \
 && cp /etc/registry/config-example.yml /etc/registry/config.yml \
 && sed -i 's~/var/lib/registry~/mnt/config/data/registry~g' /etc/registry/config.yml \
 && sed -i 's~/etc/registry~/mnt/config/etc/registry~g' /etc/registry/config.yml \
 \
 && echo "====== CLEANUP ======" \
 && apk del --purge .build-registry \
 && cd /usr/src && rm -rf /tmp/* /usr/pkg/* /usr/src/* /var/cache/apk/*

ENV REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/mnt/config/data/registry

EXPOSE 5000/tcp
COPY override /
