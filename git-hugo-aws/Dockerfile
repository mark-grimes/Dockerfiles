FROM ubuntu:14.04


# Install git straight from apt
RUN apt-get update -y \
    && apt-get install -y git

# Install aws and all its dependencies
RUN apt-get install -y git python-pip libyaml-dev python2.7-dev \
    && pip install awscli

# Download and install Hugo
ADD https://github.com/spf13/hugo/releases/download/v0.20.2/hugo_0.20.2-64bit.deb /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb