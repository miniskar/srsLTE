set -x
static_build=1
install_iris=1
install_libusb=1
install_uhd=1
install_boost=1
install_fftw3=1
install_lksctp=1
install_mbedtls=1
install_libzmq=1
install_libconfig=1
NPROC=`nproc`
target_system="android"
ANDROID_ABI=arm64-v8a
specific="all"
if [ $# -ge 1 ]; then
    target_system=$1
fi 
if [ $# -ge 2 ]; then
    specific=$2
fi 
nodownload=0
if [ $# -ge 3 ]; then
    nodownload=$3
fi 
if [ "x$specific" = "xall" ]; then
    install_libusb=1
    install_uhd=1
    install_iris=1
    install_boost=1
    install_fftw3=1
    install_lksctp=1
    install_mbedtls=1
    install_libzmq=1
    install_libconfig=1
else
    install_libusb=0
    install_uhd=0
    install_iris=0
    install_boost=0
    install_fftw3=0
    install_lksctp=0
    install_mbedtls=0
    install_libzmq=0
    install_libconfig=0
    if [ "$specific" = "libusb" ]; then
        install_libusb=1
    fi
    if [ "$specific" = "uhd" ]; then
        install_uhd=1
    fi
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
    EXTC_FLAGS="-fPIC -g "
    EXTCXX_FLAGS="-fPIC -g "
    EXTEXE_FLAGS=""
    if [ ! -z "${CMAKE_C_FLAGS}" ]; then
        EXTC_FLAGS="${CMAKE_C_FLAGS} $EXTC_FLAGS"
    fi
    if [ ! -z "${CMAKE_CXX_FLAGS}" ]; then
        EXTCXX_FLAGS="${CMAKE_CXX_FLAGS} $EXTCXX_FLAGS"
    fi
    if [ ! -z "${CMAKE_EXE_LINKER_FLAGS}" ]; then
        EXTEXE_FLAGS="${CMAKE_EXE_LINKER_FLAGS} $EXTEXE_FLAGS"
    fi
    if [ "$target_system" = "android" ]; then
        if [ "x$static_build" = "x0" ]; then
            ${VCMAKE} -DCMAKE_C_FLAGS="${EXTC_FLAGS}" -DCMAKE_CXX_FLAGS="${EXTCXX_FLAGS}" -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=28 -DANDROID_ABI=${ANDROID_ABI} -DANDROID_ARM_NEON=ON -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC=OFF -DBUILD_SHARED=ON -DCMAKE_EXE_LINKER_FLAGS="${EXTEXE_FLAGS}" .. $@
        else
            ${VCMAKE} -DCMAKE_C_FLAGS="${EXTC_FLAGS}" -DCMAKE_CXX_FLAGS="${EXTCXX_FLAGS}" -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=28 -DANDROID_ABI=${ANDROID_ABI} -DANDROID_ARM_NEON=ON -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC=ON -DBUILD_SHARED=OFF -DCMAKE_EXE_LINKER_FLAGS="${EXTEXE_FLAGS}" .. $@
        fi
    else
        if [ "x$static_build" = "x0" ]; then
            ${VCMAKE} -DCMAKE_C_FLAGS="${EXTC_FLAGS}" -DCMAKE_CXX_FLAGS="${EXTCXX_FLAGS}" -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC=OFF -DBUILD_SHARED=ON -DCMAKE_EXE_LINKER_FLAGS="${EXTEXE_FLAGS}" .. $@
        else
            ${VCMAKE} -DCMAKE_C_FLAGS="${EXTC_FLAGS}" -DCMAKE_CXX_FLAGS="${EXTCXX_FLAGS}" -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC=ON -DBUILD_SHARED=OFF -DCMAKE_EXE_LINKER_FLAGS="${EXTEXE_FLAGS}" .. $@
        fi
    fi
    unset CMAKE_C_FLAGS
    unset CMAKE_CXX_FLAGS
    unset CMAKE_EXE_LINKER_FLAGS
}
automake_build() {
    export CFLAGS="-fPIC ${EXTCFLAGS}"
    if [ "x$static_build" = "x0" ]; then
        ../configure --prefix=$PWD/../install --host=$TARGET  --disable-static --enable-debug --enable-shared $@ 
    else
        ../configure --prefix=$PWD/../install --host=$TARGET  --enable-static  --enable-debug --disable-shared $@ 
    fi
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
elif [ "$target_system" = "clean" ]; then
rm -rf *.tar.gz boost* uhd libusb iris fft* mbedtls libconfig libzmq lksctp-tools
exit
elif [ "$target_system" = "host" ]; then
export CC=gcc
export CXX=g++
export LD=ld
export AR=ar
export RANLIB=ranlib
export STRIP=strip
else
export TARGET=aarch64-linux-gnu
export CC=$TARGET-gcc
export CXX=$TARGET-g++
export LD=$TARGET-ld
export AR=$TARGET-ar
export RANLIB=$TARGET-ranlib
export STRIP=$TARGET-strip
fi

VCMAKE="cmake"
if [ ! -z "${CMAKE}" ]; then
    VCMAKE=${CMAKE}
fi
#BOOST_VERSION="1_70"
BOOST_VERSION="1_69"
BOOST_VERSION_TAG="${BOOST_VERSION}_0"
BLINK=`echo ${BOOST_VERSION_TAG} | sed -e "s/_/./g"`
if [ "x$install_boost" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        wget https://dl.bintray.com/boostorg/release/${BLINK}/source/boost_${BOOST_VERSION_TAG}.tar.gz -O boost_1_69_0.tar.gz
        tar -xzf boost_${BOOST_VERSION_TAG}.tar.gz
    fi
    if [ "$target_system" = "android" ]; then 
        if [ "x$nodownload" = "x0" ]; then
            #git clone https://github.com/moritz-wundke/Boost-for-Android.git boost_for_android
            git clone https://github.com/dec1/Boost-for-Android.git boost_for_android
        fi
        cd boost_for_android  
        mkdir -p install
        #sed -i -e "s/<static>/shared/g" build-android.sh
        export BOOST_DIR=$(pwd)/../boost_${BOOST_VERSION_TAG}
        export ABI_NAMES="${ANDROID_ABI}"
        export LINKAGES="static"
        #bash ./build-android.sh --prefix=$(pwd)/install --arch=arm64-v8a --boost=${BLINK}.0 --toolchain=llvm
        #export WITH_LIBRARIES="--with-serialization --with-program_options"
        bash ./build.sh 
        cp -rf build/install/libs/${ANDROID_ABI}/*.a build/install/libs/.
        cd ..
    else
        cd boost_${BOOST_VERSION_TAG}
        echo "using gcc : arm : aarch64-linux-gnu-g++ ;" > user_config.jam
        ./bootstrap.sh --prefix=$PWD/install
        ./b2 install toolset=gcc-arm link=static debug-symbols=on cxxflags=-fPIC --with-test --with-log --with-serialization --with-program_options -j${NPROC} --user-config=user_config.jam
        cd ..
    fi
fi

if [ "x$install_libusb" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone https://github.com/libusb/libusb.git
        #git clone https://github.com/trondeau/libusb.git
    fi
    cd libusb
    sh bootstrap.sh
    mkdir -p build 
    cd build
    automake_build --enable-udev=no 
    make -j${NPROC}
    make -j${NPROC} install 
    cd ..
    cd ..
fi
LIBUSB=$PWD/libusb/install
export BOOST_POSTFIX=
if [ "$target_system" = "android" ]; then 
export BOOST=$PWD/boost_for_android/build/install
export BOOST_LIB=${BOOST}/libs/${ANDROID_ABI}
export BOOST_INC=${BOOST}/include
#export BOOST=$PWD/boost_for_android/install
#export BOOST_INC=${BOOST}/${ANDROID_ABI}/include/boost-${BOOST_VERSION}
#export BOOST_LIB=${BOOST}/${ANDROID_ABI}/lib
#export BOOST_POSTFIX=-clang-mt-a64-${BOOST_VERSION}
else
export BOOST_DIR=$PWD/boost_${BOOST_VERSION_TAG}
export BOOST=$PWD/boost_${BOOST_VERSION_TAG}/install
export BOOST_LIB=${BOOST}/lib
export BOOST_INC=${BOOST}/include
fi
if [ "x$install_uhd" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone https://github.com/EttusResearch/uhd.git
        #git clone https://github.com/trondeau/uhd.git
    fi
    pip3 install mako requests --user
    cd uhd/host
    mkdir -p build 
    cd build
    CMAKE_CXX_FLAGS='-I${PWD}/_cmrc/include -Wno-format-security'
    BLIBS=""
    sed -i -e "s/\<native\>/native_handle/g"  ../examples/network_relay.cpp
    sed -i -e "s/\<native\>/native_handle/g"  ../lib/transport/udp_zero_copy.cpp
    sed -i -e "s/\<native\>/native_handle/g"  ../lib/transport/udp_simple.cpp
    sed -i -e "s/\<native\>/native_handle/g"  ../lib/transport/tcp_zero_copy.cpp
    sed -i -e "s/Boost_FOUND;HAVE_PYTHON_PLAT_MIN_VERSION;HAVE_PYTHON_MODULE_MAKO//g" ../CMakeLists.txt
    sed -i -e "s/posix_time::seconds(setup/posix_time::seconds((unsigned long long)setup/g" ../examples/rx_samples_to_file.cpp
    sed -i -e "s/posix_time::milliseconds(delay/posix_time::milliseconds((unsigned long long)delay/g" ../examples/tx_samples_from_file.cpp
    if [ "$target_system" = "android" ]; then 
        sed -i -e "s/#else\s*$/#else \/\/\n#if 0/g" -e "s/if (path.empty()) {\s*$/{ \/\//g" -e "s/#endif\s*$/#endif \/\/\n#endif \/\//g" ../lib/utils/pathslib.cpp
        sed -i -e "s/\<gethostid()/0/g" ../lib/utils/platform.cpp
        for i in chrono date_time filesystem program_options regex system unit_test_framework serialization atomic thread; do 
        BLIBS="${BLIBS} boost_${i}${BOOST_POSTFIX}";
        done
        sed -i -e "s/\"\<pthread\>\"/\"\"/g" ../CMakeLists.txt
        sed -i -e "s/\"\<pthread\>\"/\"\"/g" -e "s/LIBUHD_APPEND_LIBS(pthread)//g" ../lib/utils/CMakeLists.txt
        sed -i -e "s/libuhd_libs})/libuhd_libs} ${BLIBS})/g" ../lib/CMakeLists.txt 
        sed -i -e "s/libuhd_libs} uhd_rc)/libuhd_libs} uhd_rc ${BLIBS})/g" ../lib/CMakeLists.txt 
        sed -i -e "s/libuhd_libs} log)/libuhd_libs} log ${BLIBS})/g" ../lib/CMakeLists.txt 
        CMAKE_EXE_LINKER_FLAGS="-L${BOOST_LIB} -lboost_atomic${BOOST_POSTFIX} -lboost_chrono${BOOST_POSTFIX} -lc++_shared " 
        cmake_build -DBUILD_SHARED=OFF -DBUILD_SHARED_LIBS=OFF -DNEON_SIMD_ENABLE=ON \
                   -DBoost_NO_BOOST_CMAKE=TRUE \
                   -DBoost_NO_SYSTEM_PATHS=TRUE \
                   -DANDROID=ON \
                   -DBOOST_VERSION=$BOOST_POSTFIX \
                   -DBoost_THREAD_LIBRARY_RELEASE:FILEPATH=${BOOST_LIB} \
                   -DBoost_LIBRARY_DIRS:FILEPATH=${BOOST_LIB} \
                   -DBoost_INCLUDE_DIR:FILEPATH=${BOOST_INC} \
                   -DBoost_INCLUDE_DIRS:FILEPATH=${BOOST_INC} \
                   -DLIBUSB_INCLUDE_DIRS=$LIBUSB/include/libusb-1.0 \
                   -DLIBUSB_LIBRARIES="$LIBUSB/lib/libusb-1.0.a"\
                   -DENABLE_STATIC_LIBS=True -DENABLE_USRP1=False \
                   -DENABLE_USRP2=False -DENABLE_B100=False \
                   -DENABLE_X300=False -DENABLE_OCTOCLOCK=False \
                   -DENABLE_TESTS=False -DENABLE_ORC=False 
    else
        for i in chrono date_time filesystem program_options regex system unit_test_framework atomic thread; do 
        BLIBS="${BLIBS} boost_${i}${BOOST_POSTFIX}";
        done
        sed -i -e "s/libuhd_libs})/libuhd_libs} ${BLIBS})/g" ../lib/CMakeLists.txt 
        sed -i -e "s/libuhd_libs} log)/libuhd_libs} log ${BLIBS})/g" ../lib/CMakeLists.txt 
        CMAKE_EXE_LINKER_FLAGS="-L${BOOST_LIB} -lboost_atomic${BOOST_POSTFIX} -lboost_chrono${BOOST_POSTFIX} " 
        cmake_build -DBUILD_SHARED=OFF -DBUILD_SHARED_LIBS=OFF -DNEON_SIMD_ENABLE=ON \
                       -DBOOST_ROOT=$BOOST_DIR/install \
                       -DBOOST_VERSION=$BOOST_POSTFIX \
                       -DENABLE_EXAMPLES=OFF \
                       -DENABLE_UTILS=OFF \
                       -DENABLE_TESTS=OFF \
                       -DBoost_THREAD_LIBRARY_RELEASE:FILEPATH=${BOOST_LIB} \
                       -DBoost_LIBRARY_DIRS:FILEPATH=${BOOST_LIB} \
                       -DBoost_INCLUDE_DIR:FILEPATH=${BOOST_INC} \
                       -DBoost_INCLUDE_DIRS:FILEPATH=${BOOST_INC} \
                       -DLIBUSB_INCLUDE_DIRS=$LIBUSB/include/libusb-1.0 \
                       -DLIBUSB_LIBRARIES="$LIBUSB/lib/libusb-1.0.a"\
                       -DENABLE_STATIC_LIBS=True -DENABLE_USRP1=False \
                       -DENABLE_USRP2=False -DENABLE_B100=False \
                       -DENABLE_X300=False -DENABLE_OCTOCLOCK=False \
                       -DENABLE_TESTS=False -DENABLE_ORC=False 
    fi                   
    make -j${NPROC}
    make -j${NPROC} install 
    cd ..
    if [ -d $(pwd)/install/lib ]; then
        rm -f $(pwd)/install/lib/libuhd.so*
    fi
    if [ -d $(pwd)/install/lib64 ]; then
        rm -f $(pwd)/install/lib64/libuhd.so*
    fi
    cd ../../
fi

if [ "x$install_iris" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone -b oe https://code.ornl.gov/eck/brisbane-rts.git iris
    fi
    cd iris
    mkdir -p build 
    cd build 
    cmake_build -DBUILD_SHARED=ON -DBUILD_SHARED_LIBS=ON
    make -j${NPROC}
    make -j${NPROC} install 
    cd ..
    cd ..
fi

if [ "x$install_fftw3" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        wget http://www.fftw.org/fftw-3.3.8.tar.gz -O fftw-3.3.8.tar.gz
        tar -xzf fftw-3.3.8.tar.gz
    fi
    cd fftw-3.3.8
    mkdir -p build 
    cd build 
    if [ "$target_system" = "android" ]; then 
    cmake_build -DCMAKE_C_FLAGS='-g' -DCMAKE_CXX_FLAGS='-g' -DENABLE_LONG_DOUBLE=OFF -DENABLE_FLOAT=ON -DENABLE_QUAD_PRECISION=OFF 
    else
    CMAKE_EXE_LINKER_FLAGS="-lm"
    cmake_build -DCMAKE_C_FLAGS='-g' -DCMAKE_CXX_FLAGS='-g' -DENABLE_LONG_DOUBLE=OFF -DENABLE_FLOAT=ON -DENABLE_QUAD_PRECISION=OFF -DBUILD_TESTS=OFF
    fi
    make -j${NPROC} 
    make -j${NPROC} install 
    cd ..
    cd ..
fi

if [ "x$install_lksctp" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone https://github.com/sctp/lksctp-tools.git
    fi
    cd lksctp-tools
    sed -i -e "s/-lpthread//g" src/func_tests/Makefile.am
    ./bootstrap
    SRSLD_FLAG=""
    if [ "$target_system" = "android" ]; then 
    export EXTCFLAGS='-Dbcopy=memcpy -DS_IREAD=S_IRUSR -DS_IWRITE=S_IWUSR -DS_IEXEC=S_IXUSR'
    else
    export EXTCFLAGS=''
    SRSLD_FLAG="-lpthread"
    fi
    mkdir -p build
    cd build 
    automake_build 
    make -j${NPROC} LDFLAGS="$SRSLD_FLAG"
    make -j${NPROC} LDFLAGS="$SRSLD_FLAG" install-exec install-data
    cd ..
    cd ..
fi

if [ "x$install_mbedtls" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone -b mbedtls-2.24.0 https://github.com/ARMmbed/mbedtls.git
    fi
    cd mbedtls
    sed -i -e "s/EOF != c/EOF != (int)c/" programs/ssl/ssl_context_info.c
    mkdir -p build 
    cd build 
    comp_flag="-DUSE_SHARED_MBEDTLS_LIBRARY=TRUE"
    if [ "x$static_build" = "x1" ]; then
        comp_flag="-DUSE_STATIC_MBEDTLS_LIBRARY=TRUE"
    fi
    if [ "$target_system" = "android" ]; then 
    CMAKE_C_FLAGS='-g -D__socklen_t_defined=1'
    cmake_build  ${comp_flag}
    else
    CMAKE_C_FLAGS='-g -Wno-type-limits'
    cmake_build  ${comp_flag}
    fi
    make -j${NPROC} install
    cd ..
    cd ..
fi

if [ "x$install_libzmq" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone https://github.com/zeromq/libzmq.git
    fi
    cd libzmq
    mkdir -p build 
    cd build 
    cmake_build -DCMAKE_C_FLAGS='-g' -DCMAKE_CXX_FLAGS='-g' 
    make -j${NPROC} install
    cd ..
    cd ..
fi

if [ "x$install_libconfig" = "x1" ]; then
    if [ "x$nodownload" = "x0" ]; then
        git clone https://github.com/hyperrealm/libconfig.git
    fi
    cd libconfig
    mkdir -p build 
    cd build 
    cmake_build -DCMAKE_C_FLAGS='-g' -DCMAKE_CXX_FLAGS='-g' 
    make -j${NPROC} install
    cd ..
    cd ..
fi

