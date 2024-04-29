#!/bin/bash

# Remove unused kernels
yum clean all

# Clean up the tmp directory:
rm -rf /tmp/*

# Clean up history:
history -c

# Clear all log files
find /var/log -type f | xargs truncate --size 0

# Zero /
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

# Zero /boot
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

 # Zero swap
swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
if [ "$swappart" != "" ]; then
  swapoff $swappart;
  dd if=/dev/zero of=$swappart;
  mkswap $swappart;
  swapon $swappart;
fi

# Compact using VBoxManage
##  VBoxManage modifyhd --compact "[drive]:\[path_to_image_file]\[name_of_image_file].vdi"

rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
ln -sf /dev/null /etc/udev/rules.d/70-persistent-net.rules