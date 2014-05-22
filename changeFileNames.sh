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
processedFile=`pwd`/processed$testName""files.txt;
appendName="$testName$testNumber";

#### File Function ####

file(){
file=`echo $1 | awk -F/ '{print $NF}'`;
ext=`echo "${file##*.}"`;
originalName=`echo $file | awk -F. '{print $1}'`;
newName="$originalName""_$appendName"".$ext";
grep $1 $processedFile > /dev/null;
if [ `echo $?` == 1 ]; then
	grep $newName $processedFile > /dev/null;
	if [ `echo $?` == 1 ]; then
		echo "$2/$newName" >> $processedFile;
		cp $1 $newName;
	fi
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
if [ $testNumber == 1 ]; then
	if [ -f $processedFile ]; then
		rm -rf $processedFile;
	fi
	echo "---------------------" >> $processedFile;
	echo "Processed File Names " >> $processedFile;
	echo "---------------------" >> $processedFile;
fi
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

IFS=$SAVEIFS;
