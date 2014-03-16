#!/bin/bash

sudo apt-get update

sudo apt-get install nodejs npm
apt-get install build-essential libssl-dev git-core redis-server libexpat1-dev

npm install -g coffee-script

cd /opt
git clone git://github.com/github/hubot.git && cd hubot
npm install
