#!/bin/bash

if [[ $1 == "h" || $1 == "-h" || $1 == "--help" ]] ; then 
    echo "usage : run this script in your-working-folder."
    echo "        it will : "
    echo "                 mv output files into Final_Output_TAG. "
    echo "                 mv temporary files into Final_TEMP_TAG. "
    echo "                 TAG is a timestamp. "
    echo "                 remove Final_TEMP_TAG only after double checking of output's correctness."
    exit 0
fi


#################################
#
# Checking working direcory
#
#################################
if [[ ! -f ./profile ]] ; then 
    echo "error : no profile found in current folder ! exiting ..."
    echo "info  : $0 -h will print usage !"
    exit 1;
fi
source ./profile

#################################
#
# Create archiving folder
#
#################################

TAG=`date +%s`
echo "info  : current timestamp is $TAG"
OUTDIR="Final_Output_"$TAG
TMPDIR="Final_TEMP_"$TAG
mkdir $OUTDIR
mkdir $TMPDIR

if [[ ! -d $OUTDIR || ! -d $TMPDIR ]] ; then 
    echo "error : failed to create archiving folders ! exiting ..."
    echo "info  : $0 -h will print usage !"
    exit 1 
fi
#################################
#
# Collect outputs and logs
#
#################################

mv $PROJECT_NAME"_output" $OUTDIR
mv split_read_stat.log  $OUTDIR
mv $PROJECT_NAME/outs/report.txt
mv profile $OUTDIR

#################################
#
# Collect temporary files
#
#################################

mv $R1 $TMPDIR
mv $R2 $TMPDIR
mv "$SPLIT""*"  $TMPDIR
mv $BARCODE_FREQ $TMPDIR
if [[ -f $CLEAN_BARCODE_FREQ ]] ; then 
    mv $CLEAN_BARCODE_FREQ $TMPDIR
fi
mv $MERGE $TMPDIR
mv $PROJECT_NAME $TMPDIR
mv *.log $TMPDIR
mv *.err $TMPDIR
mv lane.lst $TMPDIR
