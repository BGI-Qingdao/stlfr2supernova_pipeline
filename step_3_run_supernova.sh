#!/bin/bash

source ./profile

export PATH=$SUPERNOVA:$PATH

if [[  ! -f $RA || ! -f $I1 ]] ; then
    echo "ERROR : $RA or $I1 not exsist !!! Exit ... "
    exit;
fi

echo "supernova run step , this will take a long time ..."
date
supernova run --id=$PROJECT_NAME --fastqs=./  #--nopreflight
echo "supernova "
date
supernova mkoutput --style=pseudohap --asmdir="./"$PROJECT_NAME"/outs/assembly" --outprefix="$PROJECT_NAME""_output"


