#!/bin/bash
# ===========================================================================================
# Name      ./scripts/deploy_scripts/setLogFolders.sh
# version   1.6
# Desc      set permissions on log folders
# Author    Andrew Bergamasco
# Host      stg-lawyers-jenkins1.internetbrands.com
# Path      /var/lib/jenkins/workspace/Lawyers.com - Web (*)
# Usage     ./scripts/deploy_scripts/setLogFolders.sh {vhost} {releaseFolder}
# Where     vhost is combined environment + virtual host from build.sh
# Where     releaseTag is a valid release folder from /var/www/releases
# Example   ./scripts/deploy_scripts/setLogFolders.sh v1 2015.6.3_Dev_201511251200
#           ~/workspace/'Lawyers.com - Web (Dev)'/scripts/deploy_scripts/setvhost.sh
#           ~/workspace/'Lawyers.com - Web (Staging)'/scripts/deploy_scripts/setvhost.sh
#
# -------------------------------------------------------------------------------------------
# To fix "file_put_contents(/meta/services.json): failed to open stream: No such file or directory"
# chmod -R 777 /var/log/httpd/sites/$vhost/storage
#
# To fix "error "Unable to parse response as JSON" on web service instances
#       in /vagrant/vendor/nategood/httpful/src/Httpful/Handlers/JsonHandler.php:29
# chmod -R 777 /var/log/httpd/sites/$vhost/storage
# -------------------------------------------------------------------------------------------
#
# Permissions in production:
# /var/www/releases/$buildDir             ... 555 jenkins:jenkins
# /var/www/releases/$buildDir/app/storage ... 777 jenkins:jenkins
# /var/log/httpd/sites                    ... 755 jenkins:apache
# /var/log/httpd/sites/prod1/storage      ... 777 jenkins:jenkins
#
# ===========================================================================================

# -------------------------------------------------------------------------------------------
# local functions
# -------------------------------------------------------------------------------------------

# $0 will return "bash" when a local script is executed on remote server with ssh
# therefore we have to explicitly set $FILE_NAME
FILE_NAME="... setLogFolders.sh"

function log() {
  echo "$FILE_NAME ... $@"
}

function evalResult () {
  if [ $1 -ne 0 ] ; then
      log "last command failed with " $1
      exit 1;
  fi
}

function exe() { 
  log "\$ $@" ; "$@" ;
   evalResult $?
}

function exen() { 
  log "\$ $@" ; "$@" ;
}

function isVHostValid() {
  if [ -z $vhost ] ; then
    log "missing argument: virtual host is required"
    echo $usage
    exit 1
  fi;
  # allows up to 10 virtual hosts
  if ! [[ $vhost =~ ^(local)|(prod[1-3])|(dev|qa|stg)(10|[1-9])$ ]] ; then
      echo "Invalid virtual host [$vhost]"
      echo $usage
      exit 1
  fi;
  log "virtual host is valid"
}

# /**
#  * confirm jenkins was able to rsynch the given build to /var/www/releases
#  **/ 
function wasRsyncSuccessful() {
  if ! [ -e /var/www/releases/$buildDir ] ; then
    log "invalid argument: build folder [$buildDir] not found in /var/www/releases"
    echo $usage
    exit 1
  fi;
}

function isBuildDirValid() {
  if [ -z "$buildDir" ] ; then
    log "Missing required argument: build folder"
    echo $usage  
    exit 1
  fi;
  wasRsyncSuccessful
  log "buildDir is valid"
}

log "-------------------------------------------"
log "Bind variables"
log "-------------------------------------------"
vhost=$1
buildDir=$2
usage="usage: $FILE_NAME {vhost} {releaseFolder} where vhost must be (local)|(prod[1-3])|(dev|qa|stg)(10|[1-9]) and releaseFolder is a valid release folder from /var/www/releases"

log "-------------------------------------------"
log "Validate arguments"
log "-------------------------------------------"
isVHostValid
isBuildDirValid

log "-------------------------------------------"
log "Confirm /var/log/httpd/sites/$vhost"
log "-------------------------------------------"
# IB's Apache install creates a symlink to the current server's httpd logs
# however the target paths are different in prod vs stg/dev
# luckily, we can still use /var/log/httpd regardless of environment
#    prod:          /var/log/httpd -> /logs/httpd/$server
#    stg, qa, dev:  /var/log/httpd -> /var/www/logs/httpd/$server
if [ -e /var/log/httpd/sites/$vhost ]
  then
    log "/var/log/httpd/sites/$vhost exists"
  else
    exe mkdir -p /var/log/httpd/sites/$vhost
fi

log "-------------------------------------------"
log "Open permissions to enable build"
log "-------------------------------------------"
exen chmod -Rf 755 /var/log/httpd/sites/$vhost
exen chmod     755 /var/www/releases/$buildDir/app

log "-------------------------------------------"
log "Handle build storage folder"
log "-------------------------------------------"
if [[ -e /var/log/httpd/sites/$vhost/storage ]] ; then
  log "/var/log/httpd/sites/$vhost/storage exists"
  if [[ -d /var/www/releases/$buildDir/app/storage ]] ; then
    log "remove build storage created by rsync"
    exen chmod 775 /var/www/releases/$buildDir/app/storage
    exe rm -rf /var/www/releases/$buildDir/app/storage
  fi
else 
  log "/var/log/httpd/sites/$vhost/storage does not exist"
  if [[ -d /var/www/releases/$buildDir/app/storage ]] ; then
    log "move build storage created by rsync to /var/log/httpd/sites/$vhost/storage"
    exen chmod 775 /var/www/releases/$buildDir/app/storage
    exe mv /var/www/releases/$buildDir/app/storage /var/log/httpd/sites/$vhost/storage
  fi
fi

log "-------------------------------------------"
log "Ensure we have a proper httpd storage folder"
log "-------------------------------------------"
exe mkdir -p  /var/log/httpd/sites/$vhost/storage
exe mkdir -p  /var/log/httpd/sites/$vhost/storage/cache 
exe mkdir -p  /var/log/httpd/sites/$vhost/storage/meta 
exe mkdir -p  /var/log/httpd/sites/$vhost/storage/logs 
exe mkdir -p  /var/log/httpd/sites/$vhost/storage/views 
exe mkdir -p  /var/log/httpd/sites/$vhost/storage/sessions

log "-------------------------------------------"
log "Create symlink to httpd storage folder"
log "-------------------------------------------"
exe ln -nsf /var/log/httpd/sites/$vhost/storage /var/www/releases/$buildDir/app/storage

log "-------------------------------------------"
log "Set owner"
log "we can ignore return status on chown"
log "-------------------------------------------"
exen chown -R  jenkins:apache  /var/log/httpd/sites/$vhost

log "-------------------------------------------"
log "Set permissions"
log "chmod httpd storage folder after buildDir/app"
log "-------------------------------------------"
exen  chmod -Rf 555 /var/www/releases/$buildDir/app
exen  chmod -Rf 755 /var/log/httpd/sites/$vhost
exen  chmod -Rf 777 /var/log/httpd/sites/$vhost/storage

log "-------------------------------------------"
log "Finished"
log "-------------------------------------------"

exit 0;