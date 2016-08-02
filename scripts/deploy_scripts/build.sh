#!/bin/bash

# ./scripts/deploy_scripts/build.sh
# ========================================================
# Name      build
# Descr     deploys given release to stage servers
# Host      stg-lawyers-jenkins1.internetbrands.com
# Usage     ./scripts/deploy_scripts/build.sh buildDir generateHeartBeat virtualHost
# Where 1    buildDir is buildTag+Environment+buildTimeStamp
# Where 2    generateHeartBeat is true | false
# Where 3    virtualHost is {env}1 | {env}2 | {env}3
# Where 4    runGassetic is true | false (service tier does not use gassetic)
# Where 5    runRsync is true | false (optional parameter - useful when testing)
#
# Example   
# ./scripts/deploy_scripts/build.sh $buildDir $generateHeartBeat $vhost $runGassetic $runRsync
# ~/workspace/'Lawyers.com - Web (Dev)'/scripts/deploy_scripts/build.sh
# ~/workspace/'Lawyers.com - Web (Staging)'/scripts/deploy_scripts/build.sh
# ========================================================

FILE_NAME="... build.sh"

. ./scripts/deploy_scripts/lib.sh
. ./scripts/deploy_scripts/servers.sh

log "-------------------------------------------"
log "Starting"
log "-------------------------------------------"

# ------------------------------------------------
# Bind variables
# changes case to lower case ... ${var,,} 
# removes numbers from string ... var=`echo $var|sed 's/[0-9]*//g'`
# ------------------------------------------------
buildDir=$1
generateHeartBeat=${2,,}
vhost=${3,,}
runGassetic=${4,,}
runRsync=${5,,}

# ------------------------------------------------
# Environment variables
# ------------------------------------------------
gasseticEnv=$vhost

# remove integers from vhost
env=`echo $vhost|sed 's/[0-9]*//g'`

if [[ $env == "dev" ]] ; then
  servers=$devServers
elif [[ $env == "qa" ]] ; then
  servers=$qaServers
elif [[ $env == "stg" ]] ; then
  servers=$stgServers
elif [[ $env == "prod" ]] ; then
  servers=$prodServers
else
  log "Error: Could not find server list using [$env]"
  log "Exiting"
  exit 1;
fi;

log "-------------------------------------------"
log "Initialize"
log "-------------------------------------------"
echo "export buildDir="$buildDir
echo "export generateHeartBeat="$generateHeartBeat
echo "export vhost="$vhost
echo "export runGassetic="$runGassetic
echo "export runRsync="$runRsync
echo "export env="$env
echo "export gasseticEnv="$gasseticEnv
echo "export servers="$servers

# lib.validateArgs
validateArgs


log "-------------------------------------------"
log "Composer"
log "-------------------------------------------"
log update composer to latest version
exe ~/composer.phar self-update
exe ~/composer.phar install


log "-------------------------------------------"
log "Gassetic"
log "-------------------------------------------"
if [[ $runGassetic == "true" ]] ; then
  exe gassetic build --env=$gasseticEnv
else
  log "skipping Gassetic" 
fi;


log "-------------------------------------------"
log "Create build folder"
log "-------------------------------------------"
exe rm -rf $buildDir
exe mkdir -p $buildDir


log "-------------------------------------------"
log "Copy assets to build folder"
log "-------------------------------------------"
# Laravel4 Web      
  assets="app bootstrap public vendor"
# Laravel4 Services 
#  assets="app bootstrap codeception.yml public tests vendor"
# Laravel5 Web      
#  assets="app bootstrap config database resources public storage vendor"
for asset in $assets; do
  exe cp -R $asset $buildDir/$asset;
done

log "-------------------------------------------"
log "Remove all files from $buildDir/app/storage"
log "-------------------------------------------"
exe find $buildDir/app/storage -type f -delete


log "-------------------------------------------"
log "Create /public/version.txt"
log "-------------------------------------------"
echo $buildDir > public/version.txt
echo $buildDir > $buildDir/public/version.txt
log "created $buildDir/public/version.txt"


log "-------------------------------------------"
log "Create php.info"
log "-------------------------------------------"
if [[ $vhost =~ ^prod.*$ ]]; then
  # obfuscate file so even we wont guess this ;(
  fileName="d36f8f9425c4a8000ad9c4a97185aca5.php"
else 
  fileName="info.php"
fi
echo "<?php phpinfo(); ?>" > $buildDir/public/$fileName
log "created $buildDir/public/$fileName"


log "-------------------------------------------"
log "Create HeartBeat file"
log "-------------------------------------------"
if [[ "$generateHeartBeat"=="true" ]] ; then
  echo "OK" > $buildDir/public/hbeat.txt 
  log "created $buildDir/public/hbeat.txt "
else 
  log "WARNING, HeartBeat file not created"
fi


log "-------------------------------------------"
log "Deploy build folder to remote servers"
log "-------------------------------------------"

firstServer=true

for server in $servers;
do
  
    echo "export server=$server"

    if [[ $runRsync == "true" && $firstServer == "true" ]] ; then
        log "call rsynch on first server ($server)"
        exe rsync -a $buildDir jenkins@$server:/var/www/releases/
    else 
        log "skip rsync for server ($server)"
    fi;

    if [[ $vhost =~ ^(prod[1-3])|(dev|qa|stg)(10|[1-9])$ ]] ; then

      if [[ $firstServer=="true" ]] ; then
        log "configure virtual host on $server"
        exe ssh jenkins@$server "bash -s" < ./scripts/deploy_scripts/setvhost.sh $vhost $buildDir
      fi;

      log "configure log folders on $server"
      exe ssh jenkins@$server "bash -s" < ./scripts/deploy_scripts/setLogFolders.sh $vhost $buildDir

    fi;

    if [[ $vhost =~ ^(dev|qa|stg|prod)1$ ]] ; then
      log "set 'latest' symlink on primary host only"
      exe ssh jenkins@$server "bash -s" < ./scripts/deploy_scripts/setLatestBuildLink.sh $vhost
    fi;

    # ((serverCount++))
    firstServer=false
    log "-------------------------------------------"
done


log "-------------------------------------------"
log "Touch symlinks to flush NFS cache"
log "-------------------------------------------"
for server in $servers;
do
    if [[ $vhost =~ ^(dev|qa|stg|prod)1$ ]] ; then
      log "touch /var/www/html on primary host ($vhost)"
      exe ssh jenkins@$server "touch /var/www/html"
    fi;
    log "touch /var/www/sites/$vhost/html on secondary host ($vhost)"
    exe ssh jenkins@$server "touch /var/www/sites/$vhost/html"
done

# ------------------------------------------------
# Clear redis-cache
# log "Flushing redis cache on stg-ibmhcache1"
# ssh jenkins@stg-ibmhcache1 /usr/bin/redis-cli -a 'nolo-2476544660415%KLMWsKqLDnTiptxdlbxPNmijaurMjWcelqkfjJmceyNKtnuwqsHtupcGpdXefmTzhJ?695@30=*$593161:174821448?467.6JWwmtGjVtkpcvJulzWMMbwkRievuDmohupYVtiDkvQoaYltaLugssgyht65' flushdb
# ------------------------------------------------


log "-------------------------------------------"
log "Remove build folder"
log "-------------------------------------------"
exe rm -rf $buildDir


log "-------------------------------------------"
log "Build finished"
log "-------------------------------------------"


exit 0;