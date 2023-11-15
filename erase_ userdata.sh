#!/bin/bash
SHELL_PATH=$(pwd)

BRANCH=android11
AOSP_PATH=$SHELL_PATH/$BRANCH
if [ ! -n "$BRANCH" ]; then
    AOSP_PATH=$SHELL_PATH/android11
fi

PRODUCT=$1
if [ ! -n "$PRODUCT" ]; then
    PRODUCT=rk3568_lubancat_2_v2_mipi1080p
fi

source ${SHELL_PATH}/env_android.sh

#重启进入fastboot
adb reboot fastboot

fastboot erase userdata

fastboot reboot
