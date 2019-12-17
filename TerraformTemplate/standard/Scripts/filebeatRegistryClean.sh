#!/bin/bash
cd $(dirname $0)
sudo systemctl stop filebeat
sudo rm /var/lib/filebeat/registry
sudo cp filebeat.yml /etc/filebeat/filebeat.yml
sudo systemctl restart filebeat