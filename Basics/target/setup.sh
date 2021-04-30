# create user for prometheus node exporter
sudo useradd --no-create-home node_exporter

# install binaries
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar xzf node_exporter-1.1.2.linux-amd64.tar.gz
sudo cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.1.2.linux-amd64.tar.gz node_exporter-1.1.2.linux-amd64

# configure service
sudo cp ./node-exporter.service /etc/systemd/system/

# configure systemd
sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter

# prompt next steps 
echo ssh into the prometheus server and add this target to /etc/prometheus/prometheus.yml
echo after applying those changes, restart prometheus