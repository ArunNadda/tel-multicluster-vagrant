#! /bin/bash

# Variable Declaration

export PATH=$PATH:/usr/local/bin

export DEBIAN_FRONTEND="noninteractive"
export PATH="$PATH:/usr/local/bin"

# install unzip and curl
echo "Installing dependencies ..."
apt-get -y install unzip curl jq net-tools

# install teleport
sudo apt-get update -y

curl https://deb.releases.teleport.dev/teleport-pubkey.asc | sudo apt-key add -
add-apt-repository 'deb https://deb.releases.teleport.dev/ stable main'
apt-get update -y
#apt install teleport



mkdir -p /etc/teleport/ssl
mkdir -p /var/log/teleport
cp /vagrant/tls/* /etc/teleport/ssl
cp /vagrant/tls/* /usr/local/share/ca-certificates
update-ca-certificates
