#!/bin/bash
cd $(dirname $0)
sudo apt-get update -y
sudo apt-get install openjdk-11-jdk apt-transport-https wget nginx -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update -y
sudo apt-get install elasticsearch=6.8.3 -y
chmod +x /tmp/generateElaticsearchProperties.sh
sudo sh generateElaticsearchProperties.sh

sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

sleep 5

curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-6.8.3.deb
sudo dpkg -i logstash-6.8.3.deb
sudo mv 30-output.conf /etc/logstash/conf.d/30-output.conf
sudo mv 12-json.conf /etc/logstash/conf.d/12-json.conf
sudo mv 02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf

sudo systemctl start logstash
sudo systemctl enable logstash

sleep 5

sudo apt-get install kibana=6.8.3 -y
chmod +x /tmp/generateKibanaProperties.sh
sudo sh generateKibanaProperties.sh

sudo systemctl start kibana
sudo systemctl enable kibana

sleep 5

echo "admin:`openssl passwd -apr1 kibanaadmin`" | sudo tee -a /etc/nginx/htpasswd.kibana
#chmod +x /tmp/generateNginxProperties.sh
#sudo sh generateNginxProperties.sh
sudo mv kibana /etc/nginx/sites-available/kibana

sudo ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/kibana
sudo nginx -t

sudo systemctl start nginx
sudo systemctl enable nginx
sudo ufw allow 'Nginx Full'

sleep 5

sudo systemctl restart nginx
sudo systemctl restart kibana
