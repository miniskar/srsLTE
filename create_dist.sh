TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD
INST_DIR=install
echo 'export PATH=$PWD/bin:$PATH' > ${INST_DIR}/setup.source
echo 'export LD_LIBRARY_PATH=$PWD/lib:.' >> ${INST_DIR}/setup.source
cp -rf $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a/* ${SRSLTE_DIR}/${INST_DIR}/lib/.
for i in fftw-3.3.8 libconfig mbedtls libzmq lksctp-tools iris; do
cp -rf $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib/* ${SRSLTE_DIR}/${INST_DIR}/lib/. ;
done
tar -cvzf install.tar.gz install

