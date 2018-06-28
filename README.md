# Reproducible static build of Aruspix for Ubuntu 16.04

This assumes you are running docker on the same host OS as the target
build (ubuntu:16.04).


## Build a build container

``` bash
cd aruspix-build
docker build -t aruspix .
```

## Initialise the Aruspix submodule

``` bash
git submodule update --init --recursive --remote
```

## Compile Aruspix inside the container

Mount `src/aruspix` and `bin` inside the container and build Aruspix
there.

``` bash
docker run --rm -it \
       -v `pwd`/src/aruspix:/build/aruspix \
       -v `pwd`/bin:/build/bin \
       aruspix sh bin/build-aruspix
```

### GUI

The Aruspix GUI binary should appear in directory called `gui`. All
files will be owned by root.

To install, copy the contents of `./data` and `./local` to
`/usr/local/share/Aruspix`, and the binary to `/usr/local/bin`.

``` bash
sudo mkdir -p /usr/local/share/Aruspix
sudo cp -r ./data/* /usr/local/share/Aruspix
sudo cp -r ./local/* /usr/local/share/Aruspix
sudo cp ./aruspix /usr/local/bin
```

Check the following runtime libraries are installed before running the
GUI version. They probably are on a graphical desktop.

``` bash
sudo apt install libgtk2.0-0 libxml2 libuuid1 libsm6
```

### ML components

The torch-related ML binaries should appear in a directory called `ml`.

- `adapt`
- `decoder`
- `eval`
- `init`
- `ngram`
- `trainer`

To install, copy to `/usr/local/bin`.

### CMD

The Aruspix command-line binary should appear in directory called
`cmd`. All files will be owned by root – you need to fix this to run
the demo.

``` bash
sudo chown -R $USER:$USER ./bin/cmd
cd cmd
./aruspix-cmdline sample/test.tiff
```

To install, copy the binary to `/usr/local/bin`. If you followed the
steps above to install the GUI version, the models are already
installed at `/usr/local/share/Aruspix/models`.

``` bash
sudo cp ./aruspix-cmdline /usr/local/bin
aruspix-cmdline -m /usr/local/share/Aruspix/models .sample/test.tiff
```
