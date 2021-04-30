#!/bin/bash

# install Alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar xvfz alertmanager-0.21.0.linux-amd64.tar.gz

sudo cp alertmanager-0.21.0.linux-amd64/alertmanager /usr/local/bin
sudo cp alertmanager-0.21.0.linux-amd64/amtool /usr/local/bin/
sudo mkdir /var/lib/alertmanager -f

rm -rf alertmanager-0.21.0*

# add Alertmanager configuration
sudo cp ./alertmanager.yml /etc/prometheus/

# configure Alertmanager as a service
sudo cp ./alertmanager.service /etc/systemd/system/

# configure systemd
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

# generate an app password

# create a rule 
sudo cp ./rules.yml /etc/prometheus/

# config prometheus 
sudo chown -R prometheus:prometheus /etc/prometheus

# update prometheus config file 
sudo cp ./prometheus.yml /etc/prometheus -f 

echo #############################################################################################################
echo create an app password 
echo edit /etc/prometheus/prometheus.yml 
echo edit /etc/systemd/system/alertmanager.service
echo restart prometheus after editting these files 

# reload systemd
# sudo systemctl restart prometheus