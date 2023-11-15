#!/bin/bash
SHELL_PATH=$(pwd)

LOG_PATH=$1

BRANCH=$2
if [ ! -n "$BRANCH" ]; then
    BRANCH=android11
fi
AOSP_PATH=$SHELL_PATH/$BRANCH

PRODUCT=$3
if [ ! -n "$PRODUCT" ]; then
    PRODUCT=rk3568_lubancat_2_v2_mipi1080p
fi

python $SHELL_PATH/symbolize.py \
    -s \
    ${AOSP_PATH}/out/target/product/${PRODUCT}/symbols/ \
    -l \
    ${LOG_PATH} \
    -sp \
    ${AOSP_PATH}/prebuilts/clang/host/darwin-x86/clang-r383902b/bin/llvm-symbolizer
