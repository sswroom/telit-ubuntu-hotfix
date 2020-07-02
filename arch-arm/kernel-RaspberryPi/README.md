# Build the kernel module for Raspberry Pi

### Local building on Raspberry Pi OS

Upgrde the Raspberry Pi OS to the latest version.

```sh
pi@raspberrypi:~ $ sudo apt update && sudo apt -y dist-upgrade
pi@raspberrypi:~ $ sudo apt -y install build-essential raspberrypi-kernel-headers 
pi@raspberrypi:~ $ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
pi@raspberrypi:~ $ cd telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi
pi@raspberrypi:~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi $ sudo make install
```

### Cross-compiling on x86/x64 platform

```sh
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix.git
~$ cd telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi$ git clone --depth=1 https://github.com/raspberrypi/tools.git
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi$ git clone --depth=1 https://github.com/raspberrypi/linux.git
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi$ cd linux
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi/linux$ CROSS_COMPILE=../tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi- ARCH=arm make bcm2709_defconfig
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi/linux$ CROSS_COMPILE=../tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi- ARCH=arm make -j8
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi/linux$ cd ..
~/telit-ubuntu-hotfix/arch-arm/kernel-RaspberryPi$ CROSS_COMPILE=`pwd`/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi- ARCH_KDIR=`pwd`/linux/ make
```
