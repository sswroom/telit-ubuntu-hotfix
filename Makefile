KERNELVERSION := $(shell uname -r | cut -d'-' -f1)
OS:=$(shell uname -v)
SDIR := kernel-telit/linux-$(KERNELVERSION)
ODIR := /lib/modules/$(shell uname -r)/kernel
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
USB_SERIAL_DIR := drivers/usb/serial
NET_USB_DIR := drivers/net/usb
MOD_USB_SERIAL_OPTION := option
MOD_USB_SERIAL_WWAN := usb_wwan
MOD_USB_USBNET := usbnet
MOD_USB_NET_QMI_WWAN := qmi_wwan

QUIRK_DHCP := $(shell echo "$(KERNELVERSION)\n4.4.0" | sort -V | tail --line=1)
QUIRK_IP_ALIGNED := $(shell echo '$(KERNELVERSION)\n4.13.0' | sort -V | tail --line=1)
QUIRK_USB_WWAN := $(shell echo "$(KERNELVERSION)\n5.3.0" | sort -V | tail --line=1)

obj-m := \
	$(SDIR)/$(USB_SERIAL_DIR)/$(MOD_USB_SERIAL_OPTION).o \
	$(SDIR)/$(NET_USB_DIR)/$(MOD_USB_NET_QMI_WWAN).o

ifeq ("$(QUIRK_USB_WWAN)","5.3.0")
obj-m += $(SDIR)/$(USB_SERIAL_DIR)/$(MOD_USB_SERIAL_WWAN).o
$(info *** option: add ZLP support for Snapdragon X50 flashing device)
endif
ifeq ("$(QUIRK_DHCP)","4.4.0")
obj-m += $(SDIR)/$(NET_USB_DIR)/$(MOD_USB_USBNET).o
$(info *** usbnet: allow mini-drivers to consume L2 headers)
endif
ifeq ("$(QUIRK_IP_ALIGNED)","4.13.0")
obj-m += $(SDIR)/$(NET_USB_DIR)/$(MOD_USB_USBNET).o
$(info *** usbnet: fix alignment for frames with no ethernet header)
endif

define TAB
	
endef

all: get-systeminfo clean
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install: all install-mod udev-rules

install-mod:
	$(info ************ Kernel Modules installing ************)
	mkdir -p $(ODIR)/$(USB_SERIAL_DIR)
	cp -f $(SDIR)/$(USB_SERIAL_DIR)/$(MOD_USB_SERIAL_OPTION).ko $(ODIR)/$(USB_SERIAL_DIR)
	mkdir -p $(ODIR)/$(NET_USB_DIR)
	cp -f $(SDIR)/$(NET_USB_DIR)/$(MOD_USB_NET_QMI_WWAN).ko $(ODIR)/$(NET_USB_DIR)
ifeq ("$(QUIRK_DHCP)","4.4.0")
	cp -f $(SDIR)/$(NET_USB_DIR)/$(MOD_USB_USBNET).ko $(ODIR)/$(NET_USB_DIR)
endif
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
	$(info *********************************************)

udev-rules:
	$(info ************ udev rules installing ************)
	$(info OS: $(OS))
	@case '$(OS)' in \
	(*Ubuntu*) \
		cp -f udev_rules.d/* /etc/udev/rules.d/ \
		;; \
	(*) \
		;; \
	esac
	$(info Reload udev rules)
	$(shell udevadm control --reload-rules && udevadm trigger)

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f $(SDIR)/$(NET_USB_DIR)/*.o.ur-safe

