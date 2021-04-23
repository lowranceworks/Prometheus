#!/bin/bash

# create 
sudo useradd --no-create-home prometheus
sudo mkdir /etc/prometheus
sudo mkdir /kvar/lib/prometheus

# install prometheus 
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
tar xvfz prometheus-2.26.0.linux-amd64.tar.gz
sudo cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin
sudo cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
sudo cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
rm -rf prometheus-2.26.0.linux-amd64.tar.gz prometheus-2.26.0.linux-amd64

# add prometheus.yml and define prometheus as a service
sudo cp ./prometheus.yml /etc/prometheus/prometheus.yml
sudo cp ./prometheus.service /etc/systemd/system/prometheus.service

# configure permissions 
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /var/lib/prometheus

# configure systemd
sudo systemctl daemon-reload
sudo systemctl enable prometheus