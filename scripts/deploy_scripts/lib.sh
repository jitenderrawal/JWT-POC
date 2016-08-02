#!/bin/bash
# ./scripts/deploy_scripts/lib.sh

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

# ------------------------------------------------
# removes integers from string
# env=`echo $vhost|sed 's/[0-9]*//g'`
# called to remove integers from vhost
# ------------------------------------------------
function removeIntegers() {
	return `echo $1|sed 's/[0-9]*//g'`
}

function printUsage() {
  echo "-------------------------------------------"
  echo "Invalid or insufficient arguments passed to this script"
  echo $@
  cat ./usage.txt
  echo "-------------------------------------------"
  exit 1;
}

# ------------------------------------------------
# validation rules
# ------------------------------------------------
function validateArgs() {

	if [ -z "$generateHeartBeat" ] ; then
	  msg="Missing required argument: generate heart beat file"
	  printUsage $msg;
	fi;

	# runGassetic ... if not passed default to true
	if [ -z "$runGassetic" ] ; then
	  runGassetic="true"
	fi;

	# runRsync is optional ... if not passed default to true
	if [ -z "$runRsync" ] ; then
	  runRsync="true"
	fi;

	isBuildDirValid
	isVHostValid
}

function isBuildDirValid() {
	if [ -z "$buildDir" ] ; then
	  msg="Missing required argument: branch label"
	  printUsage $msg;
	fi;
}

function isVHostValid() {

	if [ -z "$vhost" ] ; then
	  msg="Missing required argument: virtual host"
	  printUsage $msg;
	fi;

	# allows up to 10 virtual hosts
	if ! [[ $vhost =~ ^(local)|(prod[1-3])|(dev|qa|stg)(10|[1-9])$ ]] ; then
	    echo "Invalid virtual host [$vhost]"
	    echo $usage
	    exit 1
	fi;
}