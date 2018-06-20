FROM ubuntu:16.04

RUN set -ex

RUN apt-get update && \
    apt-get install -y \
            build-essential \
            liblua5.1-0-dev \
            cmake \
            libgtk2.0-dev \
            libxml2-dev \
            uuid-dev \
            && \
    apt-get clean

# Make the build directory.
RUN mkdir -p /build

# Set the working directory
WORKDIR /build

COPY ./src/im-3.6.3_Sources.tar.gz ./
COPY ./src/Torch3.tar.gz ./
COPY ./src/config/torch3/Makefile_options_Linux ./Torch3/
COPY ./src/wxWidgets-3.0.2.tar.bz2 ./

RUN tar zxf im-3.6.3_Sources.tar.gz && \
    tar xf Torch3.tar.gz && \
    tar xjf wxWidgets-3.0.2.tar.bz2 && \
    rm *\.tar\.*

RUN export LUA_INC=/usr/include/lua5.1 && \
    cd im && make -j 4 && \
    mv lib/Linux*/* ./lib && \
    rmdir lib/Linux* && \
    cd - && \
    unset LUA_INC

RUN cd Torch3 && make -j 4 depend && make -j 4 && cd -

RUN cd wxWidgets-3.0.2 && \
    ./configure --disable-unicode --disable-shared && \
    make -j 4 && make install && cd -

RUN git clone https://github.com/jamieforth/aruspix.git && \
    git checkout ubuntu16.04-static-build
