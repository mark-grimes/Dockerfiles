FROM alpine

# Without ttf-freefont there will be no text
RUN apk add --no-cache wireshark ttf-freefont

# Get some dbus error if there is not a machine-id file. Could also install
# do "RUN apk add --no-cache dbus && dbus-uuidgen > /var/lib/dbus/machine-id"
# but I want to keep the image small. Not sure if having a non-unique id matters.
RUN echo "1234567890abcdef1234567890abcdef" > /etc/machine-id

ENV DISPLAY="host.docker.internal:0"
ENTRYPOINT ["wireshark"]

# Then you can run with e.g. "docker run --rm -d --net=host --privileged wireshark"
