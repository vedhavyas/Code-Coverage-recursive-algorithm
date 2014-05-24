#############################################################################
#   Author : Vedhavyas Singareddi                                           #
#   File Name : setpasswordLessLogin.sh                                     #
#   Purpose : To add the public ssh key of local machine to remote server   #                                                                     #             to access the remote with out the need of password            #
#############################################################################

#!/bin/bash

configFile=`pwd`/Config.txt;
ssh-keygen;
serverName=`cat $configFile | grep serverName | awk -F= '{print $2}'`;
userName=`cat $configFile | grep userName | awk -F= '{print $2}'`;
for i in $serverName
do
	ssh-copy-id -i ~/.ssh/id_rsa.pub $userName@$i;
	echo "Password less login is set on Server $i";
done

ssh $userName@$serverName "mkdir -p /CodeCoverage";
scp Config.txt captureFilesFromRemote.sh  $userName@$serverName:/CodeCoverage/ >> /dev/null ;
