#!/bin/bash

# NEED statsd 

# based on:
# https://gist.github.com/jgeurts/3112065

sudo apt-get update

wget https://launchpad.net/graphite/0.9/0.9.10/+download/graphite-web-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/carbon-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/whisper-0.9.10.tar.gz
tar -zxvf graphite-web-0.9.10.tar.gz
tar -zxvf carbon-0.9.10.tar.gz
tar -zxvf whisper-0.9.10.tar.gz
mv graphite-web-0.9.10 graphite
mv carbon-0.9.10 carbon
mv whisper-0.9.10 whisper
rm graphite-web-0.9.10.tar.gz
rm carbon-0.9.10.tar.gz
rm whisper-0.9.10.tar.gz

sudo apt-get install --assume-yes apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 build-essential python3.2 python-dev libpython3.2 python3-minimal libapache2-mod-wsgi libaprutil1-ldap memcached python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect ssh libapache2-mod-python python-setuptools
sudo easy_install django-tagging 
sudo easy_install zope.interface
sudo easy_install twisted
sudo easy_install txamqp
 
####################################
# INSTALL WHISPER
####################################
 
pushd whisper
sudo python setup.py install
popd

####################################
# INSTALL CARBON
####################################
 
pushd carbon
sudo python setup.py install
popd

cd /opt/graphite/conf
sudo cp carbon.conf.example carbon.conf
sudo bash -c "cat <<EOF > storage-schemas.conf
### Replace contents of storage-schemas.conf to be the following
[stats]
priority = 110
pattern = .*
retentions = 10:2160,60:10080,600:262974
###
EOF"

 
####################################
# CONFIGURE GRAPHITE (webapp)
####################################
 
pushd graphite
sudo python check-dependencies.py
sudo python setup.py install
popd

# CONFIGURE APACHE
###################
pushd graphite/examples
sudo cp example-graphite-vhost.conf /etc/apache2/sites-available/default
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
popd
sudo mkdir /etc/httpd
sudo mkdir /etc/httpd/wsgi
sudo sed -i 's_run/wsgi_/etc/httpd/wsgi_g' /etc/apache2/sites-available/default

sudo /etc/init.d/apache2 reload
 
 
####################################
# INITIAL DATABASE CREATION
####################################
cd /opt/graphite/webapp/graphite/
sudo python manage.py syncdb
# follow prompts to setup django admin user
sudo chown -R www-data:www-data /opt/graphite/storage/
sudo /etc/init.d/apache2 restart
cd /opt/graphite/webapp/graphite
sudo cp local_settings.py.example local_settings.py
 
####################################
# START CARBON
####################################
cd /opt/graphite/
sudo ./bin/carbon-cache.py start
