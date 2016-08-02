#!/bin/bash

# The default repo has an old version of postgres, we need to exclude it
sudo sed -e 's/\[base\]/[base]\
exclude=postgresql*/g' /etc/yum.repos.d/CentOS-Base.repo | sed -e 's/\[updates\]/[updates]\
exclude=postgresql*/g' > /tmp/CentOS-Base.repo
sudo mv /tmp/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# Postgres9.3, PHP5.5 and xdebug are all out of data on the default centos repos, so we need to add a few
sudo yum -y localinstall http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm

# Apply the above changes and make sure we are all up to date
sudo yum check-update -y

# Download all the software we need
# For Debugging - we can test one by one
#sudo yum install -y postgresql93.x86_64
#sudo yum install -y postgresql93-server.x86_64
#sudo yum install -y postgresql93-contrib.x86_64
#sudo yum install -y httpd.x86_64
#sudo yum install -y php55w php55w-opcache
#sudo yum install -y php55w-pgsql.x86_64
#sudo yum install -y php55w-mcrypt.x86_64
#sudo yum install -y php55w-mbstring.x86_64
#sudo yum install -y php55w-gd.x86_64
#sudo yum install -y php55w-pecl-xdebug.x86_64
#sudo yum install -y php55w-pear.noarch
#sudo yum install -y php55w-devel
#sudo yum install -y php55w-process
#sudo yum install -y php-domxml-php4-php5.noarch
#sudo yum install -y siege
#sudo yum install -y telnet
#sudo yum install -y redis
#sudo yum install -y git

# For Speed - yum's mirror check is pretty slow, let's just do it once for all the software
sudo yum install -y postgresql93.x86_64 postgresql93-server.x86_64 postgresql93-contrib.x86_64 httpd.x86_64 php55w php55w-opcache php55w-pgsql.x86_64 php55w-mcrypt.x86_64 php55w-gd.x86_64 php55w-pecl-xdebug.x86_64 php55w-pear.noarch php55w-devel php55w-process php55w-mbstring.x86_64 php-domxml-php4-php5.noarch siege telnet git
sudo yum --enablerepo=remi -y install redis

# make sure locate works 
sudo updatedb

# Install phpunit through composer rather than yum, so that it works correctly with laravel
mkdir /home/vagrant/bin # this is vagrants natural executable dir.  Already in $PATH
cd /home/vagrant/bin

# Adding php-cs-fixer
curl http://get.sensiolabs.org/php-cs-fixer.phar -o php-cs-fixer

curl -sS https://getcomposer.org/installer | php
ln -s composer.phar composer
sudo php composer self-update
cd /vagrant

sudo php composer install
sudo ln -s /vagrant/vendor/bin/phpunit /usr/local/bin/phpunit 

# install phing for managing builds - with the git plugin
# sudo pear channel-discover pear.phing.info
# sudo pear channel-update pear.phing.info
# sudo pear install phing/phing

# sudo pear config-set preferred_state alpha
# sudo pear install VersionControl_Git
# sudo pear config-set preferred_state stable

# start up postgres, but initializing the db and then opening up access
sudo service postgresql-9.3 initdb
sudo sed -i -e 's/^host/#host/g' /var/lib/pgsql/9.3/data/pg_hba.conf
echo 'host    all             all             10.0.0.0/8              password' | sudo tee -a /var/lib/pgsql/9.3/data/pg_hba.conf
echo 'host    all             all             33.0.0.0/8              password' | sudo tee -a /var/lib/pgsql/9.3/data/pg_hba.conf
echo 'host    all             all             127.0.0.0/8              password' | sudo tee -a /var/lib/pgsql/9.3/data/pg_hba.conf
echo 'host    all             all             192.0.0.0/8              password' | sudo tee -a /var/lib/pgsql/9.3/data/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/9.3/data/postgresql.conf

# start the service and create user and database
sudo service postgresql-9.3 start
sudo -u postgres psql -c "create user mhadmin password 'connected364'";
sudo -u postgres psql -c "create user mhwebappuser password 'mhwebappuser'";
sudo -u postgres psql -c "CREATE EXTENSION tablefunc";
sudo -u postgres psql < /vagrant/scripts/createDatabase.ddl.sql  

# set up access to dev server and copy dev version of database to local
echo 'dev-ibmhpgdb1.internetbrands.com:5432:mh:mhadmin:connected364' | sudo tee -a /var/lib/pgsql/.pgpass
sudo chmod 0600 /var/lib/pgsql/.pgpass
sudo chown postgres:postgres /var/lib/pgsql/.pgpass

# create virtual host for local services and start apache
echo 'NameVirtualHost *:80' | sudo tee -a /etc/httpd/conf/httpd.conf
sudo sed -e 's/User apache/User vagrant/g' /etc/httpd/conf/httpd.conf | sed -e 's/Group apache/Group vagrant/g' > /tmp/httpd.conf
sudo mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf
cat > /tmp/local-ibmhws.conf <<EOL
<VirtualHost *:80>
    DocumentRoot /vagrant/public
    ServerName local-ibmhws01.internetbrands.com
    <Directory />
        Options +FollowSymLinks
        AllowOverride All
    </Directory>
</VirtualHost>
EOL
sudo mv /tmp/local-ibmhws.conf /etc/httpd/conf.d/local-ibmhws.conf
echo 'EnableSendFile Off' | sudo tee -a /etc/httpd/conf/httpd.conf
sudo service httpd start

# start redis
#sudo service redis start

# turn off firewall
sudo service iptables save
sudo service iptables stop
sudo chkconfig iptables off

# start database reload in background
sudo /vagrant/scripts/installOracleExtensions.sh
sudo /vagrant/scripts/reloadDevDatabase.sh &
