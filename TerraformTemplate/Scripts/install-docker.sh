#!/bin/bash
sudo apt-get update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker