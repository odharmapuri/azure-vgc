#!/bin/bash
sudo apt update
sudo apt install rabbitmq-server -y
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_user_tags admin administrator
sudo apt install memcached -y
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server
sudo systemctl enable memcached
sudo systemctl start memcached