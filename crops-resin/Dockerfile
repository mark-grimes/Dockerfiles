FROM crops/poky
USER root

RUN apt-get update \
    && apt-get install -y npm jq iptables curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://get.docker.com | sh

# Resin requires docker to build. Use docker-in-docker as described in https://hub.docker.com/_/docker/
# e.g.
#   docker run -d --privileged --name docker-in-docker docker:stable-dind --storage-driver overlay2
# Then make sure you use "--link docker-in-docker:docker" when starting this container
ENV DOCKER_HOST=docker

USER usersetup
