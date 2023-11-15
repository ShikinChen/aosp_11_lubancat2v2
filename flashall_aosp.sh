#!/bin/bash
SHELL_PATH=$(pwd)

BRANCH=$1
if [ ! -n "$BRANCH" ]; then
    BRANCH=android-r-11.0
fi

AOSP_PATH=$SHELL_PATH/$BRANCH

PRODUCT=$1
if [ ! -n "$PRODUCT" ]; then
    PRODUCT=rk3568_lubancat_2_v2_mipi1080p
fi

source ${SHELL_PATH}/env_android.sh ${BRANCH}

#重启进入loader
adb shell reboot loader

upgrade_tool uf ${AOSP_PATH}/rockdev/Image-${PRODUCT}/update.img