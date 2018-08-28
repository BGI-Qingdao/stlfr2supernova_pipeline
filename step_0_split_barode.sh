#!/bin/bash

SCRIPT_PATH=`dirname $0`

echo "check profile ... "
date
source ./profile
lane_num=`ls -all $r1 | wc -l`
lane2_num=`ls -all  $r2 | wc -l`
if [[ $lane_num != $lane2_num ]] ; then
    echo "ERROR : Profile error . please make sure all file is correct !!! "
    exit
fi
echo "generate $R1 and $R2 ..."
date
if [[ $lane_num -lt 1 ]] ; then
    echo "ERROR :File not exsit : $r1 . Exit ... "
    exit
elif [[ $lane_num -eq 1 ]] ; then 
    echo "Only 1 lane detect in $r1 . "
    ln -s $r1  $R1 ;
    ln -s $r2  $R2 ;
else 
    echo "$lane_num  lanes detect in $r1 . "
    echo "Start cat all files into tmp_r1.fq.gz ... "
    cat $r1 >$R1;
    cat $r2 >$R2;
    echo "Cat end ... "
fi

echo "split barcode ... "
date
$SCRIPT_PATH/bin/split_barcode.pl $SCRIPT_PATH/data/barcode.list  $R1 $R2 $SPLIT
echo "done step 0 ..."
date


