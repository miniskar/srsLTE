set -x
install_boost=1
install_fftw3=1
install_lksctp=1
install_mbedtls=1
install_libzmq=1
install_libconfig=1
if [ "x$install_boost" = "x1" ]; then
    wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz -O boost_1_69_0.tar.gz
    tar -xzf boost_1_69_0.tar.gz
    git clone https://github.com/dec1/Boost-for-Android.git boost_for_android
    cd boost_for_android  
    export BOOST_DIR=$(pwd)/../boost_1_69_0
    export ABI_NAMES="arm64-v8a"
    export LINKAGES="static"
    bash ./build.sh 
    cd ..
fi

if [ "x$install_fftw3" = "x1" ]; then
    wget http://www.fftw.org/fftw-3.3.8.tar.gz -O fftw-3.3.8.tar.gz
    tar -xzf fftw-3.3.8.tar.gz
    cd fftw-3.3.8
    mkdir -p build 
    cd build 
    sh ../../build_cmake.sh -DENABLE_LONG_DOUBLE=OFF -DENABLE_FLOAT=ON -DENABLE_QUAD_PRECISION=OFF 
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
    export EXTCFLAGS='-DS_IREAD=S_IRUSR -DS_IWRITE=S_IWUSR -DS_IEXEC=S_IXUSR'
    sh ../../build_automake.sh 
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
    sh ../../build_cmake.sh -DCMAKE_C_FLAGS='-D__socklen_t_defined=1' -DUSE_SHARED_MBEDTLS_LIBRARY=TRUE
    make -j16 install
    cd ..
    cd ..
fi

if [ "x$install_libzmq" = "x1" ]; then
    git clone https://github.com/zeromq/libzmq.git
    cd libzmq
    mkdir -p build 
    cd build 
    sh ../../build_cmake.sh 
    make -j16 install
    cd ..
    cd ..
fi

if [ "x$install_libconfig" = "x1" ]; then
    git clone https://github.com/hyperrealm/libconfig.git
    cd libconfig
    mkdir -p build 
    cd build 
    sh ../../build_cmake.sh 
    make -j16 install
    cd ..
    cd ..
fi

