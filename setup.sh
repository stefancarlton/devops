#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Ensure various packages are installed
apt-get install sudo -y
apt-get install less -y
apt-get install bash-completion -y

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
apt-get install chef -y