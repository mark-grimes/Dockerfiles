FROM debian:stretch

RUN apt-get update \
    && apt-get install -y build-essential libtool autoconf ffmpeg git \
    && git clone https://github.com/aizvorski/h264bitstream.git /h264bitstream \
    && cd /h264bitstream && autoreconf -i \
    && cd /h264bitstream && ./configure \
    && cd /h264bitstream && make \
    && cd /h264bitstream && make install \
    && rm -rf /h264bitstream \
    && apt-get autoremove -y build-essential libtool autoconf ffmpeg git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data
ENTRYPOINT ["h264_analyze"]
ENV LD_LIBRARY_PATH=/usr/local/lib
