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
if [[ ! -f $BARCODE_FREQ ]] ; then 
    echo "ERROR : file $BARCODE_FREQ is not exsist !!! Exit ..."
    exit;
fi

if  [[ $USE_FILTER == "yes" ]] ; then 
    if [[ ! -f $SPLIT.1.fq.gz.clean.gz || ! -f $SPLIT.1.fq.gz.clean.gz ]] ; then 
        echo "error : file $SPLIT.1.fq.gz.clean.gz or $SPLIT.2.fq.gz.clean.gz is not exsist !!! exit ..."
        exit;
    fi
else
    if [[ ! -f $SPLIT.1.fq.gz || ! -f $SPLIT.1.fq.gz ]] ; then 
        echo "error : file $SPLIT.1.fq.gz or $SPLIT.2.fq.gz is not exsist !!! exit ..."
        exit;
    fi
fi

echo "Generate $MERGE ..."
date
$SCRIPT_PATH/bin/merge_barcodes.pl $BARCODE_FREQ  $WL $MERGE 0
echo "Fake 10X data . this will take a long time ... "
date
if [[ $USE_FILTER == "yes" ]] ; then 
    $SCRIPT_PATH/bin/fake_10x.pl  $SPLIT.1.fq.gz.clean.gz $SPLIT.2.fq.gz.clean.gz $MERGE
else 
    $SCRIPT_PATH/bin/fake_10x.pl  $SPLIT.1.fq.gz $SPLIT.2.fq.gz $MERGE
fi
echo "done step 2 ..."
date


