
PREFIX=`pwd`/protobuf/android
rm -rf ${PREFIX}
mkdir -p ${PREFIX}

export NDK=/Users/hannafadida/Library/Android/sdk/ndk-bundle
 
# 1. Use the tools from the Standalone Toolchain
export PATH=/opt/android-toolchain/21_mips64/bin:$PATH
export SYSROOT=/opt/android-toolchain/21_mips64/sysroot
export CC="mips64el-linux-android-gcc --sysroot $SYSROOT"
export CXX="mips64el-linux-android-g++ --sysroot $SYSROOT"
export CXXSTL=$NDK/sources/cxx-stl/gnu-libstdc++/4.9
 
##########################################
# Fetch Protobuf 3.0.0 from source.
##########################################

#(
    #cd /tmp
    #curl http://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz --output /tmp/protobuf-2.5.0.tar.gz
 
    #if [ -d /tmp/protobuf-2.5.0 ]
    #then
    #    rm -rf /tmp/protobuf-2.5.0
    #fi
    cd /opt
    echo $(pwd)
    
    #tar xvf /opt/protobuf-3.0.0.tar.gz
#)

cd /opt/protobuf-3.0.0
echo $(pwd)
mkdir buildtmp
 
echo "before configure $(pwd)"
# 3. Run the configure to target a static library for the ARMv7 ABI
# for using protoc, you need to install protoc to your OS first, or use another protoc by path
./configure --prefix=$(pwd)/buildtmp \
--host=arm-linux-androideabi \
--with-sysroot=$SYSROOT \
--disable-shared \
--enable-cross-compile \
--with-protoc=protoc \
#CFLAGS="-march=armv7-a" \
#CXXFLAGS="-march=armv7-a -I$CXXSTL/include -I$CXXSTL/libs/mips64/include"
CXXFLAGS="-I$CXXSTL/include -I$CXXSTL/libs/mips64/include"
 
# 4. Build
make && make install
 
# 5. Inspect the library architecture specific information
mips64el-linux-android-readelf -A buildtmp/lib/libprotobuf-lite.a
#mips64el-linux-android


cp buildtmp/lib/libprotobuf.a $PREFIX/libprotobuf.a
cp buildtmp/lib/libprotobuf-lite.a $PREFIX/libprotobuf-lite.a
