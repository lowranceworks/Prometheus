#!/bin/bash
sudo cp ./prometheus.yml /etc/prometheus/prometheus.yml -f

echo edit /etc/prometheus/prometheus.yml -f
echo restart prometheus after editting these files 
echo sudo systemctl restart prometheus