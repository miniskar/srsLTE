TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD
INST_DIR=install.sd.linux
cp -rf $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a/* ${SRSLTE_DIR}/${INST_DIR}/lib/.
for i in fftw-3.3.8 libconfig mbedtls libzmq lksctp-tools; do
cp -rf $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib/* ${SRSLTE_DIR}/${INST_DIR}/lib/. ;
done

echo 'export LD_LIBRARY_PATH=$PWD/lib:.' > ${INST_DIR}/setup.source
