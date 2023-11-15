#!/bin/bash
SHELL_PATH=$(pwd)

BRANCH=android-r-11.0
if [ ! -n "$BRANCH" ]; then
    AOSP_PATH=android-r-11.0
fi
AOSP_PATH=$SHELL_PATH/$BRANCH

OPTS=$1
if [ ! -n "$OPTS" ]; then
    OPTS="-UCKAu"
fi

PRODUCT=$2
if [ ! -n "$PRODUCT" ]; then
    PRODUCT=rk3568_lubancat_2_v2_mipi1080p
fi

source envsetup.sh ${BRANCH} ${PRODUCT}

cd $AOSP_PATH/ && lunch ${PRODUCT}

cat <<-EOF > ${SHELL_PATH}/build_config
export PROJECT_TOP=$(gettop)
export KERNEL_ARCH=$(get_build_var PRODUCT_KERNEL_ARCH)
EOF

$AOSP_PATH/build.sh ${OPTS}
