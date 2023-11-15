#!/bin/bash
SHELL_PATH=$(pwd)

BRANCH=$1
if [ ! -n "$BRANCH" ]; then
    BRANCH=android-r-11.0
fi
AOSP_PATH=$SHELL_PATH/$BRANCH

PRODUCT=$2
if [ ! -n "$PRODUCT" ]; then
    PRODUCT=rk3568_lubancat_2_v2_mipi1080p
fi

ADB_DIR_PATH=$AOSP_PATH/device/rockchip/rk356x/${PRODUCT}/security/adb

if [ ! -d $ADB_DIR_PATH ]; then
    mkdir -p $ADB_DIR_PATH
fi
if [ -f ~/.android/adbkey.pub ]; then
    cp ~/.android/adbkey.pub $ADB_DIR_PATH/adbkey.pub
elif [ -f $SHELL_PATH/adbkey.pub ]; then
    cp $SHELL_PATH/adbkey.pub $ADB_DIR_PATH/adbkey.pub
fi

source $AOSP_PATH/build/envsetup.sh

# KERNEL_ARCH=$(get_build_var PRODUCT_KERNEL_ARCH)

result=$(echo "$PRODUCT" | grep "-eng")
if [ "$result" == "" ]; then
    PRODUCT=${PRODUCT}-userdebug
fi

if [ "$(uname)" == "Darwin" ]; then
    export PATH=/usr/local/opt/gnu-sed/libexec/gnubin/:${PATH}
    alias diff=diff3
fi

unset NDK_ROOT
unset SDK_ROOT
ulimit -S -n 2048

# export SANITIZE_TARGET=hwaddress
