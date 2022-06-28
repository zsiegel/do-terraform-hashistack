#! /bin/bash

# This is a test script - prefer to use cloud-init

export NOMAD_VERSION="1.3.1"

sudo apt update
sudo apt install -y wget unzip
wget -q -O /tmp/nomad.zip https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip /tmp/nomad.zip -d /usr/bin

mkdir -p /etc/nomad.d /opt/nomad