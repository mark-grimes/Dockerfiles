Dockerfile to build [ClientServer](https://github.com/mark-grimes/ClientServer). This
creates the build environment, the Dockerfile for the actual ClientServer package is in
that repository.

Includes g++, the latest Emscripten (v1.35), and a version of protobuf v2.5 built to LLVM
byte code by Emscripten. The default Emscripten on Ubuntu is far too old for decent use
so it builds from source which takes bloody ages.

The built image is available as [markgrimes/clientserver_build](https://hub.docker.com/r/markgrimes/clientserver_build/)

Work in progress.