# telit-ubuntu-hotfix

### The Linux Kernel USB Drivers of Telit Modules

Supported Ubuntu Release:
* Ubunru 12.04.2 LTS (Kernel v3.5/v3.8/v3.11/v3.13)
* Ubuntu 14.04.x LTS (Kernel v3.13/v3.16/v3.19/v4.2/v4.4)
* Ubuntu 16.04.x LTS (Kernel v4.4/v4.8/v4.10/v4.13/v4.15)
* Ubuntu 18.04.x LTS (Kernel v4.15/v4.18/v5.0/v5.3)
* Until Ubuntu 19.10

Build and Installation

```sh
~$ git clone https://gitlab.com/subnike.tw/telit-ubuntu-hotfix
~$ cd telit-ubuntu-hotfix
~/telit-ubuntu-hotfix$ sudo make install
```

If you had inserted the modules into the Kernel, you would remove and then add again
```sh
~$ sudo modprobe -r qmi_wwan
~$ sudo modprobe -r option
~$ sudo modprobe option
~$ sudo modprobe qmi_wwan
```

Should get the messages like the following in dmesg

```sh
~$ dmesg
[  159.590901] usb 2-4.3: new SuperSpeed USB device number 5 using xhci_hcd
[  159.616271] usb 2-4.3: New USB device found, idVendor=1bc7, idProduct=1900
[  159.616278] usb 2-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  159.616282] usb 2-4.3: Product: QUSB_Fast_Enum.
[  159.616286] usb 2-4.3: Manufacturer: Qualcomm CDMA Technologies MSM
[  159.621216] usb 2-4.3: Set SEL for device-initiated U1 failed.
[  159.624751] usb 2-4.3: Set SEL for device-initiated U2 failed.
[  159.624929] option 2-4.3:1.0: GSM modem (1-port) converter detected
[  159.625253] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB0
[  159.639282] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
[  159.639301] option 2-4.3:1.0: device disconnected
[  160.331386] option 2-4.3:1.0: GSM modem (1-port) converter detected
[  160.331744] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB0
[  160.332397] usb 2-4.3: USB disconnect, device number 5
[  160.333004] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
[  160.333062] option 2-4.3:1.0: device disconnected
[  165.335062] usb 2-4.3: new SuperSpeed USB device number 6 using xhci_hcd
[  165.356424] usb 2-4.3: New USB device found, idVendor=1bc7, idProduct=1900
[  165.356430] usb 2-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  165.356434] usb 2-4.3: Product: Telit LN940 Mobile Broadband
[  165.356438] usb 2-4.3: Manufacturer: Telit
[  165.356442] usb 2-4.3: SerialNumber: 0123456789ABCDEF
[  165.384063] usb 2-4.3: Enable of device-initiated U1 failed.
[  165.384971] usb 2-4.3: Enable of device-initiated U2 failed.
[  165.385173] option 2-4.3:1.0: GSM modem (1-port) converter detected
[  165.385454] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB0
[  165.391715] usb 2-4.3: Disable of device-initiated U1 failed.
[  165.392192] usb 2-4.3: Disable of device-initiated U2 failed.
[  165.393158] qmi_wwan 2-4.3:1.1: cdc-wdm1: USB WDM device
[  165.400078] qmi_wwan 2-4.3:1.1 wwan0: register 'qmi_wwan' at usb-0000:00:14.0-4.3, WWAN/QMI device, 0e:f9:5c:fe:85:0a
[  165.401040] usb 2-4.3: Enable of device-initiated U1 failed.
[  165.401697] usb 2-4.3: Enable of device-initiated U2 failed.
[  165.402014] option 2-4.3:1.2: GSM modem (1-port) converter detected
[  165.402290] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB1
[  165.402733] option 2-4.3:1.3: GSM modem (1-port) converter detected
[  165.402975] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB2
[  165.403326] option 2-4.3:1.4: GSM modem (1-port) converter detected
[  165.403531] usb 2-4.3: GSM modem (1-port) converter now attached to ttyUSB3
```

Test QMI wth qmicli (libqmi - https://www.freedesktop.org/wiki/Software/libqmi/)

```sh
~$ sudo ip link set wwan0 down
~$ sudo qmicli -d /dev/cdc-wdm1 --set-expected-data-format=raw-ip
[/dev/cdc-wdm1] expected data format set to: raw-ip
~$ sudo qmicli -d /dev/cdc-wdm1 --wds-start-network="apn=internet,ip-type=4" --client-no-release-cid
[/dev/cdc-wdm1] Network started
	Packet data handle: '744952640'
[/dev/cdc-wdm1] Client ID not released:
	Service: 'wds'
	    CID: '21'
~$ sudo qmicli -d /dev/cdc-wdm1 --wds-get-current-settings --client-no-release-cid --client-cid=21
[/dev/cdc-wdm1] Current settings retrieved:
           IP Family: IPv4
        IPv4 address: 100.99.101.156
    IPv4 subnet mask: 255.255.255.248
IPv4 gateway address: 100.99.101.157
    IPv4 primary DNS: 210.200.211.225
  IPv4 secondary DNS: 210.200.211.193
                 MTU: 1500
             Domains: none
[/dev/cdc-wdm1] Client ID not released:
	Service: 'wds'
	    CID: '21'
~$ ip link show wwan0
11: wwan0: <POINTOPOINT,MULTICAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none
~$ sudo ip link set wwan0 mtu 1500
~$ sudo udhcpc -i wwan0
udhcpc (v1.22.1) started
Sending discover...
Sending select for 100.99.101.156...
Lease of 100.99.101.156 obtained, lease time 7200
~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=53 time=164 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=53 time=23.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=53 time=41.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=53 time=41.8 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 23.777/67.955/164.764/56.366 ms
~$ sudo qmicli -d /dev/cdc-wdm1 --wds-stop-network=744952640 --client-cid=21
Network cancelled... releasing resources
[/dev/cdc-wdm1] Network stopped
~$ sudo ip link set wwan0 down
```

