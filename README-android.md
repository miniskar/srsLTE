srsLTE on Android
=================
Please run the build on pharoah machine.

## Build SRSLTE
There are two ways to run srsLTE on Android

### Compile using Aarch64-gnu  (Recommended)
Makesure to have ARM cross compiler toolchain (aarch64-linux-gnu-*) 7.5.0

    ```
    $ source /home/nqx/setup_armtoolchain.source 
    $ cd tools.new 
    $ sh install_tools.sh rootfs all 
    $ cd .. 
    $ mkdir build 
    $ cd build 
    $ CMAKE=cmake3
    $ sh ../build_sd.sh rootfs
    $ make -j16 
    $ make -j16 install
    $ cd ..
    $ sh create_dist.sh 
    ```
    
### Compile using Android NDK (aarch64-linux-android*) toolchain (Alternative way)
1. Setup NDK toolchain either using below file or commands given below
    ```
    $ source /home/nqx/setup_android.source 
    ```
    
    or 

    ```   
    export ANDROID_DIR=/home/nqx/Android/
    export ANDROID_STUDIO=$ANDROID_DIR/android-studio
    export ANDROID_HOME=$ANDROID_DIR/Sdk
    export ANDROID_SDK=$ANDROID_DIR/Sdk
    export ANDROID_SDK_HOME=$ANDROID_SDK
    export ANDROID_NDK=$ANDROID_DIR/Sdk/ndk-bundle
    export ANDROID_NDK_HOME=$ANDROID_NDK
    export NDK=$ANDROID_NDK
    export NDK_DIR=$ANDROID_SDK/ndk/20.0.5594570
    export NDKROOT=$ANDROID_NDK
    export JAVA_HOME=$ANDROID_STUDIO/jre
    export PATH=$JAVA_HOME/bin:$PATH
    export PATH=$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$ANDROID_STUDIO/bin:$ANDROID_NDK:$ANDROID_NDK/toolchains/llvm:$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
    ```
    
2. Commands to build srsLTE
    ```
    $ cd tools.new 
    $ sh install_tools.sh android all 
    $ cd .. 
    $ mkdir build 
    $ cd build 
    $ sh ../build_sd.sh android 
    $ make -j16 
    $ make -j16 install
    $ cd ..
    $ sh create_dist.sh 
    ```
    The android binaries are available in install.tar.gz
    


The rootfs binaries are available in install.tar.gz

## Setup 
### Copy the build binaries (Same steps for both qualcomm boards)
    ```
    $ adb push install.tar.gz /data/loca/tmp/rootfs/.
    ```
### Enter android shell (Same steps for both qualcomm boards)
    ```
    $ adb shell
    ```
    
### Environment set and extract (Same steps for both qualcomm boards)
    ```
    $ setenforce 0
    $ ip rule add from all lookup default
    $ ip rule add from all lookup main
    $ cd /sdcard/storage
    $ chroot rootfs /bin/bash -l
    root@localhost:/# su -
    root@localhost:~# cd scratch/rootfs
    root@localhost:~/scratch/rootfs# tar -xvzf install.tar.gz 
    ```
    
### Setup the environment (Same steps for both qualcomm boards)
    ```
    root@localhost:~/scratch/rootfs# cd install
    root@localhost:~/scratch/rootfs/install# source ./setup.source
    root@localhost:~/scratch/rootfs/install# sh ./bin/srslte_install_configs.sh service --force 
    ```
    
## Run SRSLTE on Android
To run SRS, you have to run the below modules of SRS in the order as mentioned below. 

### Run srsLTE  (EPC) on Amundsen 
EPC executable (srsepc) requires special permissions to access /dev/net/tun. Either you need sudo permissions or setuid permissions
1. Configuration: Nothing has changed. Used default configuration
2. Run
    ```
    # You need access permissions for /dev/net/tun 
    root@AmundsenSD:~/scratch/rootfs/install#  srsepc  .config/epc.conf 
    ```
### Run srsLTE (ENB) on Amundsen
1. Configuration: Edit (`.config/enb.conf`)
    ```
    n_prb = 15         # Number of physical resource blocks
    device_name = zmq
    device_args = fail_on_disconnect=true,tx_port=tcp://*:4000,rx_port=tcp://<wlan-ip-address-of-mcmurdo-board>:4001,id=enb,base_srate=23.04e6
    ```
2. Run
    ```
    root@AmundsenSD:~/scratch/rootfs/install#  srsepc  .config/enb.conf
    ```
### Run srsLTE (UE) on Mcmurdo  
1. Enter adb shell and rootfs image 
2. Configuration: Edit (`.config/ue.conf`)
    ```
    device_name = zmq
    device_args = tx_port=tcp://*:4001,rx_port=tcp://<wlan-ip-address-of-amundsen-board>:4000,id=ue,base_srate=23.04e6
    ```
3. Run
    ```
    root@McmurdoSD:~/scratch/rootfs/install#  srsue  .config/ue.conf
    ```
4. Run with Valgrind  (Similar steps for ENB and EPC)
    ```
    $ valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes srsue .config/ue.conf
    $ kcachegrind  calldump.xxxxx  # on ubuntu to see the profiling
    $ qcachegrind  calldump.xxxxx  # on mac to see the profiling
    ```

5. Run with perf (Similar steps for ENB and EPC)
    ```
    $ sh -c " echo 0 > /proc/sys/kernel/kptr_restrict"
    $ perf record -g  srsue .config/ue.conf --log.all_level=info
    # afterwards to generate report
    $ perf   report
    ```
    
6. Test connections (Similar steps for ENB and EPC)
    ```
    $ ping 172.16.0.1  # From UE
    $ ping 172.16.0.2  # From ENB
    ```
   
7. Inject traffic 
    ```
    root@McmurdoSD:~/scratch/rootfs/install# iperf3 -s   # Start iperf server (SRSUE) Optional: -i 0.2
    root@AmundsenSD:~/scratch/rootfs/install# iperf3 -c 172.16.0.2 -u -b 4M -t 3600  # From SRSENB
    ```
    
8. Send messgae 
    ```
    root@McmurdoSD:~/scratch/rootfs/install#  netcat -u -l -p 2000 -s 172.16.0.2 # Listen on SRSUE
    root@AmundsenSD:~/scratch/rootfs/install# echo "Hello" | netcat -u 172.16.0.1 20000 # Send message from SRSENB
    ```



    


