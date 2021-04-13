TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD
INST_DIR=install
set -x
echo 'export PATH=$PWD/bin:$PATH' > ${INST_DIR}/setup.source
echo 'export LD_LIBRARY_PATH=$PWD/lib64:$PWD/lib:.' >> ${INST_DIR}/setup.source
#if [ -d $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/install/arm64-v8a/lib ]; then
#    cp -rf $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/install/arm64-v8a/lib/* ${SRSLTE_DIR}/${INST_DIR}/lib/.
#fi
if [ -d $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a ]; then
    cp -rf $SRSLTE_DIR/$TOOLS_DIR/boost_for_android/build/install/libs/arm64-v8a/* ${SRSLTE_DIR}/${INST_DIR}/lib/.
fi
mkdir -p $INST_DIR/bin
mkdir -p $INST_DIR/share
mkdir -p $INST_DIR/lib 
mkdir -p $INST_DIR/lib64 
for i in boost_1_69_0 fftw-3.3.8 ncurses libconfig mbedtls libzmq lksctp-tools iris libusb uhd; do
install_comp_dir=$SRSLTE_DIR/$TOOLS_DIR/$i/install
if [ "$i" = "uhd" ]; then
install_comp_dir=$SRSLTE_DIR/$TOOLS_DIR/$i/host/install
cp -rf $install_comp_dir/share/* ${SRSLTE_DIR}/${INST_DIR}/share/. ;
fi
if [ -d $install_comp_dir/bin ]; then
    cp -rf $install_comp_dir/bin/* ${SRSLTE_DIR}/${INST_DIR}/bin/. ;
fi
if [ -d $install_comp_dir/lib ]; then
    cp -rf $install_comp_dir/lib/* ${SRSLTE_DIR}/${INST_DIR}/lib/. ;
fi
if [ -d $install_comp_dir/lib64 ]; then
    cp -rf $install_comp_dir/lib64/* ${SRSLTE_DIR}/${INST_DIR}/lib64/. ;
fi
done
sed -i -e "s/^SRSLTE_INSTALL_DIR.*$INST_DIR\//SRSLTE_INSTALL_DIR=\"\$PWD\//g" $INST_DIR/bin/srslte_install_configs.sh
tar -cvzf install.tar.gz install

