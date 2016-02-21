FROM ubuntu:14.04

# Set the root password to something I know
RUN echo "root:rootpassword" | chpasswd

# Install dependencies
RUN apt-get update -y \
    && apt-get install -y cmake curl git g++ libboost1.55-all-dev libssl-dev
# Install docker. Note this will require running the container with 
# "-v /var/run/docker.sock:/var/run/docker.sock" to be useful.
RUN apt-get install -y docker.io

# Personal preference, but I much prefer someone checking I'm not accidentally
# overwriting files. This can always be overruled with a "-f" anyway.
RUN echo "alias cp='cp -i'\nalias mv='mv -i'\nalias rm='rm -i'" >> /etc/skel/.bash_aliases

# Need a more recent version of Emscripten than Ubuntu 14.04 provides,
# so install the portable sdk. These are the packages listed as required
# on the Emscripten install page
# https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#linux
RUN apt-get install -y default-jre python2.7 nodejs
RUN curl https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz | tar xz \
    && cd emsdk_portable \
    && ./emsdk update \
    && ./emsdk install latest \
    && ./emsdk activate latest \
    && ./emsdk construct_env \
    && cp /root/.emscripten /etc/skel
# Make sure users have the tool available when they login by manually adding the correct
# environment variables to the skeleton .bashrc file. I'm not using the "emsdk construct_env"
# method because that insists on writing to the root owned directory each time.
RUN echo "\n" \
    "# Use the most up to date version of Emscripten\n" \
    "export PATH=\"/emsdk_portable:/emsdk_portable/clang/fastcomp/build_master_64/bin:/emsdk_portable/node/4.1.1_64bit/bin:/emsdk_portable/emscripten/master:\$PATH\"\n" \
    "export EM_CONFIG=\"\$HOME/.emscripten\"\n" \
    "export EMSCRIPTEN=\"/emsdk_portable/emscripten/master\"\n" >> /etc/skel/.bashrc

# We need  a version of google protobuf compiled using Emscripten. I know of no binary
# packages that have this, so have to compile from source.
RUN apt-get install -y libtool pandora-build protobuf-compiler
RUN mkdir /sourcecode \
    && cd /sourcecode \
    && git clone https://github.com/google/protobuf.git \
    && cd protobuf \
    && git checkout v2.5.0 \
    && ./autogen.sh
# Use Emscripten to compile the library to LLVM bit code.
RUN cd /sourcecode/protobuf \
    && . /emsdk_portable/emsdk_set_env.sh \
    && emconfigure ./configure --with-protoc=protoc --prefix /usr/local/emscripten_bitcode CPPFLAGS="-DGOOGLE_PROTOBUF_NO_THREAD_SAFETY" \
    && emmake make \
    && emmake make install

# Switch to a non-root user
RUN useradd -ms /bin/bash --groups docker ubuntu
RUN echo "ubuntu:ubuntu" | chpasswd
# Allow the user to run docker commands
RUN echo "ubuntu ALL=(ALL) NOPASSWD: /usr/bin/docker" > /etc/sudoers.d/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

CMD [ "/bin/bash" ]

