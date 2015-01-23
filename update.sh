#!/bin/bash

mydir=$(mktemp -d)
cd $mydir
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
curl -s  http://dl.4players.de/ts/releases/$line/$tarball  > "$tarball"

rm "$tarball"
rmdir $mydir
