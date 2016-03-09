# Create containers with custom LLVM builds

Dockerfile.build creates a container that builds the head version of LLVM, with some small patches to the LLDB GUI to stop crashes.

Dockerfile.lldb copies the built copy of lldb into a new container, so it should be run from inside a container built by Dockerfile.build.