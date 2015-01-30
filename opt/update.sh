#!/bin/bash


if [ "$(id -u)" == "0" ]; then
   echo "This script cant be run  as root" 1>&2
   exit 2
fi

if(! [[ -f "./config" ]] )
then
	echo "you need to configure this thing first!"
	exit 1
fi


source ./config
tsScriptVar="../var"
tsScriptDir=${0%/*}
cd "$tsScriptDir"

if( ! [[ -e "$tsdir" ]] )
then
	echo "tsdir does not exist!"
	exit 1
fi

./getCurrentTarball.sh

if( [[ $? -eq 1 ]] )
then
	echo "Update Needed"
else
	exit 0
fi

$stopCMD
lastVer=$(cat "$tsScriptVar"/version)
tar -xf "$tsScriptVar"/"$lastVer" --strip-components=1 -C "$tsdir"
$startCMD
