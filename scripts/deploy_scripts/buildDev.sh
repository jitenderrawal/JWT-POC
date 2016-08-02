#!/bin/bash

# this file is only needed during our transition to virtual hosts

buildDir=$1
generateHeartBeat=$2
virtualHost=$3
runGassetic=$4

source ./build.sh $buildDir $generateHeartBeat $virtualHost $runGassetic