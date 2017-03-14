#!/bin/bash

# git clone git://github.com/yasm/yasm.git

cd yasm

export PREFIX=/usr/local

build_one(){
./configure \
--prefix=$PREFIX
}

./autogen.sh
build_one
make
make install

cd ..
