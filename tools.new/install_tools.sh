set -x
install_iris=1
install_boost=1
install_fftw3=1
install_lksctp=1
install_mbedtls=1
install_libzmq=1
install_libconfig=1

target_system="android"
specific="all"
if [ $# -ge 1 ]; then
    target_system=$1
fi 
if [ $# -ge 2 ]; then
    specific=$2
fi 
if [ "x$specific" = "xall" ]; then
    install_iris=1
    install_boost=1
    install_fftw3=1
    install_lksctp=1
    install_mbedtls=1
    install_libzmq=1
    install_libconfig=1
else
    install_iris=0
    install_boost=0
    install_fftw3=0
    install_lksctp=0
    install_mbedtls=0
    install_libzmq=0
    install_libconfig=0
    if [ "$specific" = "iris" ]; then
        install_iris=1
    fi
    if [ "$specific" = "boost" ]; then
        install_boost=1
    fi
    if [ "$specific" = "fftw3" ]; then
        install_fftw3=1
    fi
    if [ "$specific" = "lksctp" ]; then
        install_lksctp=1
    fi
    if [ "$specific" = "mbedtls" ]; then
        install_mbedtls=1
    fi
    if [ "$specific" = "libzmq" ]; then
        install_libzmq=1
    fi
    if [ "$specific" = "libconfig" ]; then
        install_libconfig=1
    fi
fi
cmake_build() {
    if [ "$target_system" = "android" ]; then
    cmake -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=28 -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC=OFF .. $@
    else
    cmake -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC=OFF .. $@
    fi
}
automake_build() {
    export CFLAGS="-fPIC ${EXTCFLAGS}"
    ../configure --prefix=$PWD/../install --host=$TARGET  $@ 
}
if [ "$target_system" = "android" ]; then
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang
export CXX=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
export LD=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++
export API=28
export TARGET=aarch64-linux-android
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
else
if [ "$target_system" = "clean" ]; then
rm -rf *.tar.gz boost* fft* mbedtls libconfig libzmq
exit
else
export TARGET=aarch64-linux-gnu
export CC=$TARGET-gcc
export CXX=$TARGET-g++
export LD=$TARGET-ld
export AR=$TARGET-ar
export RANLIB=$TARGET-ranlib
export STRIP=$TARGET-strip
fi
fi

if [ "x$install_boost" = "x1" ]; then
    wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz -O boost_1_69_0.tar.gz
    tar -xzf boost_1_69_0.tar.gz
    if [ "$target_system" = "android" ]; then 
        git clone https://github.com/dec1/Boost-for-Android.git boost_for_android
        cd boost_for_android  
        export BOOST_DIR=$(pwd)/../boost_1_69_0
        export ABI_NAMES="arm64-v8a"
        export LINKAGES="static"
        bash ./build.sh 
        cd ..
    else
        cd boost_1_69_0
        echo "using gcc : arm : aarch64-linux-gnu-g++ ;" > user_config.jam
        ./bootstrap.sh --prefix=$PWD/install
        ./b2 install toolset=gcc-arm link=static cxxflags=-fPIC --with-test --with-log --with-program_options -j32 --user-config=user_config.jam
        cd ..
    fi
fi

if [ "x$install_iris" = "x1" ]; then
    #git clone -b oe https://code.ornl.gov/eck/brisbane-rts.git iris
    cd iris
    mkdir -p build 
    cd build 
    if [ "$target_system" = "android" ]; then 
    cmake_build 
    else
    cmake_build 
    fi
    make -j16 
    make -j16 install 
    cd ..
    cd ..
fi

if [ "x$install_fftw3" = "x1" ]; then
    wget http://www.fftw.org/fftw-3.3.8.tar.gz -O fftw-3.3.8.tar.gz
    tar -xzf fftw-3.3.8.tar.gz
    cd fftw-3.3.8
    mkdir -p build 
    cd build 
    if [ "$target_system" = "android" ]; then 
    cmake_build -DENABLE_LONG_DOUBLE=OFF -DENABLE_FLOAT=ON -DENABLE_QUAD_PRECISION=OFF 
    else
    cmake_build -DCMAKE_EXE_LINKER_FLAGS='-lm' -DENABLE_LONG_DOUBLE=OFF -DENABLE_FLOAT=ON -DENABLE_QUAD_PRECISION=OFF -DBUILD_TESTS=OFF
    fi

    make -j16 
    make -j16 install 
    cd ..
    cd ..
fi

if [ "x$install_lksctp" = "x1" ]; then
    git clone https://github.com/sctp/lksctp-tools.git
    cd lksctp-tools
    sed -i -e "s/-lpthread//g" src/func_tests/Makefile.am
    ./bootstrap
    mkdir -p build 
    cd build
    if [ "$target_system" = "android" ]; then 
    export EXTCFLAGS='-Dbcopy=memcpy -DS_IREAD=S_IRUSR -DS_IWRITE=S_IWUSR -DS_IEXEC=S_IXUSR'
    else
    export EXTCFLAGS=''
    fi
    automake_build 
    make -j16 
    make -j16 install-exec install-data
    cd ..
    cd ..
fi

if [ "x$install_mbedtls" = "x1" ]; then
    git clone -b mbedtls-2.24.0 https://github.com/ARMmbed/mbedtls.git
    cd mbedtls
    sed -i -e "s/EOF != c/EOF != (int)c/" programs/ssl/ssl_context_info.c
    mkdir -p build 
    cd build 
    if [ "$target_system" = "android" ]; then 
    cmake_build -DCMAKE_C_FLAGS='-D__socklen_t_defined=1' -DUSE_SHARED_MBEDTLS_LIBRARY=TRUE
    else
    cmake_build -DCMAKE_C_FLAGS='-Wno-type-limits' -DUSE_SHARED_MBEDTLS_LIBRARY=TRUE
    fi
    make -j16 install
    cd ..
    cd ..
fi

if [ "x$install_libzmq" = "x1" ]; then
    git clone https://github.com/zeromq/libzmq.git
    cd libzmq
    mkdir -p build 
    cd build 
    cmake_build
    make -j16 install
    cd ..
    cd ..
fi

if [ "x$install_libconfig" = "x1" ]; then
    git clone https://github.com/hyperrealm/libconfig.git
    cd libconfig
    mkdir -p build 
    cd build 
    cmake_build
    make -j16 install
    cd ..
    cd ..
fi

