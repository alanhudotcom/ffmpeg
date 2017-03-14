#!/bin/bash

# git clone git://source.ffmpeg.org/ffmpeg.git

cd ffmpeg

make clean

export PREFIX=/usr/local

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

build_one(){
./configure \
--prefix=$PREFIX \
--enable-gpl --enable-libx264 --enable-nonfree --enable-libfdk-aac \
--disable-logging \
--disable-debug \
--enable-pthreads \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--extra-ldflags="-L$PREFIX/lib"
}

# --extra-ldflags="-L$PREFIX/lib" \
# --extra-cflags="-I$PREFIX/include"
# --extra-ldflags="-L$PREFIX/lib" \
# --extra-cflags="-I$PREFIX/include -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a"

build_one
make
make install

cd ..
