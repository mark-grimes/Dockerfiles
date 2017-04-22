FROM publysher/hugo

# The base image already has git and hugo, so just need to add AWS

# Install dependencies
RUN apt-get update -y \
    && apt-get install -y python-pip \
    && pip install awscli