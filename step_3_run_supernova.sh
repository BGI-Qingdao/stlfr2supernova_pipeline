#!/bin/bash

source ./profile

export PATH=$SUPERNOVA:$PATH

if [[  ! -f $RA || ! -f $I1 ]] ; then
    echo "ERROR : $RA or $I1 not exsist !!! Exit ... "
    exit 1; 
fi

echo "supernova run step , this will take a long time ..."
date
tag=`date +_%m_%d_%H_%M_%S`
supernova run --id=$PROJECT_NAME --maxreads=$MAX_READS  --fastqs=./ --localcores=$THREADS --localmem=$MEMORY --nopreflight >supernova_run_"$tag".log 2>supernova_run_"$tag".err || exit 1
echo "supernova mkoutput"
date
tag=`date +_%m_%d_%H_%M_%S`
supernova mkoutput --style=pseudohap --asmdir="./"$PROJECT_NAME"/outs/assembly" --outprefix="$PROJECT_NAME""_output"  >supernova_mkoutput_"$tag".log  2>supernova_mkoutput_"$tag".err || exit 1
echo "done step 3 ..."
date


