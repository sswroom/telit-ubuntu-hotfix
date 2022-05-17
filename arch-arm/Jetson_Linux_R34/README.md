# Build the kernel module for Jetson AGX Orin Developer Kit, AGX Xavier series, Xavier NX series

### Local building on Nvidia Jetson platform

Upgrde the Jetson Linux to the latest version.

```sh
~$ sudo apt update && sudo apt -y dist-upgrade
~$ sudo apt -y install build-essential nvidia-l4t-kernel-headers
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
~$ cd telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ sudo make install
```

### Cross-compiling on x86/x64 platform

Based on NVIDIA L4T 34.1 (https://developer.nvidia.com/embedded/jetson-linux-r341)

```sh
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
~$ cd telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ wget -O aarch64--glibc--stable-final.tar.gz https://developer.nvidia.com/embedded/jetson-linux/bootlin-toolchain-gcc-93
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ mkdir -p toolchain
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ tar xf aarch64--glibc--stable-final.tar.gz -C toolchain
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ wget -O Jetson_Linux_R34.1.0_aarch64.tbz2 https://developer.nvidia.com/embedded/l4t/r34_release_v1.0/release/jetson_linux_r34.1.0_aarch64.tbz2
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ tar jxf Jetson_Linux_R34.1.0_aarch64.tbz2 Linux_for_Tegra/kernel/kernel_headers.tbz2
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ tar jxf Linux_for_Tegra/kernel/kernel_headers.tbz2 -C Linux_for_Tegra/kernel
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R34$ CROSS_COMPILE=`pwd`/toolchain/bin/aarch64-linux- CC=gcc ARCH_KDIR=`pwd`/Linux_for_Tegra/kernel/linux-headers-5.10.65-tegra-linux_x86_64/kernel-5.10/ make
```
