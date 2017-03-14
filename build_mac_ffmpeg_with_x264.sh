#!/bin/bash

cd ffmpeg

make clean

export PREFIX=/usr/local
# export PREFIX=../ffmpeg_build_mac

# 下面这个字段，在打android包时，尝试使用
# --disable-decoder=h264_vdpau \
# --enable-encoder=libx264 \
# --enable-decoder=h264 \
# --pkg-config-flags="--static" \
# --pkgconfigdir=$PKG_CONFIG_PATH \
# --enable-static \
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

build_one(){
./configure \
--prefix=$PREFIX \
--enable-gpl \
--enable-nonfree \
--disable-logging \
--disable-debug \
--enable-libx264 \
--enable-pthreads \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--extra-ldflags="-L$PREFIX/lib"
}
# --disable-zlib \
# --disable-asm \
# --disable-yasm \
# --disable-ffmpeg \
# --disable-ffplay \
# --disable-ffprobe \
# --disable-ffserver \
# --disable-doc \
# --extra-ldflags="-L$PREFIX/lib" \
# --extra-cflags="-I$PREFIX/include"
# --extra-ldflags="-L$PREFIX/lib" \
# --extra-cflags="-I$PREFIX/include -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a"

build_one
make
make install

cd ..
