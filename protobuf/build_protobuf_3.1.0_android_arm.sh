
#based on https://gist.github.com/helayzhang/9034454#file-build_protobuf_android-sh
PREFIX=`pwd`/protobuf/android/arm
rm -rf ${PREFIX}
mkdir -p ${PREFIX}

export NDK=/Users/hannafadida/Library/Android/sdk/ndk-bundle
 
# 1. Use the tools from the Standalone Toolchain
export PATH=/opt/android-toolchain/23api/arm/bin:$PATH
export SYSROOT=/opt/android-toolchain/23api/arm/sysroot
export CC="arm-linux-androideabi-gcc --sysroot $SYSROOT"
export CXX="arm-linux-androideabi-g++ --sysroot $SYSROOT"
export CXXSTL=$NDK/sources/cxx-stl/gnu-libstdc++/4.9
 
##########################################
# Fetch Protobuf 3.1.0 from source.
##########################################

#(

    #curl http://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz --output /tmp/protobuf-2.5.0.tar.gz
 
    #if [ -d /tmp/protobuf-3.1.0 ]
    #then
    #    rm -rf /tmp/protobuf-3.1.0
    #fi

    #cd /tmp
    #cp -rf ~/Downloads/protobuf-3.1.0 .
    #cd protobuf-3.1.0
    #./autogen.sh

    cd /opt
    #tar xvf /opt/protobuf-3.0.0.tar.gz
#)

cd /opt/protobuf-3.1.0
mkdir buildArm
 
# 3. Run the configure to target a static library for the ARMv7 ABI
# for using protoc, you need to install protoc to your OS first, or use another protoc by path
./configure --prefix=$(pwd)/buildArm \
--host=arm-linux-androideabi \
--with-sysroot=$SYSROOT \
--disable-shared \
--enable-cross-compile \
--with-protoc=protoc \
CFLAGS="-march=armv7-a" \
CXXFLAGS="-march=armv7-a -I$CXXSTL/include -I$CXXSTL/libs/armeabi-v7a/include"
#CXXFLAGS="-I$CXXSTL/include -I$CXXSTL/libs/mips64/include"
 
# 4. Build
make && make install
 
# 5. Inspect the library architecture specific information
arm-linux-androideabi-readelf -A buildArm/lib/libprotobuf-lite.a
#mips64el-linux-android


cp buildArm/lib/libprotobuf.a $PREFIX/libprotobuf.a
cp buildArm/lib/libprotobuf-lite.a $PREFIX/libprotobuf-lite.a
