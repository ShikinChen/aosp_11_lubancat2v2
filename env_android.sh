#!/bin/bash
SHELL_PATH=$(pwd)

BRANCH=$1
if [ ! -n "$BRANCH" ]; then
    BRANCH=android-r-11.0
fi
AOSP_PATH=$SHELL_PATH/$BRANCH

RK_TOOLS_PATH=${AOSP_PATH}/RKTools/linux

RK_TOOLS_BIN_PATH=${AOSP_PATH}/rkbin/tools

UPGRADE_TOOL_NAME=Linux_Upgrade_Tool_v2.4

IS_MAC_OS=false

if [ "$(uname)" == "Darwin" ]; then
    RK_TOOLS_PATH=${AOSP_PATH}/RKTools/mac
    UPGRADE_TOOL_NAME=upgrade_tool_v2.3_mac
    IS_MAC_OS=true
fi

PGRADE_TOOL_PATH=${RK_TOOLS_PATH}/upgrade_tool

if [ ! -d $PGRADE_TOOL_PATH/${UPGRADE_TOOL_NAME} ]; then
    unzip ${PGRADE_TOOL_PATH}/${UPGRADE_TOOL_NAME}.zip -d ${PGRADE_TOOL_PATH}
    chmod +x $PGRADE_TOOL_PATH/${UPGRADE_TOOL_NAME}/upgrade_tool
fi

export PATH=$PATH:${RK_TOOLS_PATH}/adb_fastboot:$PGRADE_TOOL_PATH/${UPGRADE_TOOL_NAME}

# export PATH=$PATH:${RK_TOOLS_PATH}/Linux_adb_fastboot:$RK_TOOLS_BIN_PATH
