#!/bin/bash


if [ "$(id -u)" == "0" ]; then
   echo "This script cant be run  as root" 1>&2
   exit 2
fi

tsScriptVar="../var"
tsScriptDir=${0%/*}
cd "$tsScriptDir"

./getCurrentTarball.sh

if( [[ $? -eq 1 ]] )
then
	echo "Update Needed"
else
	return 0
fi

$($stopCMD)
lastVer=$(cat "$tsScriptVar"/version)
tar -xf "$tsScriptVar"/"$lastVer" --strip-components=1 -C "$tsdir"
$($startCMD)
