# SSH daemon

Used for accessing files in other containers with the "--volumes-from" run option.
Basically taken from the [docker guide for running ssh](https://docs.docker.com/engine/examples/running_ssh_service/);
but I couldn't find a public image of it so built it myself.

The image is available at [markgrimes/sshdaemon](https://hub.docker.com/r/markgrimes/clientserver_build/)
