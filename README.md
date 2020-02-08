[Git](https://code.nephatrine.net/nephatrine/docker-registry) |
[Docker](https://hub.docker.com/r/nephatrine/docker-registry/) |
[unRAID](https://code.nephatrine.net/nephatrine/unraid-containers)

[![Build Status](https://ci.nephatrine.net/api/badges/nephatrine/docker-registry/status.svg?ref=refs/heads/master)](https://ci.nephatrine.net/nephatrine/docker-registry)

# Docker Registry

This docker image contains a Docker Registry server to self-host your own
docker registry.

**YOU WILL NEED TO USE A SEPARATE REVERSE PROXY SERVER TO SECURE THIS SERVICE.
SEE THE [DOCUMENTATION](https://docs.docker.com/registry/recipes/nginx/) FOR
MORE DETAILS ON HOW TO CONFIGURE SUCH A PROXY.**

- [Docker Registry](https://docs.docker.com/registry/)

You can spin up a quick temporary test container like this:

~~~
docker run --rm -p 5000:5000 -it nephatrine/docker-registry:latest /bin/bash
~~~

## Docker Tags

- **nephatrine/drone-server:testing**: Registry Master (Alpine Edge)
- **nephatrine/drone-server:latest**: Registry v2.7 (Alpine v3.11)
- **nephatrine/drone-server:2.7**: Registry v2.7 (Alpine v3.10)

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
