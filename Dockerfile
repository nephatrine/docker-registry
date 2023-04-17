FROM nephatrine/nxbuilder:golang AS builder

ARG BUILDTAGS="include_oss include_gcs"
ARG REGISTRY_VERSION=main
ARG REGCLIENT_VERSION=releases/0.4

RUN git -C ${HOME} clone -b "$REGISTRY_VERSION" --single-branch --depth=1 https://github.com/distribution/distribution.git
RUN git -C ${HOME} clone -b "$REGCLIENT_VERSION" --single-branch --depth=1 https://github.com/regclient/regclient.git

RUN echo "====== COMPILE REGISTRY ======" \
 && cd ${HOME}/distribution && go build -trimpath -ldflags "-s -w" -o /usr/bin/registry ./cmd/registry
RUN echo "====== COMPILE REGCLIENT ======" \
 && cd ${HOME}/regclient && make binaries -j4

FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN mkdir /etc/registry
COPY --from=builder /usr/bin/registry /usr/bin/registry
COPY --from=builder /root/regclient/bin/ /usr/local/bin/
COPY --from=builder /root/distribution/cmd/registry/config-example.yml /etc/registry/config-example.yml
COPY override /

RUN echo "====== CONFIGURE REGISTRY ======" \
 && cp /etc/registry/config-example.yml /etc/registry/config.yml \
 && sed -i 's~/var/lib/registry~/mnt/config/data~g' /etc/registry/config.yml \
 && sed -i 's~/etc/registry~/mnt/config/etc/registry~g' /etc/registry/config.yml

EXPOSE 5000/tcp
