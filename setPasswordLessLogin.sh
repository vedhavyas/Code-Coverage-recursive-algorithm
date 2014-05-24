#!/bin/bash

configFile=`pwd`/Config.txt;
cd ~ ;
ssh-keygen;
serverName=`cat $configFile | grep serverName | awk -F= '{print $2}'`;
userName=`cat $configFile | grep userName | awk -F= '{print $2}'`;
for i in $serverName
do
	ssh-copy-id -i ~/.ssh/id_rsa.pub $userName@$i;
	echo "Password less login is set on Server $i";
done
