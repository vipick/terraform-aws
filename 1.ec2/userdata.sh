#!/bin/bash
cd /var
sudo mkdir www
sudo chown ec2-user www

# [nodejs 설치]
sudo yum -y install curl
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g pm2

# [git 설치]
sudo yum update -y
sudo yum install git -y

# [Amazon Linux 시간 설정]
sudo timedatectl set-timezone 'Asia/Seoul'