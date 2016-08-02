#!/bin/bash

# ./scripts/deploy_scripts/setLatestBuildLink.sh
# ========================================================
# Name      setLatestBuildLink
# Descr     hanldes any post deploy tasks for the given release
# Host:     stg-lawyers-jenkins1.internetbrands.com
# Path:     /var/lib/jenkins/workspace/Lawyers.com - Web (*)
# Usage:    ./scripts/deploy_scripts/setLatestBuildLink.sh releaseFolder
# Where     releaseFolder is a folder from target server's /var/www/releases
#
# Example:  ./scripts/deploy_scripts/setLatestBuildLink.sh 2015.6.3_Dev_201511251200
#           vi ./scripts/deploy_scripts/setLatestBuildLink.sh
#
# ssh jenkins@dev-ibldcweb1.internetbrands.com bash -s < ./scripts/deploy_scripts/setLatestBuildLink.sh 2015.6.3_Dev_201511251200
# ssh jenkins@dev-ibldcweb2.internetbrands.com bash -s < ./scripts/deploy_scripts/setLatestBuildLink.sh 2015.6.3_Dev_201511251200
# ========================================================

# ------------------------------------------------
# local functions
# ------------------------------------------------

# $0 will return "bash" when a local script is executed on remote server with ssh
# therefore we have to set script name into this log function
FILE_NAME="... setLatestBuildLink.sh"

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

log "-------------------------------------------"
log "Starting"
log "-------------------------------------------"

vhost=$1
usage="usage: $FILE_NAME {vhost} where vhost is ^(local)|(prod[1-3])|(dev|qa|stg)(10|[1-9])$"


log "-------------------------------------------"
log "Validate arguments"
log "-------------------------------------------"

if [ -z $vhost ] ; 
then
  log "You must provide a virtual host" 
  echo $usage
  exit 1;
fi;

# --------------------------------------------------------------------------------------
# primary virtual hosts: local,dev1,qa1,stg1,prod1
# --------------------------------------------------------------------------------------
if ! [[ $vhost =~ ^(local)|(dev|qa|stg|prod)1$ ]]
  then
    log "invalid virtual host [$vhost] ... only primary hosts should be set to 'latest'"
    exit 2
fi;

# --------------------------------------------------------------------------------------
# confirm vhost exists
# --------------------------------------------------------------------------------------
if ! [ -e /var/www/releases/$vhost ] ; then
  log "invalid argument: virtual host [$vhost] not found in /var/www/releases"
  exit 3
fi;

# -------------------------------------------
# set "latest" to the given build
# -------------------------------------------
if [ -e /var/www/releases/latest ] && [ -L /var/www/releases/latest ]; then
  log "replacing existing symlink for \"latest\" build"
fi;

log "setting $vhost as \"latest\""
exe ln -nsf /var/www/releases/$vhost /var/www/releases/latest

log "exiting"
echo "-------------------------------------------"
exit 0;