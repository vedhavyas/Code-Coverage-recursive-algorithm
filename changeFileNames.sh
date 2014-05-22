#!/bin/bash
#set -x;


tempFolder=$2/temp;
absPath=$1;
finalFile=$4/$3;
appendName=`echo $3 | awk -F. '{print $1}'`;
processedFile=$4/$appendName-processedFilePath.txt;
cpuSummary=$4/host_summary.txt;
configFile=$4/Config.txt;
uniqueFile=$4/$3_uniqueNumber.txt;
SAVEIFS=$IFS;
unwar=`echo $5 | awk -F= '{print $NF}'`;
IFS=$(echo -en "\n\b");
excludeList=`cat $configFile | grep exclude | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;
includeList=`cat $configFile | grep include | awk -F'[=,]' '{for(i=2;i<=NF;i++){print $i}}'`;

## folder function starts here##
folder(){

cd $1;
if [ "$(ls -A $1)" ]; then
	listDir=$1/*;
	for k in $listDir
	do
		if ! [[ -L "$k" ]]; then
			file=`echo $k | awk -F/ '{print $NF}'`;
			ext=`echo "${file##*.}"`;
			retFile=0;
			retExt=0;
			for s in $excludeList
			do
				if [ $file == $s ]; then
					retFile=1;
				fi
				if [ $ext == $s ];then
					retExt=1;
				fi
			done

			if [ $retFile != 1 -o $retExt != 1 ]; then
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
					    echo -n `basename $k` >> $finalFile;
					    echo -n `basename $k` >> $processedFile;
					    echo -n "   -   " >> $processedFile;
					    echo $k | awk -F/ '{t="";
                        					for (i=2;i<NF;i++){
                               						if ($i =="temp"){
                                    						j=i;
                                   					}
                               					}
                        					for (i=j+1;i<NF;i++){
                               						t=t$i"/";
                               					}
                               					print t;
                       						}' >> $processedFile;
					    echo `md5sum $k | awk '{print " - "  $1}'`   >> $finalFile;
					    retFile=0;
					    retExt=0;
				   fi
				fi
			fi
		fi
	done
fi
cd $2;
}



## main function starts here##


if [ -f $finalFile ] ; then
	rm -rf $finalFile ;
fi
if [ -f $processedFile ] ; then
	rm -rf $processedFile ;
fi

if [ -f $uniqueFile ] ; then
	rm -rf $uniqueFile ;
fi

mkdir $tempFolder;
cp -r $absPath/* $tempFolder;

cd $tempFolder;

if [ "$(ls -A $tempFolder)" ]; then
	mainList=$tempFolder/*;
#echo "==============================" >> $finalFile;
#echo "   File Name - Md5Sum Bytes   "  >> $finalFile;
#echo "==============================" >> $finalFile;
#echo "==============================" >> $processedFile;
#echo "   File name - File path      " >> $processedFile;
#echo "==============================" >> $processedFile; 

	for i in $mainList
	do
		if ! [[ -L "$i" ]]; then
			file=`echo $i | awk -F/ '{print $NF}'`;
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
			if [ $retFile != 1 -o $retExt != 1 ]; then
  				if [ -d $i ] ; then
     					folder $i `pwd`;
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
    						echo -n `basename $i` >> $finalFile;
    						echo -n `basename $i` >> $processedFile;
			   		 	echo -n "   -   " >> $processedFile;
    						echo $i | awk -F/ '{t="";
                        						for (i=2;i<NF;i++){
                               							if ($i =="temp"){
                                    							j=i;
                                   						}
                               						}
                        						for (i=j+1;i<NF;i++){
                               							t=t$i"/";
                               						}
                               						print t;
                       					           }' >> $processedFile;
    						echo `md5sum $i | awk '{print " - "  $1}'`   >> $finalFile;
    						retFile=0;
    						retExt=0;
  					fi
  				fi
			fi
		fi
	done
fi
echo `sort $finalFile | cksum` >> $uniqueFile;
rm -rf $tempFolder;
IFS=$SAVEIFS;
