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

# start hubot
BOT_NAME=hubot
sudo mkdir -p /usr/local
cd /usr/local
sudo hubot --create ${BOT_NAME}

# create hubot user
sudo adduser --disabled-password --gecos "" hubot

# create upstart script to manage hubot
cat <<EOF > /etc/init/hubot.conf
description "Hubot Campfire bot"

# Campfire-specific environment variables. Change these:
#env HUBOT_CAMPFIRE_ACCOUNT='companyname' # the one in: <companyname>.campfirenow.com
#env HUBOT_CAMPFIRE_ROOMS='123456'
#env HUBOT_CAMPFIRE_TOKEN='afafafafafafafafafafcdcdcdcdcdcdcdcdcdc'

env HUBOT_SLACK_TOKEN=YBfpQr2qezl00n5VZsaq9MJC
env HUBOT_SLACK_TEAM=devfoundry
env HUBOT_SLACK_BOTNAME=slackbot

# Subscribe to these upstart events
# This will make Hubot start on system boot
start on filesystem or runlevel [2345]
stop on runlevel [!2345]

# Path to Hubot installation
env HUBOT_DIR='/usr/local/hubot/'
env HUBOT='bin/hubot'
#env ADAPTER='campfire'
#env ADAPTER='shell'
env ADAPTER='slack'
env HUBOT_USER='hubot' # system account
env HUBOT_NAME='${BOT_NAME}' # what hubot listens to
env PORT='5555'

# Keep the process alive, limit to 5 restarts in 60s
respawn
respawn limit 5 60

exec start-stop-daemon --start --chuid \${HUBOT_USER} --chdir \${HUBOT_DIR} \
  --exec \${HUBOT_DIR}\${HUBOT} -- --name \${HUBOT_NAME} --adapter \${ADAPTER}  >> /var/log/hubot.log 2>&1
EOF

start hubot


# connect desired adapter
#slack

# get our hubot's scripts from git
