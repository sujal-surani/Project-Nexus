#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io unzip
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
./aws/install
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
