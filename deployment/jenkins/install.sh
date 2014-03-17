#!/bin/bash

# based on:
# http://gistflow.com/posts/492-jenkins-ci-setup-for-rails-application-from-scratch

sudo apt-get update

# install git 
sudo apt-get install -y git-core 

# install rvm
sudo apt-get install -y curl
curl -L https://get.rvm.io | bash -s stable --ruby
rvm install ruby-1.9.3

# install ruby 1.9.3
# sudo apt-get install -y ruby1.9.3 rubygems1.9.1
# sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
#          --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz \
#                         /usr/share/man/man1/ruby1.9.1.1.gz \
#         --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
#         --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
#         --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1
# sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.1 400 


# install capistrano 3.x
sudo gem install bundler --no-rdoc --no-ri
cat <<EOF > Gemfile
source 'https://rubygems.org'
gem 'capistrano', '~> 3.1.0' 
EOF
bundle install

# add jenkins repo to list 
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update

# install jenkins
# will automatically start jenkins on port 8080
sudo apt-get install -y jenkins
sudo service jenkins stop

sudo apt-get install -y nginx


# set admin password
# JENKINS_ADMIN_USER=root
# JENKINS_ADMIN_PWD=password
# --argumentsRealm.passwd.${JENKINS_ADMIN_USER}=${JENKINS_ADMIN_PWD}
# --argumentsRealm.roles.${JENKINS_ADMIN_USER}=admin

# get plugins
#cd /var/lib/jenkins/plugins
JENKINS_HOME=/var/lib/jenkins
cd $JENKINS_HOME/plugins
sudo wget http://updates.jenkins-ci.org/latest/git.hpi
sudo wget http://updates.jenkins-ci.org/latest/github.hpi
sudo wget http://updates.jenkins-ci.org/latest/slack.hpi
# rvm, ruby, logstash
sudo chown -R jenkins:nogroup ${JENKINS_HOME}/plugins
curl --data "" http://localhost:8080/reload

# restart jenkins
sudo service jenkins restart

sudo su jenkins
ssh-keygen -t rsa

# do we want any slaves?

# get jenkins config files from git
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080/ help


java -jar jenkins-cli.jar -s http://localhost:8080/ reload-configuration

# API calls
# -add_user( username, password, role)
# -remove_user( username)
