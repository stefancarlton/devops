#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Hyper-V integration services
apt-get install linux-cloud-tools-virtual -y
apt-get install linux-cloud-tools-generic -y

# Install OpenSSH
apt-get install openssh-server -y
echo 'UseDNS no' > /etc/ssh/sshd_config

# Accept GIT_* shell variables from the client
sed -i -e 's/AcceptEnv LANG LC_*/AcceptEnv LANG LC_* GIT_/g' /etc/ssh/sshd_config

# Download the insecure keypair
mkdir /home/vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Allow sudo without a password
groupadd admin
adduser vagrant admin
deluser vagrant sudo
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Change root password
echo "root:vagrant" | chpasswd

# Install Ruby
add-apt-repository ppa:cirex/ruby -y
apt-get update
apt-get install ruby2.1 -y

# Install Puppet
gem install puppet --no-document
gem install rgen --no-document

# Create puppet user and group
useradd --system --user-group --home-dir /var/lib/puppet --no-create-home --shell /bin/false --comment 'Puppet configuration management daemon' puppet

for dir in /var/{run,lib,log}/puppet; do
  mkdir $dir --mode=750
  chown puppet:puppet $dir
done

for dir in /var/lib/puppet/{state,reports}; do
  mkdir $dir --mode=750
  chown puppet:puppet $dir
done

mkdir -p /etc/puppet/environments
mkdir -p /etc/puppet/manifests
mkdir -p /etc/puppet/modules

wget https://raw.githubusercontent.com/puppetlabs/puppet/master/conf/auth.conf -O /etc/puppet/auth.conf
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/fileserver.conf -O /etc/puppet/fileserver.conf
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppet.conf -O /etc/puppet/puppet.conf
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppet.logrotate -O /etc/logrotate.d/puppet
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppet.init -O /etc/init.d/puppet
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppetmaster.init -O /etc/init.d/puppetmaster
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppet.default -O /etc/default/puppet
wget https://raw.githubusercontent.com/puppetlabs/puppet/master/ext/debian/puppetmaster.default -O /etc/default/puppetmaster

chmod 755 /etc/init.d/puppet
chmod 755 /etc/init.d/puppetmaster