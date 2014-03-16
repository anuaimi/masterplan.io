#!/bin/bash

sudo apt-get update

# install dependencies
sudo apt-get install -y redis-server

# will install the latest version of nodejs
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs
sudo npm install -g coffee-script
sudo npm install -g hubot

#HUBOT_AUTH_ADMIN=

BOT_NAME=myhubot
hubot --create ${BOT_NAME}
cd ${BOT_NAME}
bin/hubot
