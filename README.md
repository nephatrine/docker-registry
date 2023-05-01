[Git](https://code.nephatrine.net/NephNET/docker-registry/src/branch/master) |
[Docker](https://hub.docker.com/r/nephatrine/docker-registry/) |
[unRAID](https://code.nephatrine.net/nephatrine/unraid-containers)

# Docker Registry

This docker image contains a Docker Registry server to self-host your own
docker registry.

To secure this service, we suggest a separate reverse proxy server, such as an
[NGINX](https://nginx.com/) container.

- [Alpine Linux](https://alpinelinux.org/) w/ [S6 Overlay](https://github.com/just-containers/s6-overlay)
- [Docker Registry](https://docs.docker.com/registry/)

You can spin up a quick temporary test container like this:

~~~
docker run --rm -p 5000:5000 -it nephatrine/docker-registry:latest /bin/bash
~~~

## Docker Tags

- **nephatrine/docker-registry:latest**: Registry Main / Alpine Latest

## Configuration Variables

You can set these parameters using the syntax ``-e "VARNAME=VALUE"`` on your
``docker run`` command. Some of these may only be used during initial
configuration and further changes may need to be made in the generated
configuration files.

- ``PUID``: Mount Owner UID (*1000*)
- ``PGID``: Mount Owner GID (*100*)
- ``TZ``: System Timezone (*America/New_York*)

## Persistent Mounts

You can provide a persistent mountpoint using the ``-v /host/path:/container/path``
syntax. These mountpoints are intended to house important configuration files,
logs, and application state (e.g. databases) so they are not lost on image
update.

- ``/mnt/config``: Persistent Data.

Do not share ``/mnt/config`` volumes between multiple containers as they may
interfere with the operation of one another.

You can perform some basic configuration of the container using the files and
directories listed below.

- ``/mnt/config/etc/crontabs/<user>``: User Crontabs. [*]
- ``/mnt/config/etc/registry/config.yml``: Registry Configuration. [*]
- ``/mnt/config/etc/logrotate.conf``: Logrotate Global Configuration.
- ``/mnt/config/etc/logrotate.d/``: Logrotate Additional Configuration.

**[*] Changes to some configuration files may require service restart to take
immediate effect.**

## Network Services

This container runs network services that are intended to be exposed outside
the container. You can map these to host ports using the ``-p HOST:CONTAINER``
or ``-p HOST:CONTAINER/PROTOCOL`` syntax.

- ``5000/tcp``: Registry Server. This is the server interface.
