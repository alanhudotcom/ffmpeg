#!/bin/sh  
# LXH,MXY  
#  
# directories  
SOURCE="x264"
FAT="x264-fat-iOS"

SCRATCH="x264-scratch-iOS"
# must be an absolute path
THIN=`pwd`/"x264-thin-iOS"
  
#This is decided by your SDK version.  
SDK_VERSION="9.3"  
  
cd $SOURCE
  
export PLATFORM="iPhoneOS"

ARCHS="arm64"
  
export DEVROOT=/Applications/Xcode.app/Contents/Developer
export SDKROOT=$DEVROOT/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDK_VERSION}.sdk
#DEVPATH=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDK_VERSION}.sdk  
# export CC=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
# export AS=$DEVROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/as
COMMONFLAGS="-pipe -gdwarf-2 -no-cpp-precomp -isysroot ${SDKROOT} -marm -fPIC"
export LDFLAGS="${COMMONFLAGS} -fPIC"
export CFLAGS="${COMMONFLAGS} -fvisibility=hidden"
export CXXFLAGS="${COMMONFLAGS} -fvisibility=hidden -fvisibility-inlines-hidden"
  

for ARCH in $ARCHS; do  
  
echo "Building $ARCH ......"  
  
./configure \
--prefix="$THIN/$ARCH" \
--host=arm-apple-darwin \
--sysroot=$SDKROOT \
--extra-cflags="-arch $ARCH" \
--extra-ldflags="-arch $ARCH" \
--enable-pic \
--enable-static \
--disable-asm
 
 make
 make install
 make clean  
  
echo "Installed: $DEST/$ARCH"  
  
done  
  
cd ..  
  
#================ fat lib ===================  
  
# ARCHS="armv7 armv7s i386 x86_64 arm64" 
ARCHS="arm64"  
  
echo "building fat binaries..."  
mkdir -p $FAT/lib  
set - $ARCHS  
CWD=`pwd`  
cd $THIN/$1/lib  
for LIB in *.a  
do  
cd $CWD  
lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB  
done  
  
cd $CWD  
cp -rf $THIN/$1/include $FAT  