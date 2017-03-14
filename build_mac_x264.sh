#!/bin/bash

cd x264

make clean

# export PREFIX=../ffmpeg_build_mac
export PREFIX=/usr/local

# export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

build_one(){
./configure \
--prefix=$PREFIX \
--enable-static \
--disable-asm \
--disable-cli \
--disable-opencl \
--enable-pic
}


build_one

make
make install
# make distclean

cd ..