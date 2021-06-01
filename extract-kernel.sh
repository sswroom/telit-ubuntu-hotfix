#!/bin/sh

LISTS=/dev/shm/files.list
TYPE=
if [ -f "$1" ]; then
  TYPE=`file "$1" | cut -d ' ' -f2`
else
  echo "'$1' is not recognized as a compressed file"
  exit 1
fi

# generate the driver source code
ROOTP=`tar -tvf "$1" | head -1 | cut -d ':' -f2 | cut -d ' ' -f2`
cat << EOF > $LISTS
${ROOTP}include/linux/usb/usbnet.h
${ROOTP}include/linux/usb/cdc_ncm.h
${ROOTP}include/linux/usb/cdc.h
${ROOTP}include/linux/usb/cdc-wdm.h
${ROOTP}drivers/usb/serial/usb_wwan.c
${ROOTP}drivers/usb/serial/usb-wwan.h
${ROOTP}drivers/usb/serial/usb-serial.c
${ROOTP}drivers/usb/serial/usb-serial-simple.c
${ROOTP}drivers/usb/serial/option.c
${ROOTP}drivers/usb/serial/generic.c
${ROOTP}drivers/usb/serial/bus.c
${ROOTP}drivers/usb/class/cdc-wdm.c
${ROOTP}drivers/usb/class/cdc-acm.h
${ROOTP}drivers/usb/class/cdc-acm.c
${ROOTP}drivers/net/usb/usbnet.c
${ROOTP}drivers/net/usb/qmi_wwan.c
${ROOTP}drivers/net/usb/cdc_ncm.c
${ROOTP}drivers/net/usb/cdc_mbim.c
${ROOTP}drivers/net/usb/cdc_ether.c
${ROOTP}Makefile
EOF

case $TYPE in
  gzip)   tar -xf "$1" -I pigz -T $LISTS    ;;
  bzip2)  tar -xf "$1" -I pbzip2 -T $LISTS  ;;
  XZ)     tar -xf "$1" -I pxz -T $LISTS     ;;
  *)      echo "contents of '$1' cannot be extracted" ;;
esac

