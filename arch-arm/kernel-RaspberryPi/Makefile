SDIR := kernel
USB_SERIAL_DIR := drivers/usb/serial
NET_USB_DIR := drivers/net/usb
MOD_USB_SERIAL_OPTION := option
MOD_USB_NET_QMI_WWAN := qmi_wwan

obj-m := \
	$(SDIR)/$(USB_SERIAL_DIR)/$(MOD_USB_SERIAL_OPTION).o \
	$(SDIR)/$(NET_USB_DIR)/$(MOD_USB_NET_QMI_WWAN).o
ODIR := /lib/modules/$(shell uname -r)/kernel
KDIR := /lib/modules/$(shell uname -r)/build
ifneq ($(ARCH_KDIR),)
	KDIR := $(ARCH_KDIR)
endif
PWD := $(shell pwd)

define TAB
	
endef

all: get-systeminfo clean
	$(MAKE) ARCH=arm -C $(KDIR) M=$(PWD) modules

install: all install-mod udev-rules

install-mod:
	$(info ************ Kernel Modules installing ************)
	if [ ! -d "$(ODIR)/$(USB_SERIAL_DIR)" ]; then mkdir -p $(ODIR)/$(USB_SERIAL_DIR); fi
	cp -f $(SDIR)/$(USB_SERIAL_DIR)/$(MOD_USB_SERIAL_OPTION).ko $(ODIR)/$(USB_SERIAL_DIR)
	if [ ! -d "$(ODIR)/$(NET_USB_DIR)" ]; then mkdir -p $(ODIR)/$(NET_USB_DIR); fi
	cp -f $(SDIR)/$(NET_USB_DIR)/$(MOD_USB_NET_QMI_WWAN).ko $(ODIR)/$(NET_USB_DIR)
	depmod -a

get-systeminfo:
	$(info ************ System Information ************)
	$(info SYSTEM INFO:)
	$(info $(TAB)$(shell lsb_release -i))
	$(info $(TAB)$(shell lsb_release -d))
	$(info $(TAB)$(shell lsb_release -r))
	$(info $(TAB)$(shell lsb_release -c))
	$(info KERNEL VERSION:)
	$(info $(TAB)$(shell uname -a))
	$(info GCC COMPILER:)
	$(info $(TAB)-dumpmachine: $(shell ${CROSS_COMPILE}${CC} -dumpmachine))
	$(info $(TAB)-dumpversion: $(shell ${CROSS_COMPILE}${CC} -dumpversion))
	$(info *********************************************)

udev-rules:
	$(info ************ udev rules installing ************)
	$(shell cp -f udev_rules.d/* /etc/udev/rules.d/)
	$(info Reload udev rules)
	$(shell udevadm control --reload-rules && udevadm trigger)

clean:
	$(MAKE) ARCH=arm -C $(KDIR) M=$(PWD) clean

