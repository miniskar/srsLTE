TOOLS_DIR=tools.new
SRSLTE_DIR=$PWD
INST_DIR=install
set -x
echo 'export PATH=$PWD/bin:$PATH' > ${INST_DIR}/setup.source
echo 'export LD_LIBRARY_PATH=$PWD/lib64:$PWD/lib:.' >> ${INST_DIR}/setup.source
echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> ${INST_DIR}/setup.source
echo 'setenforce 0' >> ${INST_DIR}/setup.source
echo 'ip rule add from all lookup default' >> ${INST_DIR}/setup.source
echo 'ip rule add from all lookup main' >> ${INST_DIR}/setup.source
echo 'sh -c " echo 0 > /proc/sys/kernel/kptr_restrict"' >> ${INST_DIR}/setup.source
echo 'if [ ! -f "/dev/net/tun" ]; then' >> ${INST_DIR}/setup.source
echo '    mkdir -p /dev/net' >> ${INST_DIR}/setup.source
echo '    ln -s /dev/tun /dev/net/tun' >> ${INST_DIR}/setup.source
echo 'fi' >> ${INST_DIR}/setup.source

echo 'freq=$1' >> ${INST_DIR}/setup.source
echo 'for i in 0 1 2 3 4 5 6 7; do' >> ${INST_DIR}/setup.source
echo '    MINV=`cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq`;' >> ${INST_DIR}/setup.source
echo '    MAXV=`cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq`;' >> ${INST_DIR}/setup.source
echo '    VAL=$MAXV;' >> ${INST_DIR}/setup.source
echo '    if [ "x$freq" = "xmin" ]; then' >> ${INST_DIR}/setup.source
echo '        VAL=$MINV;' >> ${INST_DIR}/setup.source
echo '    fi' >> ${INST_DIR}/setup.source
echo '    echo "Core $i fMAX:$MAXV fMIN:$MINV set:$VAL";' >> ${INST_DIR}/setup.source
echo '    echo "userspace" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor;' >> ${INST_DIR}/setup.source
echo '    echo $VAL > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed;' >> ${INST_DIR}/setup.source
echo 'done' >> ${INST_DIR}/setup.source
echo 'mode=$2' >> ${INST_DIR}/setup.source
echo 'if [ "x$mode" != "x" ]; then' >> ${INST_DIR}/setup.source
echo '    count=0;' >> ${INST_DIR}/setup.source
echo '    for i in 0 1 2 3 4 5 6 7; do' >> ${INST_DIR}/setup.source
echo '        MASK=`echo $((0x1 << $i))`;' >> ${INST_DIR}/setup.source
echo '        VAL=`echo $((($mode & $MASK) != 0))`;' >> ${INST_DIR}/setup.source
echo '        if [ "x$VAL" = "x1" ]; then' >> ${INST_DIR}/setup.source
echo '            count=$((count+1))' >> ${INST_DIR}/setup.source
echo '        fi' >> ${INST_DIR}/setup.source
echo '    done' >> ${INST_DIR}/setup.source
echo '    if (( count < 2 )); then' >> ${INST_DIR}/setup.source
echo '        if (( mode >= 0xF )); then' >> ${INST_DIR}/setup.source
echo '            count=3' >> ${INST_DIR}/setup.source
echo '        fi' >> ${INST_DIR}/setup.source
echo '    fi' >> ${INST_DIR}/setup.source
echo '    if (( count >= 2 )); then' >> ${INST_DIR}/setup.source
echo '        for i in 0 1 2 3 4 5 6 7; do' >> ${INST_DIR}/setup.source
echo '            MASK=`echo $((0x1 << $i))`;' >> ${INST_DIR}/setup.source
echo '            VAL=`echo $((($mode & $MASK) != 0))`;' >> ${INST_DIR}/setup.source
echo '            if [ "x$VAL" = "x1" ]; then' >> ${INST_DIR}/setup.source
echo '                echo "Core $i Enabled";' >> ${INST_DIR}/setup.source
echo '                echo "1" > /sys/devices/system/cpu/cpu$i/online' >> ${INST_DIR}/setup.source
echo '            else' >> ${INST_DIR}/setup.source
echo '                echo "Core $i Disabled";' >> ${INST_DIR}/setup.source
echo '                echo "0" > /sys/devices/system/cpu/cpu$i/online' >> ${INST_DIR}/setup.source
echo '            fi' >> ${INST_DIR}/setup.source
echo '        done' >> ${INST_DIR}/setup.source
echo '    else' >> ${INST_DIR}/setup.source
echo '        echo "Mode:${mode} make the processor very slow"' >> ${INST_DIR}/setup.source
echo '    fi ;' >> ${INST_DIR}/setup.source
echo 'fi' >> ${INST_DIR}/setup.source


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

