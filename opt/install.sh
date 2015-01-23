#!/bin/bash

tsScriptDir=${0%/*}
cd "$tsScriptDir"
tsScriptVar="../var"


if(! [[ -f "./config" ]] )
then
	echo "you need to configure this thin first!"
	exit 1
fi

source ./config
./getCurrentTarball.sh

if( ! [[ $? -eq 1 ]] )
then
	echo "have you run getCurrentTarbal firsit? Bailing out!"
	exit 1
fi

lastVer=$(cat "$tsScriptVar"/version)

if( ! [[ -e "$tsdir" ]] )
then
	mkdir "$tsdir"
else
	echo "tsdir already existed?!"
	exit 1
fi

tar -xf "$tsScriptVar"/"$lastVer" --strip-components=1 -C "$tsdir"

exit 0
