#############################################################################
#   Author : Vedhavyas Singareddi                                           #
#   File Name : getFilesFromRemote.sh                                       #
#   Purpose : To get GCDA Files from remote server          	            #
#############################################################################


#!/bin/bash

configFile=`pwd`/Config.txt;

serverName=`cat $configFile | grep serverName | awk -F= '{print $2}'`;
userName=`cat $configFile | grep userName | awk -F= '{print $2}'`;

ssh $userName@$serverName "sh /CodeCoverage/captureFilesFromRemote.sh";

status=`ssh $userName@$serverName "cat /CodeCoverage/.status"`;

while [ $status != "Collected" ]
do 
	sleep 3;
	status=`ssh $userName@$serverName "cat /CodeCoverage/.status"`;
done

scp $userName@$serverName:/CodeCoverage/remoteFile.txt `pwd`/remoteFile.txt >> /dev/null;

remoteFile=`pwd`/remoteFile.txt;

list=`cat $remoteFile`;

for i in $list
do
	scp $userName@$serverName:$i $i >> /dev/null;
done
