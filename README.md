## 开发环境

| 系统    | mac os 14.0 或者 Ubuntu 20.04                              | 
|:--------|:-----------------------------------|
| 硬件  | 鲁班猫2V2                                | 
| android版本  | android-11.0.0_r48                                | 


## 下载系统
下载aosp-11.0.0_r48
```
./aosp_repo.sh
```
## 配置编译环境
### macOS 14.0
#### 使用sdk 10.15 编译
先下载[MacOSX10.15.sdk](https://github.com/phracker/MacOSX-SDKs/releases)复制到/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs目录下,
然后复制/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Info.plist到别的目录用xcode进行修改MinimumSDKVersion为10.15,然后复制回/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform,覆盖原来的Info.plist,

利用[brew](https://brew.sh/)安装dtc、gnu-sed和diffutils

```
brew install dtc
brew install gnu-sed
brew install diffutils
brew install pyenv
```

通过 pyenv 安装python 2.7.x,查看可以安装的2.7.x 版本
```
pyenv install --list
```
安装 2.7.18 版本
```
pyenv install 2.7.18
```
并且设定当前目录使用2.7.18版本
```
pyenv local 2.7.18
```

### Ubuntu 20.04
#### 安装相关依赖
```
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libgl1-mesa-dev \
gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libncurses5 libssl-dev \
libxml2-utils xsltproc unzip python2 bc imagemagick ccache schedtool libncurses* clang lz4 device-tree-compiler git-lfs
```

## 进行编译
默认编译是基于aosp-11.0.0_r48的鲁班猫2V2的1080P的mipi屏的镜像,并且默认使用-UCKAu的参数进行全局编译
,也可以按rockchip官方方法进行每个部分单独编译,U:编译u-boot,CK:使用clang编译编译Linux内核,K:就使用GCC编译Linux内核,A:编译Android,u:打包成update.img
```
./build_lubancat_2.sh
```

## 烧录镜像
按官方文档按MASKROM键使用usb连接电脑进入 MaskRom 模式,执行flashall_aosp.sh进行烧录
```
./flashall_aosp.sh
```

