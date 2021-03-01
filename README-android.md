srsLTE on Android
=================

## Build SRSLTE
There are two ways to run srsLTE on Android
### Compile using Android NDK (aarch64-linux-android*) toolchain
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
    

### Compile using Aarch64-gnu 
    Makesure to have ARM cross compiler toolchain (aarch64-linux-gnu-*) 7.5.0
    ```
    $ cd tools.new 
    $ sh install_tools.sh rootfs all 
    $ cd .. 
    $ mkdir build 
    $ cd build 
    $ sh ../build_sd.sh rootfs
    $ make -j16 
    $ make -j16 install
    $ cd ..
    $ sh create_dist.sh 
    ```
    The rootfs binaries are available in install.tar.gz


    


