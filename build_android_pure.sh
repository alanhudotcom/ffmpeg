#!/bin/bash

cd ffmpeg-3.0.2

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
export PREFIX=../simplefflib
export PATH=$PREBUILT/bin/:$PATH

build_one(){
./configure \
--prefix=$PREFIX \
--target-os=linux \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--arch=arm \
--sysroot=$PLATFORM \
--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
--enable-static \
--enable-runtime-cpudetect \
--enable-gpl \
--enable-pthreads \
--enable-small \
--enable-cross-compile \
--disable-debug \
--disable-shared \
--disable-asm \
--disable-yasm \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-stripping \
--extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a"
}

build_one

make
make install

$PREBUILT/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib \
-L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic \
--whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
libavcodec/libavcodec.a libavfilter/libavfilter.a libswresample/libswresample.a \
libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a libpostproc/libpostproc.a \
libavdevice/libavdevice.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a 

cd ..





# arm v7vfp
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
#PREFIX=./android/$CPU-vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

# CPU=armv
# PREFIX=$(pwd)/android/$CPU
# ADDI_CFLAGS="-marm"
# build_one

#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7vfpv3
# CPU=armv7-a
# OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
# PREFIX=./android/$CPU
# ADDITIONAL_CONFIGURE_FLAG=
# build_one

#arm v7n
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=--enable-neon
#build_one

#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one