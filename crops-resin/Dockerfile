FROM crops/poky
USER root

RUN apt-get update \
    && apt-get install -y npm jq iptables curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://get.docker.com | sh

# Resin requires docker to build. This *must* be a daemon started in the container since the build
# bind mounts directories inside the container into the new container. After the container has
# started use:
#       docker exec -u root <container> dockerd -s vfs -G pokyuser
# The "-G pokyuser" is so that the normal user has permission, the "-s vfs" is a storage driver
# that is slow but works on all filesystems.

USER usersetup
