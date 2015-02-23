#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Ensure various packages are installed
apt-get install sudo -y
apt-get install less -y
apt-get install bash-completion -y
apt-get install curl -y
apt-get install lsb-release -y

# Install OpenSSH
apt-get install openssh-server -y
echo 'UseDNS no' > /etc/ssh/sshd_config

# Download the insecure keypair
mkdir /home/vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys --no-check-certificate
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Allow sudo without a password
grep -q -e 'vagrant ALL=(ALL) NOPASSWD:ALL' /etc/sudoers || echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# install chef
curl -L https://www.chef.io/chef/install.sh | bash

#fix grub menu timeout
#
#  @TODO - do this using sed / programatically
#
# /etc/default/grub
# GRUB_HIDDEN_TIMEOUT_QUIET=true
# GRUB_TIMEOUT=0
#
# update-grub