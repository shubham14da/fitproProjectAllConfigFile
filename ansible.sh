#!/bin/bash

sudo yum update -y

sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install python python-devel python-pip openssl ansible -y

sudo amazon-linux-extras install ansible2 -y

sudo hostnamectl set-hostname ansible-stagging-master

sudo amazon-linux-extras install java-openjdk11 -y

sudo yum install docker -y

sudo systemctl start docker -y

sudo systemctl enable docker

sudo yum install git -y

