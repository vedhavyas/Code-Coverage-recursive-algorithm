#!/bin/bash
#set -x;

SAVEIFS=$IFS;
IFS=$(echo -en "\n\b");
configFile="./Config.txt";

srcs=`cat $configFile | grep srcsMasterFolder | awk -F'[=#]' '{print $2}'`;
testName=`cat $configFile | grep testName | awk -F= '{print $2}'`;
testNumber=`cat $configFile | grep testNumber | awk -F= '{print $2}'`;
excludeList=`cat $configFile | grep exclude | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
includeList=`cat $configFile | grep include | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
processedFile="processed-$testName";


#### Main Function #####
cd $srcs;
mainList=`ls`;
for i in $mainList
do
	file=`echo $i | awk -F/ '{print $NF}'`;
	ext=`echo "${file##*.}"`;
	retExt=0;
	retFile=0;
	for j in $excludeList
	do
	if [ $file == $j ]; then
		retFile=1;
		break;
	fi
	if [ $ext == $j ]; then
		retExt=1;
		break;
	fi
	done
	if [ $retFile == 0 -a $retExt == 0 ]; then
		if [ -d $i ] ; then
	     		folder $i `pwd`;	
		else	
			for j in $includeList
			do
			 	if [ $file == $j ]; then
		                	 retFile=1;
			         	 break;
			 	fi
			 	if [ $ext == $j ]; then
			        	 retExt=1;
			         	 break;
				fi
			 done
			 if [ $retFile == 1 -o  $retExt == 1 ]; then
				echo $i;
			 fi
		fi	 
	fi	
done

IFS=$SAVEIFS;
