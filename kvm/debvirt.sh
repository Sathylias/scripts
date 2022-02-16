#!/bin/bash
## Script automating the installation of my Debian + KVM virtualization server

packages=(qemu-system
          qemu-img
          libvirt-clients
          libvirt-daemon-system
          dnsmasq
          virtinst
          acpid
          bridge-utils
          libguestfs-tools)

# Modify grub config so that our Ethernet interface doesn't get modified
if [[ $(ls /sys/class/net | grep 'eth0') ]]; do
    sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
done

apt-get update && apt-get upgrade -y &&  
    apt-get install -y ${packages[*]} --no-install-recommends

# Create a bridge and disallow eth0 from getting an address
cat << EOF >> /etc/network/interfaces
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

iface eth0 inet manual
iface eth0 inet6 manual

auto br0
iface br0 inet static
        address 192.168.1.2
        netmask 255.255.255.0
        network 192.168.1.0
        broadcast 192.168.1.255
        gateway 192.168.1.1
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
        dns-nameservers 8.8.8.8

iface br0 inet6 auto
        accept_ra 1
EOF

