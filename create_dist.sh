TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD
INST_DIR=install
set -x
echo 'export PATH=$PWD/bin:$PATH' > ${INST_DIR}/setup.source
echo 'export LD_LIBRARY_PATH=$PWD/lib64:$PWD/lib:.' >> ${INST_DIR}/setup.source
if [ -d $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a ]; then
    cp -rf $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a/* ${SRSLTE_DIR}/${INST_DIR}/lib/.
fi
mkdir -p $INST_DIR/lib 
mkdir -p $INST_DIR/lib64 
for i in boost_1_69_0 fftw-3.3.8 libconfig mbedtls libzmq lksctp-tools iris; do
if [ -d $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib ]; then
    cp -rf $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib/* ${SRSLTE_DIR}/${INST_DIR}/lib/. ;
fi
if [ -d $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib64 ]; then
    cp -rf $SRSLTE_DIR/$TOOLS_DIR/$i/install/lib64/* ${SRSLTE_DIR}/${INST_DIR}/lib64/. ;
fi
done
sed -i -e "s/^SRSLTE_INSTALL_DIR.*$INST_DIR\//SRSLTE_INSTALL_DIR=\$PWD\//g" $INST_DIR/bin/srslte_install_configs.sh
tar -cvzf install.tar.gz install

