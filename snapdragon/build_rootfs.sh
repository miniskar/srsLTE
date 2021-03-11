VCMAKE="cmake"
if [ ! -z "${CMAKE}" ]; then
    VCMAKE=${CMAKE}
fi

export TARGET=aarch64-linux-gnu
export CC=$TARGET-gcc
export CXX=$TARGET-g++
export LD=$TARGET-ld
export AR=$TARGET-ar
export RANLIB=$TARGET-ranlib
export STRIP=$TARGET-strip
${VCMAKE} -DUSE_NDK=OFF -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON .. $@
