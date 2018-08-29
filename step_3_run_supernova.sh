#!/bin/bash

source ./profile

export PATH=$SUPERNOVA:$PATH

if [[  ! -f $RA || ! -f $I1 ]] ; then
    echo "ERROR : $RA or $I1 not exsist !!! Exit ... "
    exit 1; 
fi

echo "supernova run step , this will take a long time ..."
date
supernova run --id=$PROJECT_NAME --fastqs=./ --localcores=$THREADS --localmem=$MEMORY --nopreflight || exit 1
echo "supernova mkoutput"
date
supernova mkoutput --style=pseudohap --asmdir="./"$PROJECT_NAME"/outs/assembly" --outprefix="$PROJECT_NAME""_output" || exit 1
echo "done step 3 ..."
date


