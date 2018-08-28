#!/bin/bash

SCRIPT_PATH=`dirname $0`
source ./profile
echo "Check input files ..."
date
WL=`ls $SUPERNOVA/supernova-cs/*/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt`
if [[ ! -f $WL ]] ; then 
    echo "ERROR : no barcode white list found in $SUPERNOVA/supernova-cs/*/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt"
    echo "Exit ..."
    exit 
fi
if [[ -f $BARCODE_FREQ ]] ; then 
    echo "ERROR : file $BARCODE_FREQ is not exsist !!! Exit ..."
    exit;
fi
echo "Generate $MERGE ..."
date
$SCRIPT_PATH/bin/merge_barcode.pl $BARCODE_FREQ  $WL $MERGE 0
echo "Fake 10X data . this will take a long time ... "
date
$SCRIPT_PATH/bin/fake_10x.pl  $SPLIT.1.fq.gz $SPLIT.2.fq.gz $MERGE
echo "done step 2 ..."
date


