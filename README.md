# Reproducible build of Aruspix

This assumes you are running docker on the same host OS as the target
build (ubuntu:16.04).

Check the following runtime libraries are installed. They probably are
on a graphical desktop.

``` bash
sudo apt install libgtk2.0-0 libxml2 libuuid1 libsm6
```

## Build a build container

``` bash
cd aruspix-build
docker build -t aruspix .
```

## Compile Aruspix inside the container

Mount aruspix-build/bin inside the container and build Aruspix
there. The Aruspix binary should appear in that directory.

``` bash
docker run --rm -it -v `pwd`/bin:/build/bin aruspix sh bin/build-aruspix
```
