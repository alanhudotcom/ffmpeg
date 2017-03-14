#!/bin/bash

cd x264

make clean

export NDK=/Users/huyong/development/android-ndk-r10d

# 工具链的路径，根据编译的平台不同而不同
# arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号，
# 根据自己安装的NDK版本来确定，一般使用最新的版本
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
# 编译针对的平台，可以根据自己的需求进行设置
# 这里选择最低支持android-14, arm架构，生成的so库是放在
# libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PREFIX=../ffmpeg_android_build
export PATH=$PREBUILT/bin/:$PATH

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

build_one(){
./configure \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM \
--host=arm-linux \
--prefix=$PREFIX \
--enable-static \
--disable-cli \
--disable-opencl \
--enable-pic \
--extra-cflags="-mfpu=neon -mfloat-abi=softfp -marm -march=armv7-a"
# --host=arm-linux-androideabi \
# --extra-cflags="-march=armv7-a"
}


build_one

make
make install
# make distclean

cd ..