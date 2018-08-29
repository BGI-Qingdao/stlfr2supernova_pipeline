#!/bin/bash

SCRIPT_PATH=`dirname $0`
source ./profile

if [[ ! -f _step_0_end.txt ]] ; then 
    # run step 0 
    echo `date` >>_step_0_start.txt
    $SCRIPT_PATH/step_0_split_barode.sh || exit 1
    echo `date` >>_step_0_end.txt
fi

if [[ USE_FILTER == "yes" ]] ; then 
    if [[ ! -f _step_1_end.txt ]] ; then 
        # run step 1
        echo `date` >>_step_1_start.txt
        $SCRIPT_PATH/step_1_filter.sh || exit 1
        echo `date` >>_step_1_end.txt
    fi
fi

if [[ ! -f _step_2_end.txt ]] ; then 
    # run step 2
    echo `date` >>_step_2_start.txt
    $SCRIPT_PATH/step_2_fake_10X_data.sh || exit 1
    echo `date` >>_step_2_end.txt
fi

if [[ ! -f _step_3_end.txt ]] ; then 
    # run step 2
    echo `date` >>_step_3_start.txt
    $SCRIPT_PATH/step_3_run_supernova.sh || exit 1
    echo `date` >>_step_3_end.txt
fi

