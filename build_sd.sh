TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD/../
FFTW=$SRSLTE_DIR/$TOOLS_DIR/fftw-3.3.8/install
SCTP=$SRSLTE_DIR/$TOOLS_DIR/lksctp-tools/install
MBEDTLS=$SRSLTE_DIR/$TOOLS_DIR/mbedtls/install
ZEROMQ=$SRSLTE_DIR/$TOOLS_DIR/libzmq/install
LIBCONFIG=$SRSLTE_DIR/$TOOLS_DIR/libconfig/install
IRIS=$SRSLTE_DIR/$TOOLS_DIR/iris/install
FFTW3_DIR=${FFTW}
export FFTW3_DIR=$FFTW

export FFTW3_LIB=$FFTW/lib
export SCTP_LIB=$SCTP/lib
export MBEDTLS_LIB=$MBEDTLS/lib
export ZEROMQ_LIB=$ZEROMQ/lib
export LIBCONFIG_LIB=$LIBCONFIG/lib
export IRIS_LIB=$IRIS/lib
if [ ! -d $FFTW3_LIB ]; then
export FFTW3_LIB=$FFTW/lib64
fi
if [ ! -d $SCTP_LIB ]; then
export SCTP_LIB=$SCTP/lib64
fi
if [ ! -d $MBEDTLS_LIB ]; then
export MBEDTLS_LIB=$MBEDTLS/lib64
fi
if [ ! -d $ZEROMQ_LIB ]; then
export ZEROMQ_LIB=$ZEROMQ/lib64
fi
if [ ! -d $LIBCONFIG_LIB ]; then
export LIBCONFIG_LIB=$LIBCONFIG/lib64
fi
if [ ! -d $IRIS_LIB]; then
export IRIS_LIB=$IRIS/lib64
fi
target_system="android"
if [ $# -ge 1 ]; then
    target_system=$1
fi 
if [ "$target_system" = "android" ]; then
BOOST=$SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install
else
BOOST=$SRSLTE_DIR/$TOOLS_DIR/boost_1_69_0/install
fi
export COMMON_FLAGS="-g -fPIC -I${FFTW3_DIR}/include -I${ZEROMQ}/include -I${BOOST}/include -I${SCTP}/include -I${LIBCONFIG}/include"

append_to_test_cmake() 
{
    f=$1
    echo "" >> $f
    echo 'set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <CMAKE_C_LINK_FLAGS>  <FLAGS> <LINK_FLAGS> <OBJECTS> <LINK_LIBRARIES>  -lfftw3f -lmbedtls -lmbedcrypto -lmbedx509 -lsctp -lconfig -lzmq -o <TARGET>")' >> $f
    echo "" >> $f
    echo 'set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_COMPILER} <CMAKE_CXX_LINK_FLAGS> <FLAGS> <LINK_FLAGS>  <OBJECTS> <LINK_LIBRARIES>  -lfftw3f -lmbedtls -lmbedcrypto -lmbedx509 -lsctp -lconfig -lconfig++ -lzmq -o <TARGET>")' >> $f
    echo "" >> $f
}
append_libs_to_cmake()
{
    f=$1
    sed  -i -e "s/\${CMAKE_THREAD_LIBS_INIT}/$\{CMAKE_THREAD_LIBS_INIT} mbedtls mbedcrypto fftw3f zmq sctp config config++ mbedx509/g" $f
}
set -x 
sed -i -e "s/^# Options/set(CMAKE_SYSTEM_PROCESSOR 'aarch64')/g" -e "s/^find_package(Boost/#find_package(Boost/g" -e "s/\<c99\>/c11/g" ${SRSLTE_DIR}/CMakeLists.txt 
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/ch_estimation/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/phch/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/sync/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/channel/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/ue/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/dft/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/resampling/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/phy/utils/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/src/radio/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/examples/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/test/common/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/test/phy/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/test/srslog/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/lib/test/upper/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/srsue/test/upper/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/srsenb/test/upper/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto mbedx509 sctp config config++ zmq)/g" ${SRSLTE_DIR}/srsenb/test/mac/CMakeLists.txt   
sed  -i -e "s/\${SEC_LIBRARIES})/$\{SEC_LIBRARIES} mbedtls mbedcrypto fftw3f zmq sctp config config++ mbedx509)/g" ${SRSLTE_DIR}/lib/src/common/CMakeLists.txt
sed  -i -e "s/\${FFT_LIBRARIES})/$\{FFT_LIBRARIES} mbedtls mbedcrypto fftw3f zmq sctp config config++ mbedx509)/g" ${SRSLTE_DIR}/lib/src/phy/CMakeLists.txt
append_libs_to_cmake ${SRSLTE_DIR}/srsue/src/CMakeLists.txt     
append_libs_to_cmake ${SRSLTE_DIR}/srsepc/src/CMakeLists.txt    
append_libs_to_cmake ${SRSLTE_DIR}/srsenb/src/CMakeLists.txt    
append_libs_to_cmake ${SRSLTE_DIR}/srsue/test/phy/CMakeLists.txt
sed  -i -e "s/\<SHARED\>/STATIC/g" ${SRSLTE_DIR}/lib/src/phy/rf/CMakeLists.txt
if [ "$target_system" = "android" ]; then
    sed -i -e "s/struct timespec now = {}/struct timeval now/g" -e "s/timespec_get/gettimeofday/g" -e "s/TIME_UTC/NULL/g"  ${SRSLTE_DIR}/lib/src/phy/utils/ringbuffer.c
    sed -i -e "s/\<connect\>(q->sockfd, \&/connect(q->sockfd, (struct sockaddr *)\&/g" ${SRSLTE_DIR}/lib/src/phy/io/netsink.c
    sed -i -e "s/void vshuff_s16_even\>/void vshuff_s16_even_old/g"  -e "s/void vshuff_s32_even\>/void vshuff_s32_even_old/g" -e "s/void vshuff_s16_odd\>/void vshuff_s16_odd_old/g"  -e "s/void vshuff_s32_odd\>/void vshuff_s32_odd_old/g" -e "s/void vshuff_s32_idx\>/void vshuff_s32_idx_old/g" -e "s/void vshuff_s16_idx\>/void vshuff_s16_idx_old/g" -e "s/void vshuff_s16_even\>/void vshuff_s16_even/g" -e "s/vgetq_lane_s32\>/vgetq_lane_s32_old/g" -e "s/vgetq_lane_s16\>/vgetq_lane_s16_old/g" -e "s/vsetq_lane_s32\>/vsetq_lane_s32_old/g" -e "s/vsetq_lane_s16\>/vsetq_lane_s16_old/g" ${SRSLTE_DIR}/lib/src/phy/modem/demod_soft.c
    sed -i -e "s/\<pthread\>//g" ${SRSLTE_DIR}/lib/src/phy/ue/test/CMakeLists.txt
    sed -i -e "s/\<pthread\>//g" ${SRSLTE_DIR}/lib/src/phy/phch/test/CMakeLists.txt
    sed -i -e "s/\<pthread\>//g" ${SRSLTE_DIR}/lib/src/phy/CMakeLists.txt
    sed -i -e "s/\<pthread\>//g" ${SRSLTE_DIR}/lib/examples/CMakeLists.txt
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/include/srslte/srslog/log_channel.h
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/src/srslog/formatter.h
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/include/srslte/srslog/detail/log_entry.h
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/include/srslte/common/time_prof.h
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/test/srslog/formatter_test.cpp
    sed -i -e "s/\<high_resolution_clock\>/system_clock/g" ${SRSLTE_DIR}/lib/test/srslog/log_backend_test.cpp
    
    sed -i -e "s/struct timespec now = {}/struct timeval now/g" -e "s/timespec_get/gettimeofday/g" -e "s/TIME_UTC/NULL/g"  -e "s/now\.tv_nsec/now.tv_usec * 1000U/g" ${SRSLTE_DIR}/lib/src/phy/utils/ringbuffer.c
    sed -i -e "s/#if __GLIBC_PREREQ/#if 1 \/\//g" ${SRSLTE_DIR}/lib/include/srslte/upper/ipv6.h
    sed -i -e "s/-Wall -Wno-comment/-Wall -Wno-unused-function -Wno-comment/g" ${SRSLTE_DIR}/CMakeLists.txt 
    sed -i -e "s/s = pthread_getaffinity_np(.*cpuset)/ { PTHREAD_GETAFFINITY(s, cpuset); }/g" ${SRSLTE_DIR}/lib/src/common/threads.c
    sed -i -e "s/ dur.count()/ (long)dur.count()/g" -e "s/ duration_cast<TUnit>(tmax).count()/ (long)duration_cast<TUnit>(tmax).count()/g" -e "s/ duration_cast<TUnit>(tmin).count()/ (long)duration_cast<TUnit>(tmin).count()/g" ${SRSLTE_DIR}/lib/src/common/time_prof.cc
    sed -i -e "s/__in6_u\.__u6_addr8/in6_u.u6_addr8/g" -e "s/linux\/udp\.h/netinet\/udp.h/g" ${SRSLTE_DIR}/srsue/src/stack/upper/tft_packet_filter.cc
    sed -i -e "s/std::chrono::duration_cast<std::chrono::milliseconds>(dur).count/(long)std::chrono::duration_cast<std::chrono::milliseconds>(dur).count/g" ${SRSLTE_DIR}/srsue/src/stack/ue_stack_lte.cc
    export BOOST_LIB=${BOOST}/libs/arm64-v8a
    export COMMON_FLAGS="${COMMON_FLAGS} -include ${SRSLTE_DIR}/tools.new/defines.h -I${SRSLTE_DIR}/tools.new -Dtimespec_get=gettimeofday -DTIME_UTC=NULL"
else
    append_to_test_cmake ${SRSLTE_DIR}/lib/test/common/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/lib/test/phy/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/lib/test/srslog/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/lib/test/upper/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/srsue/test/phy/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/srsue/test/upper/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/srsenb/test/upper/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/srsenb/test/mac/CMakeLists.txt
    append_to_test_cmake ${SRSLTE_DIR}/srsenb/test/phy/CMakeLists.txt
    export BOOST_LIB=${BOOST}/lib
    export COMMON_FLAGS="${COMMON_FLAGS}"
    #sed  -i -e "s/add_subdirectory(test)/#add_subdirectory(test)/g" ${SRSLTE_DIR}/srsue/CMakeLists.txt
    #sed  -i -e "s/add_subdirectory(test)/#add_subdirectory(test)/g" ${SRSLTE_DIR}/srsepc/CMakeLists.txt
    #sed  -i -e "s/add_subdirectory(test)/#add_subdirectory(test)/g" ${SRSLTE_DIR}/srsenb/CMakeLists.txt
fi
export SRSLTE_CFLAGS="${COMMON_FLAGS} "
export SRSLTE_CXXFLAGS="${COMMON_FLAGS} "
export SRSLTE_EXEFLAGS="-g -L${IRIS_LIB} -L${MBEDTLS_LIB} -L${SCTP_LIB} -L${BOOST_LIB} -L${FFTW3_LIB} -L${ZEROMQ_LIB} -L${LIBCONFIG_LIB}  "

VCMAKE="cmake"
if [[ ! -z "${CMAKE}" ]]; then
    VCMAKE=${CMAKE}
fi

cmake_build() {
    ${VCMAKE} \
      -DCMAKE_INSTALL_PREFIX=$PWD/../install \
      -DENABLE_SRSENB=ON \
      -DENABLE_SRSEPC=ON \
      -DENABLE_HARDSIM=OFF \
      -DENABLE_SOAPYSDR=OFF \
      -DCMAKE_C_FLAGS="${SRSLTE_CFLAGS}" \
      -DCMAKE_CXX_FLAGS="${SRSLTE_CXXFLAGS}" \
      -DENABLE_BLADERF=OFF \
      -DCMAKE_SHARED_LINKER_FLAGS="-g" \
      -DCMAKE_BUILD_TYPE=Release Release \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DBoost_FOUND=ON \
      -DBoost_LIBRARY_DIRS=${BOOST_LIB} \
      -DBoost_LIBRARIES="boost_program_options" \
      -DLIBCONFIGPP_INCLUDE_DIR=$LIBCONFIG/include \
      -DLIBCONFIGPP_LIBRARY=$LIBCONFIG_LIB \
      -DLIBCONFIG_INCLUDE_DIR=$LIBCONFIG/include \
      -DLIBCONFIG_LIBRARY=config \
      -DLIBCONFIGPP_STATIC_LIBRARY=$LIBCONFIG_LIB \
      -DLIBCONFIGPP_LIBRARIES="config++" \
      -DZEROMQ_FOUND=TRUE \
      -DZEROMQ_LIBRARIES=zmq \
      -DZEROMQ_INCLUDE_DIRS=$ZEROMQ/include \
      -DZEROMQ_LIBRARY_DIRS=$ZEROMQ_LIB \
      -DFFTW3F_LIBRARY_DIRS=$FFTW3_LIB \
      -DFFTW3F_LIBRARY=$FFTW3_LIB \
      -DFFTW3F_LIBRARIES=$FFTW3_LIB \
      -DFFTW3F_STATIC_LIBRARY=$FFTW3_LIB \
      -DFFTW3F_INCLUDE_DIR=$FFTW3_DIR/include \
      -DFFT_LIBRARIES=fftw3f \
      -DSCTP_LIBRARIES=$SCTP_LIB \
      -DSCTP_INCLUDE_DIRS=$SCTP/include \
      -DSEC_LIBRARIES=$MBEDTLS_LIB \
      -DMBEDTLS_LIBRARIES=$MBEDTLS_LIB \
      -DBUILD_STATIC=OFF \
      -DRPATH=ON \
      -DCMAKE_EXE_LINKER_FLAGS="$SRSLTE_EXEFLAGS" \
      -DMBEDTLS_INCLUDE_DIRS=$MBEDTLS/include  \
      -DMBEDTLS_STATIC_LIBRARIES=$MBEDTLS_LIB \
      $@ ..
}

if [ "$target_system" = "android" ]; then
    cmake_build \
      -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
      -DANDROID_PLATFORM=28 -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON 
else
    export TARGET=aarch64-linux-gnu
    export CC=$TARGET-gcc
    export CXX=$TARGET-g++
    export LD=$TARGET-ld
    export AR=$TARGET-ar
    export RANLIB=$TARGET-ranlib
    export STRIP=$TARGET-strip
    cmake_build -DCMAKE_SYSTEM_PROCESSOR=aarch64 -DTARGET_ABI=$TARGET  -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} -DCMAKE_CROSSCOMPILING=TRUE
fi
