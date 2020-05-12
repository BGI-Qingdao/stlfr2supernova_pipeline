#!/bin/bash

#SCRIPT_PATH=`dirname $0`

source ./profile
echo "check files ..."
date
if [[ -z $ADAPTOR_F ||  -z $ADAPTOR_F ]] ; then 
    echo "ERROR : no adaptor sequence assigned in profile . exit ..."
    exit 1 
fi
if [[ ! -f $SPLIT.1.fq.gz || ! -f $SPLIT.1.fq.gz ]] ; then 
    echo "error : file $SPLIT.1.fq.gz or $SPLIT.2.fq.gz is not exsist !!! exit ..."
    exit 1;
fi
cp $SCRIPT_PATH/data/lane.lst ./

echo "run SOAP_filter ... maybe long time ... "
date
tag=`date +_%m_%d_%H_%M_%S`
$SOAP_FILTER -q 33 -t $THREADS -y -F $ADAPTOR_F -R $ADAPTOR_R  -p -M 2 -f -1 -Q 10 lane.lst stat.txt >SOAPfilter_"$tag".log 2>SOAPfilter_"$tag".err || exit 1
echo "re-generate new barcode.freq from clean data .. may cost hours ..."

gzip -dc $SPLIT.1.fq.gz.clean.gz | awk '!(NR%4-1)' | awk -F '[# |]' '{print$2}' | awk -F '/' '{print $1}' | sort | uniq -c | awk '{printf("%s\t%s\n",$2,$1);}' > $CLEAN_BARCODE_FREQ
echo "step 1 done ..."
date
