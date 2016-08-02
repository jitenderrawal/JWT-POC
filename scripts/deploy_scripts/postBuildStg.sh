#!/bin/bash

chmod -R 555 /var/www/releases/latest/*
chmod 755 /var/www/releases/latest/app
ln -s /var/log/httpd/storage /var/www/releases/latest/app/storage
chmod 555 /var/www/releases/latest/app
# Let's keep the tests directory open
chmod -R 755 /var/www/releases/latest/tests
