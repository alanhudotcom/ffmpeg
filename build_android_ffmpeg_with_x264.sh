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
export PREFIX=../ffmpeg_android_build
export PATH=$PREBUILT/bin/:$PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# 下面这个字段，在打android包时，尝试使用
# --disable-decoder=h264_vdpau \
# --enable-encoder=libx264 \
# --enable-decoder=h264 \
# --pkg-config-flags="--static" \
# --pkgconfigdir=$PKG_CONFIG_PATH \

build_one(){
./configure \
--prefix=$PREFIX \
--disable-logging \
--disable-debug \
--disable-stripping \
--enable-gpl \
--pkg-config-flags="--static" \
--arch=arm \
--target-os=linux \
--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM \
--cc=$PREBUILT/bin/arm-linux-androideabi-gcc \
--nm=$PREBUILT/bin/arm-linux-androideabi-nm \
--enable-static \
--enable-runtime-cpudetect \
--disable-decoder=h264_vdpau \
--enable-libx264 \
--enable-encoder=libx264 \
--enable-decoder=h264 \
--enable-pthreads \
--enable-small \
--enable-asm \
--enable-yasm \
--enable-cross-compile \
--disable-shared \
--enable-neon \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--extra-ldflags="-L$PREFIX/lib" \
--extra-cflags="-I$PREFIX/include -fPIC -DANDROID -mfpu=neon -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a"
}

build_one
echo "===========configure finish"

make
echo "===========make finish"

make install
echo "===========make install finish"

# $PREBUILT/bin/arm-linux-androideabi-ar d $PREFIX/libavcodec.a inverse.o

$PREBUILT/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib \
-L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic \
--whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
$PREFIX/lib/libx264.a libavcodec/libavcodec.a libavfilter/libavfilter.a libswresample/libswresample.a \
libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a libpostproc/libpostproc.a \
libavdevice/libavdevice.a -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$PREBUILT/lib/gcc/arm-linux-androideabi/4.9/libgcc.a 

cd ..