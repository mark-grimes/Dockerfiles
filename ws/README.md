# ws

Command line websocket client. See https://github.com/hashrocket/ws.

## Usage

Start a container giving it the address of the websocket, e.g. to test a socket listening on port 8080 of the host (assuming this image was built as `websocket`):

```
docker run --rm -it websocket ws://host.docker.internal:8080
```

Anything you type will be sent down the socket and any replies printed to the screen.
