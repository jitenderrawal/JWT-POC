#!/bin/bash

if [ x$1 = x ] ; then
  echo "You must provide a valid branch name and build id combo"
  echo "./buildPreProd.sh <branch>_<buildId>"
  exit;
fi;

BUILD_DIR=$1
declare -a hosts=("ibpremhws1.dhcp.internetbrands.com")

# composer self-update
~/composer.phar self-update

# composer install
~/composer.phar install

# apply path for preprod endpoints
git apply scripts/deploy_scripts/preprod.patch

mkdir -p $BUILD_DIR
for folder in app bootstrap codeception.yml public tests vendor; do
  cp -R $folder $BUILD_DIR/$folder;
done
rm -rf $BUILD_DIR/app/storage
cp scripts/deploy_scripts/postBuildPreProd.sh $BUILD_DIR/
echo $BUILD_DIR > $BUILD_DIR/public/version.txt

# Deploy to each host
for host in "${hosts[@]}"
do
    echo "deploying to ", $host
    rsync -a $BUILD_DIR jenkins@$host:/var/www/releases/
    ssh jenkins@$host "rm /var/www/releases/latest && ln -s /var/www/releases/$BUILD_DIR /var/www/releases/latest && /var/www/releases/latest/postBuildPreProd.sh"
done


# Clear redis-cache
# echo "Flushing redis cache on stg-ibmhcache1"
# ssh jenkins@stg-ibmhcache1 /usr/bin/redis-cli -a 'nolo-2476544660415%KLMWsKqLDnTiptxdlbxPNmijaurMjWcelqkfjJmceyNKtnuwqsHtupcGpdXefmTzhJ?695@30=*$593161:174821448?467.6JWwmtGjVtkpcvJulzWMMbwkRievuDmohupYVtiDkvQoaYltaLugssgyht65' flushdb

# Touch /var/www/html to clear NFS cache
for prodhost in ibpremhws1.dhcp.internetbrands.com ibpremhws2.dhcp.internetbrands.com
do
    echo "ssh jenkins@$prodhost touch /var/www/html"
    ssh jenkins@$prodhost "touch /var/www/html"
done

rm -rf $BUILD_DIR
