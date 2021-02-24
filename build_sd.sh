TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD/../
BOOST=$SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install
FFTW=$SRSLTE_DIR/$TOOLS_DIR/fftw-3.3.8/install
SCTP=$SRSLTE_DIR/$TOOLS_DIR/lksctp-tools/install
MBEDTLS=$SRSLTE_DIR/$TOOLS_DIR/mbedtls/install
ZEROMQ=$SRSLTE_DIR/$TOOLS_DIR/libzmq/install
LIBCONFIG=$SRSLTE_DIR/$TOOLS_DIR/libconfig/install
FFTW3_DIR=${FFTW}
export FFTW3_DIR=$FFTW
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
sed -i -e "s/^find_package(Boost/#find_package(Boost/g" -e "s/\<c99\>/c11/g" ${SRSLTE_DIR}/CMakeLists.txt 
sed -i -e "s/#if __GLIBC_PREREQ/#if 1 \/\//g" ${SRSLTE_DIR}/lib/include/srslte/upper/ipv6.h
sed -i -e "s/-Wall -Wno-comment/-Wall -Wno-unused-function -Wno-comment/g" ${SRSLTE_DIR}/CMakeLists.txt 
sed -i -e "s/s = pthread_getaffinity_np(.*cpuset)/ { PTHREAD_GETAFFINITY(s, cpuset); }/g" ${SRSLTE_DIR}/lib/src/common/threads.c
sed -i -e "s/ dur.count()/ (long)dur.count()/g" -e "s/ duration_cast<TUnit>(tmax).count()/ (long)duration_cast<TUnit>(tmax).count()/g" -e "s/ duration_cast<TUnit>(tmin).count()/ (long)duration_cast<TUnit>(tmin).count()/g" ${SRSLTE_DIR}/lib/src/common/time_prof.cc
sed -i -e "s/__in6_u\.__u6_addr8/in6_u.u6_addr8/g" -e "s/linux\/udp\.h/netinet\/udp.h/g" ${SRSLTE_DIR}/srsue/src/stack/upper/tft_packet_filter.cc
sed -i -e "s/\<SHARED\>/STATIC/g" ${SRSLTE_DIR}/lib/src/phy/rf/CMakeLists.txt
sed -i -e "s/std::chrono::duration_cast<std::chrono::milliseconds>(dur).count/(long)std::chrono::duration_cast<std::chrono::milliseconds>(dur).count/g" ${SRSLTE_DIR}/srsue/src/stack/ue_stack_lte.cc
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/srsue/test/upper/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/ch_estimation/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/phch/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/sync/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/channel/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/ue/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/dft/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/resampling/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/phy/utils/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/src/radio/test/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/examples/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto sctp)/g" ${SRSLTE_DIR}/lib/test/common/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/test/phy/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/test/srslog/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/lib/test/upper/CMakeLists.txt
sed  -i -e "s/target_link_libraries(\([^)]*\))/target_link_libraries(\1 boost_program_options fftw3f mbedtls mbedcrypto)/g" ${SRSLTE_DIR}/srsue/test/upper/CMakeLists.txt

export COMMON_FLAGS="-g -fPIC -include ${SRSLTE_DIR}/tools.new/defines.h -I${SRSLTE_DIR}/tools.new -Dtimespec_get=gettimeofday -DTIME_UTC=NULL -I${BOOST}/include -I${SCTP}/include -I${LIBCONFIG}/include"
export SRSLTE_CFLAGS="${COMMON_FLAGS} "
export SRSLTE_CXXFLAGS="${COMMON_FLAGS} "
export SRSLTE_EXEFLAGS="-g -L${MBEDTLS}/lib -L${SCTP}/lib -L${BOOST}/libs/arm64-v8a -L${FFTW3_DIR}/lib -L${LIBCONFIG}/lib -lboost_program_options -lmbedtls -lmbedcrypto -lmbedx509 -lfftw3f -lsctp -lconfig -lconfig++"

cmake -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
      -DANDROID_PLATFORM=28 -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON \
      -DCMAKE_INSTALL_PREFIX=$PWD/../install.sd.linux \
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
      -DBoost_NO_BOOST_CMAKE=TRUE \
      -DBoost_NO_SYSTEM_PATHS=TRUE \
      -DBoost_LIBRARY_DIRS=${BOOST}/libs/arm64-v8a \
      -DBoost_LIBRARIES="boost_program_options" \
      -DENABLE_GPROF=ON \
      -DLIBCONFIGPP_INCLUDE_DIR=$LIBCONFIG/include \
      -DLIBCONFIGPP_LIBRARY=$LIBCONFIG/lib \
      -DLIBCONFIG_INCLUDE_DIR=$LIBCONFIG/include \
      -DLIBCONFIG_LIBRARY=config \
      -DLIBCONFIGPP_STATIC_LIBRARY=$LIBCONFIG/lib \
      -DLIBCONFIGPP_LIBRARIES="config++" \
      -DZEROMQ_INCLUDE_DIRS=$ZEROMQ/include \
      -DZEROMQ_LIBRARIES=zmq \
      -DZEROMQ_PKG_LIBRARY_DIRS=$ZEROMQ/lib \
      -DZEROMQ_LIBRARY_DIRS=$ZEROMQ/lib \
      -DFFTW3F_LIBRARY_DIRS=$FFTW/lib \
      -DFFTW3F_LIBRARY=$FFTW/lib \
      -DFFTW3F_LIBRARIES=$FFTW/lib \
      -DFFTW3F_STATIC_LIBRARY=$FFTW/lib \
      -DFFT_LIBRARIES=fftw3f \
      -DFFTW3F_INCLUDE_DIR=$FFTW/include \
      -DSCTP_LIBRARIES=$SCTP/lib \
      -DSCTP_INCLUDE_DIRS=$SCTP/include \
      -DSEC_LIBRARIES=$MBEDTLS/lib \
      -DMBEDTLS_LIBRARIES=$MBEDTLS/lib \
      -DBUILD_STATIC=OFF \
      -DRPATH=ON \
      -DCMAKE_EXE_LINKER_FLAGS="$SRSLTE_EXEFLAGS" \
      -DMBEDTLS_INCLUDE_DIRS=$MBEDTLS/include  \
      -DMBEDTLS_STATIC_LIBRARIES=$MBEDTLS/lib \
      .. $@

#-DCMAKE_C_STANDARD_LIRBARIES="$SRSLTE_EXEFLAGS" \
#-DCMAKE_CXX_STANDARD_LIRBARIES="$SRSLTE_EXEFLAGS" \
#-DMBEDTLS_LIBRARY=$MBEDTLS/lib \
#-DMBEDTLS_LIBRARY_DIRS=$MBEDTLS/lib \
#      -DBOOST_ROOT:PATHNAME=$BOOST \
#      -DBoost_INCLUDE_DIR=$BOOST/include \
#      -DBoost_USE_STATIC_LIBS=ON \
#      -DBoost_USE_MULTITHREADED=ON \
#     -DLIBCONFIG_PKG_LIBRARY_DIR=$LIBCONFIG/lib \
#     -DLIBCONFIG_LIBRARY_DIR=$LIBCONFIG/lib \
#-DSCTP_LIBRARY_DIRS=$SCTP/lib \
#-DSCTP_LIBRARY=$SCTP/lib \
