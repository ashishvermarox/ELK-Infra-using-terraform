#!/bin/bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.3-amd64.deb
sudo dpkg -i filebeat-6.8.3-amd64.deb
sudo systemctl restart filebeat
sudo systemctl enable filebeat