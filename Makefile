KERNELVERSION := $(shell uname -r | cut -d'-' -f1)
SDIR := kernel-telit/linux-$(KERNELVERSION)
ODIR := /lib/modules/$(shell uname -r)/kernel
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
PORTDIR := drivers/usb/serial
UNETDIR := drivers/net/usb
MOD_USBPORT := option
MOD_USBNET := usbnet
MOD_QMIWWAN := qmi_wwan

QUIRK_DHCP := $(shell echo "$(KERNELVERSION)\n4.4.0" | sort -V | tail --line=1)
QUIRK_IP_ALIGNED := $(shell echo '$(KERNELVERSION)\n4.13.0' | sort -V | tail --line=1)

obj-m := $(SDIR)/$(PORTDIR)/$(MOD_USBPORT).o $(SDIR)/$(UNETDIR)/$(MOD_QMIWWAN).o
ifeq ("$(QUIRK_DHCP)","4.4.0")
obj-m += $(SDIR)/$(UNETDIR)/$(MOD_USBNET).o
$(info *** usbnet: allow mini-drivers to consume L2 headers)
endif
ifeq ("$(QUIRK_IP_ALIGNED)","4.13.0")
obj-m += $(SDIR)/$(UNETDIR)/$(MOD_USBNET).o
$(info *** usbnet: fix alignment for frames with no ethernet header)
endif

define TAB
	
endef

all: info clean
	$(MAKE) -C $(KDIR) M=$(PWD)

install: all
	mkdir -p $(ODIR)/$(PORTDIR)
	cp -f $(SDIR)/$(PORTDIR)/$(MOD_USBPORT).ko $(ODIR)/$(PORTDIR)
	mkdir -p $(ODIR)/$(UNETDIR)
	cp -f $(SDIR)/$(UNETDIR)/$(MOD_QMIWWAN).ko $(ODIR)/$(UNETDIR)
ifeq ("$(QUIRK_DHCP)","4.4.0")
	cp -f $(SDIR)/$(UNETDIR)/$(MOD_USBNET).ko $(ODIR)/$(UNETDIR)
endif
	depmod -a

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
	rm -f $(SDIR)/$(UNETDIR)/*.o.ur-safe

