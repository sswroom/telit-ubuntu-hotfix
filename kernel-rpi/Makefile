SOURCE_DIR := kernel
SERIAL_DIR := drivers/usb/serial
USBNET_DIR := drivers/net/usb
MODULE_SERIAL := option
MODULE_WWAN := qmi_wwan

UDEV_DIR := udev/rules.d

obj-m := $(SOURCE_DIR)/$(SERIAL_DIR)/$(MODULE_SERIAL).o $(SOURCE_DIR)/$(USBNET_DIR)/$(MODULE_WWAN).o
ODIR := /lib/modules/$(shell uname -r)/kernel
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all: info clean
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install: all
	if [ ! -d "$(ODIR)/$(SERIAL_DIR)" ]; then mkdir -p $(ODIR)/$(SERIAL_DIR); fi
	cp -f $(SOURCE_DIR)/$(SERIAL_DIR)/$(MODULE_SERIAL).ko $(ODIR)/$(SERIAL_DIR)
	if [ ! -d "$(ODIR)/$(USBNET_DIR)" ]; then mkdir -p $(ODIR)/$(USBNET_DIR); fi
	cp -f $(SOURCE_DIR)/$(USBNET_DIR)/$(MODULE_WWAN).ko $(ODIR)/$(USBNET_DIR)
	depmod -a
	cp -f $(UDEV_DIR)/* /etc/$(UDEV_DIR)
	udevadm control --reload-rules && udevadm trigger

info:
	$(info ************  System Information ************)
	$(info SYSTEM INFO:)
	$(info $(TAB)$(shell lsb_release -i))
	$(info $(TAB)$(shell lsb_release -d))
	$(info $(TAB)$(shell lsb_release -r))
	$(info $(TAB)$(shell lsb_release -c))
	$(info KERNEL VERSION:)
	$(info $(TAB)$(shell uname -a))
	$(info ************  System Information ************)

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

