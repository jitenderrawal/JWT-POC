#!/bin/bash

# ./scripts/deploy_scripts/setvhost.sh
# ===========================================================================================
# Name      setvhost
# Descr     creates symlinks & folders for the given virtual host and release
# Author    Andrew Bergamasco
# Host      stg-lawyers-jenkins1.internetbrands.com
# Path      /var/lib/jenkins/workspace/Lawyers.com - Web (*)
# Usage     ./scripts/deploy_scripts/setvhost.sh {vhost} {releaseFolder}
# Where     vhost is combined environment + virtual host from build.sh
# Where     releaseTag is a valid release folder from /var/www/releases
# Example   ./scripts/deploy_scripts/setvhost.sh v1 2015.6.3_Dev_201511251200
#           ~/workspace/'Lawyers.com - Web (Dev)'/scripts/deploy_scripts/setvhost.sh
#           ~/workspace/'Lawyers.com - Web (Staging)'/scripts/deploy_scripts/setvhost.sh
#
# -------------------------------------------------------------------------------------------
# The error "file_put_contents(/meta/services.json): failed to open stream: No such file or directory"
# can be corrected by running 
# chmod -R 777 /var/log/httpd/sites 
#
# Symbolic Links
# ln -s /var/www/releases/$buildDir /var/www/releases/$vhost
# ln -s /var/www/releases/$vhost /var/www/sites/$vhost/html
# ln -s /var/log/httpd/sites/$vhost/storage /var/www/releases/$buildDir/app/storage
#
# check permissions
# ssh jenkins@dev-ibldcweb1.internetbrands.com "ls -l /var/www/sites/"
# ssh jenkins@dev-ibldcweb1.internetbrands.com "ls -l /var/log/httpd/sites/"
# ssh jenkins@dev-ibldcweb2.internetbrands.com "ls -l /var/www/sites/"
# ssh jenkins@dev-ibldcweb2.internetbrands.com "ls -l /var/log/httpd/sites/"
#
# check response headers
# curl -s -D - www.qa1.lawyers.com -o /dev/null
# ===========================================================================================

# -------------------------------------------------------------------------------------------
# local functions
# -------------------------------------------------------------------------------------------

# $0 will return "bash" when a local script is executed on remote server with ssh
# therefore we have to explicitly set $fileName
FILE_NAME="... setvhost.sh"

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
usage="usage: $fileName {vhost} {releaseFolder} where vhost must be (dev|qa|stg|prod)([1-9]|10) and releaseFolder is a valid release folder from /var/www/releases"

log "-------------------------------------------"
log "Validate arguments"
log "-------------------------------------------"
isVHostValid
isBuildDirValid

log "-------------------------------------------"
log "Open permissions to enable build"
log "-------------------------------------------"
exen chown -R  jenkins:jenkins  /var/www/releases/$buildDir
exen chmod -R  777              /var/www/releases/$buildDir

log "-------------------------------------------"
log "Create symlink /var/www/releases/$vhost to current build"
log "-------------------------------------------"
exe ln -nsf /var/www/releases/$buildDir /var/www/releases/$vhost

log "-------------------------------------------"
log "Create symlink for vhost html to /var/www/releases/$vhost"
log "-------------------------------------------"
exe mkdir -p /var/www/sites/$vhost
exe ln -nsf /var/www/releases/$vhost /var/www/sites/$vhost/html

log "-------------------------------------------"
log "/var/www/sites/$vhost/html -> /var/www/releases/$vhost -> /var/www/releases/$buildDir"
log "-------------------------------------------"

log "-------------------------------------------"
log "Create sym link for lbm images"
log "-------------------------------------------"
if [[ -e /lbm_images ]]; then 
  log "creating upper case link for /var/www/releases/$vhost/public/LBM_Images"
  exe ln -nsf /lbm_images /var/www/releases/$vhost/public/LBM_Images
else
  log "warning ... /lbm_images does not exist on this server"
fi

if [[ -e /var/www/releases/$vhost/public/lbm_images ]]; then
  log "removing lower case link for /var/www/releases/$vhost/public/lbm_images"
  rm -f /var/www/releases/$vhost/public/lbm_images
fi 

log "-------------------------------------------"
log "restrict permissions before exiting"
log "-------------------------------------------"
exen chmod -R 555 /var/www/releases/$buildDir

log "-------------------------------------------"
log "Finished"
log "-------------------------------------------"

exit 0;