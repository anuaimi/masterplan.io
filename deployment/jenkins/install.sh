#!/bin/bash

# add jenkins repo to list 
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update

# install jenkins
# will automatically start jenkins on port 8080
sudo apt-get install -y jenkins

# do we want any slaves?

# get jenkins config files from git
