#!/bin/bash

if [ "$(id -u)" == "0" ]; then
   echo "This script cant be run  as root" 1>&2
   exit 2
fi

tsScriptVar="../var"
tsScriptDir=${0%/*}
cd "$tsScriptDir"

vernums=$(curl -s http://dl.4players.de/ts/releases/ | grep -oP "href=\"((\d{1,2}\.){1,4}\d{1,3})" | grep -oP "((\d{1,2}\.){1,4}\d{1,3})" | sort -V | tac)

while read -r line
do
	serverLine=$(curl -s http://dl.4players.de/ts/releases/$line/ | grep -P "teamspeak3-server_linux-amd64")
	if(! [[ -z $serverLine ]])
	then
		break
	fi
done <<< "$vernums"

tarball=$(echo -n "$serverLine" | grep -oP "href=\"teamspeak3-server_linux-amd64-((\d{1,2}\.){1,4}\d{1,3}).tar.gz"  | grep -oP "teamspeak3-server_linux-amd64-((\d{1,2}\.){1,4}\d{1,3}).tar.gz")

if( [[ -f "$tsScriptVar"/version ]] )
then
	lastVer=$(cat "$tsScriptVar"/version)
else
	lastVer=""

fi


if(! [[ "$lastVer" = "$tarball" ]] )
then
	echo -n "$tarball" > "$tsScriptVar"/version
	if( [[ -f "$tsScriptVar"/bins/"$lastVer" ]] )
	then
		rm "$tsScriptVar"/bins/"$lastVer"
	fi

	curl -s  http://dl.4players.de/ts/releases/$line/$tarball  > "$tsScriptVar"/"$tarball"
	exit 1
else
	echo "No new version available"
	exit 0
fi
