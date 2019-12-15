#!/bin/bash
cd $(dirname $0)
sudo /sbin/sysctl -w vm.max_map_count=262144
sudo docker build -t elkbox .
sudo docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 -v /usr/persistent/elk-data:/var/lib/elasticsearch -it elkbox