#!/bin/bash

# echo "10.197.208.59          build.lawyers.com" >> /etc/hosts

mkdir -p /opt/oracle
cd /opt/oracle
wget http://build.lawyers.com/third_party/instantclient-basic-linux.x64-12.1.0.2.0.zip
wget http://build.lawyers.com/third_party/instantclient-sdk-linux.x64-12.1.0.2.0.zip

unzip instantclient-basic-linux.x64-12.1.0.2.0.zip
unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip

ln -s instantclient_12_1 instantclient
cd instantclient
ln -s libclntsh.so.12.1 libclntsh.so

mkdir -p /usr/local/src
cd /usr/local/src
wget http://php.net/get/php-5.5.16.tar.gz/from/this/mirror -O php-5.5.16.tar.gz
tar -xzf php-5.5.16.tar.gz

cd php-5.5.16/ext/oci8
phpize
./configure --with-oci8=shared,instantclient,/opt/oracle/instantclient,12.1
make
make install

cd /usr/local/src/php-5.5.16/ext/pdo_oci/
phpize
./configure --with-pdo-oci=instantclient,/opt/oracle/instantclient,12.1
make
make install

echo extension=oci8.so >> /etc/php.ini
echo extension=pdo.so >> /etc/php.ini
echo extension=pdo_oci.so >> /etc/php.ini

service httpd restart
