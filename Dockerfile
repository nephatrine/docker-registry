FROM nephatrine/nxbuilder:alpine AS builder

ARG GOPATH="/usr"
ARG BUILDTAGS="include_oss include_gcs"
ARG REGISTRY_VERSION=main
ARG REGCLIENT_VERSION=releases/0.4

RUN mkdir -p /usr/src/github.com/distribution \
 && git -C /usr/src/github.com/distribution clone -b "$REGISTRY_VERSION" --single-branch --depth=1 https://github.com/distribution/distribution.git
RUN git -C /usr/src clone -b "$REGCLIENT_VERSION" --single-branch --depth=1 https://github.com/regclient/regclient.git

RUN echo "====== COMPILE REGISTRY ======" \
 && cd /usr/src/github.com/distribution/distribution \
 && go build -trimpath -ldflags "-s -w" -o /usr/bin/registry ./cmd/registry
RUN echo "====== COMPILE REGCLIENT ======" \
 && cd /usr/src/regclient \
 && make binaries -j4

FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN mkdir /etc/registry
COPY --from=builder /usr/bin/registry /usr/bin/registry
COPY --from=builder /usr/src/regclient/bin/ /usr/local/bin/
COPY --from=builder /usr/src/github.com/distribution/distribution/cmd/registry/config-example.yml /etc/registry/config-example.yml
COPY override /

RUN echo "====== CONFIGURE REGISTRY ======" \
 && cp /etc/registry/config-example.yml /etc/registry/config.yml \
 && sed -i 's~/var/lib/registry~/mnt/config/data~g' /etc/registry/config.yml \
 && sed -i 's~/etc/registry~/mnt/config/etc/registry~g' /etc/registry/config.yml

EXPOSE 5000/tcp
