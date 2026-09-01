#!/bin/bash
apt-get update -y
apt-get install -y docker.io unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu