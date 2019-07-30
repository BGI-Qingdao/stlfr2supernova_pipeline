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

mv $PROJECT_NAME"_output.fasta.gz" $OUTDIR
mv split_read_stat.log  $OUTDIR
mv $PROJECT_NAME/outs/report.txt $OUTDIR
mv profile $OUTDIR

#################################
#
# Collect temporary files
#
#################################

if [[ -f $R1 ]] ; then
    mv $R1 $TMPDIR
    mv $R2 $TMPDIR
fi
mv $SPLIT".1.fq.gz"  $TMPDIR
mv $SPLIT".2.fq.gz"  $TMPDIR
if [[ -f $SPLIT".1.fq.gz.clean.gz" ]] ; then
    mv $SPLIT".1.fq.gz.clean.gz" $TMPDIR
    mv $SPLIT".2.fq.gz.clean.gz" $TMPDIR
fi
mv $BARCODE_FREQ $TMPDIR
if [[ -f $CLEAN_BARCODE_FREQ ]] ; then
    mv $CLEAN_BARCODE_FREQ $TMPDIR
fi
mv read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz $TMPDIR
mv read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz $TMPDIR
mv read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz $TMPDIR
mv sample_S1_L001_I1_001.fastq.gz $TMPDIR
mv sample_S1_L001_R1_001.fastq.gz $TMPDIR
mv sample_S1_L001_R2_001.fastq.gz $TMPDIR
mv $MERGE $TMPDIR
mv $PROJECT_NAME $TMPDIR
mv *.log $TMPDIR
mv *.err $TMPDIR
mv _step* $TMPDIR
mv lane.lst $TMPDIR

