#!/bin/bash

# git clone https://github.com/mstorsjo/fdk-aac.git

cd fdk-aac

export PREFIX=/usr/local

build_one(){
./configure \
--prefix=$PREFIX \
--enable-shared \
--enable-static
}

./autogen.sh
build_one
make
make install

cd ..
