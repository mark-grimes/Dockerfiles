FROM alpine

RUN apk add --no-cache go git musl-dev \
    && go get -u github.com/hashrocket/ws \
    && mv /root/go/bin/ws /usr/bin/ \
    && rm -rf /root/go \
    && apk del go git musl-dev

USER 1000:1000
ENTRYPOINT ["ws"]
