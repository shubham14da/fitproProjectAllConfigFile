#!/bin/bash
sudo yum update -y
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum install python python-devel python-pip openssl ansible -y
sudo amazon-linux-extras install ansible2
sudo hostnamectl set-hostname ansible 

#install docker and docker-compose
Sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose  /usr/bin/docker-compose
