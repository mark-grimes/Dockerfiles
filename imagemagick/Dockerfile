FROM debian:jessie

RUN apt-get update \
    && apt-get install -y cmake imagemagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
