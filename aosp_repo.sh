#!/bin/bash
# http://liuwangshu.cn/framework/aosp/4-import-aosp.html
# https://source.android.com/setup/start/build-numbers#source-code-tags-and-builds
SHELL_PATH=$(pwd)

BRANCH=r-11.0
MIRROR="tuna"

DIR_PATH="$SHELL_PATH/android-$BRANCH"

if [ ! -d $DIR_PATH ]; then
    mkdir -p $DIR_PATH
fi

MANIFESTS_PATH=$DIR_PATH/.repo/manifests

curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -o $DIR_PATH/repo #使用tuna的git-repo镜像

chmod +x $DIR_PATH/repo

SED_FILE="_google"

if [[ $(uname) == 'Linux' ]]; then
    SED_FILE=""
fi

if [ "$MIRROR" == "tuna" ]; then
    sed -i $SED_FILE 's/https:\/\/gerrit.googlesource.com\/git-repo/https:\/\/mirrors.tuna.tsinghua.edu.cn\/git\/git-repo/g' $DIR_PATH/repo
else
    echo
fi

cd $DIR_PATH/

if [ ! -d $DIR_PATH/.repo ]; then
    $DIR_PATH/repo init -u https://github.com/aosp-11-lubancat/manifests -b $BRANCH
fi

$DIR_PATH/repo sync -c -v --force-sync --no-clone-bundle --no-tags
$DIR_PATH/repo forall -c 'git reset --hard'   
$DIR_PATH/repo forall -c git lfs pull