#!/bin/bash

# Remove unused kernels
apt-get purge -y $(dpkg -l 'linux-image-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d')

# Remove unnecessary packages
apt-get purge -y installation-report wireless-tools wpasupplicant

# Remove unnecessary folders and files in the home directories
for garbage in {.gem,.bash_history,.cache}; do
  rm -rf /root/$garbage
  rm -rf /home/vagrant/$garbage
done
rm -rf /.gem

# Remove APT files
apt-get clean -y
apt-get autoclean -y
apt-get autoremove -y
find /var/lib/apt -type f | xargs rm -f

# Remove Linux headers
rm -rf /usr/src/linux-headers*

# Remove locales
rm -rf /usr/share/locale/!(en|locale.alias)
locale-gen --purge en_US.UTF-8

# Remove documentation
rm -rf /usr/share/@(doc|man|groff|info|lintian|linda|man)/*
rm -rf /var/cache/man/*

# Do not install any documentation files
echo 'path-exclude /usr/share/doc/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc
echo 'path-exclude /usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc
echo 'path-exclude /usr/share/groff/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc
echo 'path-exclude /usr/share/info/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc
echo 'path-exclude /usr/share/lintian/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc
echo 'path-exclude /usr/share/linda/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc

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

# Defrag to aid in compacting
e4defrag /