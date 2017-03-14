#!/bin/bash

# git clone git://git.videolan.org/x264.git

cd x264

export PREFIX=/usr/local

build_one(){
./configure \
--prefix=$PREFIX \
--enable-shared \
--enable-static
}

build_one
make
make install

cd ..
