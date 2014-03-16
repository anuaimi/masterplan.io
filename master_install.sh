#!/bin/bash

# create VMs for hubot
# use fog & digitalocean
./deployment/hubot/install.sh

./deployment/jenkins/install.sh
