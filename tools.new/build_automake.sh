export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang
export CXX=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
export LD=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
export API=28
#export TARGET=armv7a-linux-androideabi
export TARGET=aarch64-linux-android

export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip

export CFLAGS="-Dbcopy=memcpy -fPIC ${EXTCFLAGS}"
../configure --prefix=$PWD/../install --host=$TARGET --enable-static $@ 
