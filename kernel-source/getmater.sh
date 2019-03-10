#!/bin/sh

SOURCEPATH=https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain
TARGETPATH=$(pwd)/linux-master

if [ -d "$TARGETPATH" ]; then
  rm -rf "$TARGETPATH"
fi
mkdir -p "$TARGETPATH"

while read -r LINE; do
  SAVEPATH=$TARGETPATH/$(dirname $LINE)
  SAVEFILE=$TARGETPATH/$LINE
  if [ ! -d $SAVEPATH ]; then
    mkdir -p $SAVEPATH
  fi
  wget $SOURCEPATH/$LINE -O $SAVEFILE  
done <<EOF
Makefile
drivers/net/usb/usbnet.c
drivers/net/usb/qmi_wwan.c
drivers/net/usb/cdc_mbim.c
drivers/net/usb/cdc_ether.c
drivers/net/usb/cdc_ncm.c
drivers/usb/serial/bus.c
drivers/usb/serial/usb-wwan.h
drivers/usb/serial/generic.c
drivers/usb/serial/usb_wwan.c
drivers/usb/serial/option.c
drivers/usb/serial/usb-serial.c
drivers/usb/serial/usb-serial-simple.c
drivers/usb/class/cdc-acm.c
drivers/usb/class/cdc-acm.h
drivers/usb/class/cdc-wdm.c
include/linux/usb/usbnet.h
EOF

head -n 6 "$TARGETPATH/Makefile" > /dev/shm/tmp.Makefile
mv /dev/shm/tmp.Makefile "$TARGETPATH/Makefile"

