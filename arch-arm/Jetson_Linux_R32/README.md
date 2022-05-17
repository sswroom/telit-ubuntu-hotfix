# Build the kernel module for Jetson AGX Xavier, Xavier NX, TX2, TX1 and Nano

### Local building on Nvidia Jetson platform

Upgrde the Jetson Linux to the latest version.

```sh
~$ sudo apt update && sudo apt -y dist-upgrade
~$ sudo apt -y install build-essential nvidia-l4t-kernel-headers
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
~$ cd telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ sudo make install
```

### Cross-compiling on x86/x64 platform

Based on NVIDIA L4T 32.4.2 (https://developer.nvidia.com/embedded/linux-tegra-r32.4.2)

```sh
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
~$ cd telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ wget -O gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz https://developer.nvidia.com/embedded/dlc/l4t-gcc-7-3-1-toolchain-64-bit
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ tar Jxf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ wget -O Tegra186_Linux_R32.4.2_aarch64.tbz2 https://developer.nvidia.com/embedded/L4T/r32_Release_v4.2/t186ref_release_aarch64/Tegra186_Linux_R32.4.2_aarch64.tbz2
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ tar jxf Tegra186_Linux_R32.4.2_aarch64.tbz2 Linux_for_Tegra/kernel/kernel_headers.tbz2
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ tar jxf Linux_for_Tegra/kernel/kernel_headers.tbz2 -C Linux_for_Tegra/kernel
~/telit-ubuntu-hotfix/arch-arm/Jetson_Linux_R32$ CROSS_COMPILE=`pwd`/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- CC=gcc ARCH_KDIR=`pwd`/Linux_for_Tegra/kernel/linux-headers-4.9.140-tegra-linux_x86_64/kernel-4.9/ make
```
