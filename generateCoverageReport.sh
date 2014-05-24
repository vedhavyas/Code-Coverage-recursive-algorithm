#############################################################################
#   Author : Vedhavyas Singareddi                                           #
#   File Name : generateCoverageReport.sh                                   #
#   Purpose : To generate Coverage report from the data files 		    #                                                                     #                                                                           #
#############################################################################


#!/bin/bash
#set -x;

SAVEIFS=$IFS;
IFS=$(echo -en "\n\b");
configFile=`pwd`/Config.txt;

srcs=`cat $configFile | grep srcsMasterFolder | awk -F'[=#]' '{print $2}'`;
excludeList=`cat $configFile | grep exclude | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
includeList=`cat $configFile | grep include | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
testName=`cat $configFile | grep testName | awk -F= '{print $2}'`;
processedFile=`pwd`/processed$testName""files.txt;
coveragePath=`cat $configFile | grep coverageReportFolderPath | awk -F= '{print $2}'`;
folderName=`cat $configFile | grep folderName | awk -F= '{print $2}'`;
coverageFolder=$coveragePath/$folderName;
includeSource=`cat $configFile | grep includeSource | awk -F= '{print $2}'`;
captureFile=$srcs/capture$testname;

#### File Function ####

file(){
file=`echo $1 | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
grep $1 $processedFile > /dev/null;
if [ `echo $?` == 1 ]; then
	rm -rf $1;
fi

}
#### Folder function ####

folder(){
cd $1;
listDir=`ls`;
for k in $listDir
do
	file=`echo $k | awk -F/ '{print $NF}'`;
	ext=`echo "${file##*.}"`;
	retFile=0;
	retExt=0;
	for s in $excludeList
	do
		if [ $file == $s ]; then
			retFile=1;
		fi
		if [ $ext == $s ]; then
			retExt=1;
		fi
	done

	if [ $retFile == 0 -a $retExt == 0 ]; then
		if [ -d $k ] ; then
    			folder $k `pwd`;
		else
    			retFile=0;
    			retExt=0;
    			for t in $includeList
    			do
    				if [ $ext == $t ]; then
    					retExt=1;
    				fi
    				if [ $file == $t ]; then
    					retFile=1;
    				fi 
    			done
			if [ $retExt == 1 -o $retFile == 1 ]; then
			file $k `pwd`;
			fi
		fi
	fi
done
cd $2;
}


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
				file $i `pwd`;
			 fi
		fi	 
	fi	
done

###generating coverage report

if [ -f $captureFile ]; then
	rm -rf $captureFile;
fi

if [ -d $coverageFolder ]; then
	rm -rf $coverageFolder;
fi

###capturing Data
Locv –c –d $srcs -o $captureFile;

###Generating Report
if [ $includeSource == 'false' ]; then 
	Genhtml --no-source $captureFile -o $coverageFolder;
else
	Genhtml $captureFile -o $coverageFolder;
fi


IFS=$SAVEIFS;
