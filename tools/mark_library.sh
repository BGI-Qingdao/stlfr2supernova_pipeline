#!/bin/bash

if [[ $# != 2 ]] ; then
    echo "Usage   :  ./mark_library.sh <input_file> <lib_id>"
    echo "Example :  ./mark_library.sh split_reads1.fq.gz 2"
    echo "              above command will change valid barcode from x_x_x into lib2_x_x_x;"
    echo "              notice : lib_id need greater than 0;"
    echo "              notice : input_file need ended by \".gz\" if it is gzip format;"
    echo "              "
    exit 
fi

input_file=$1
lib_id=$2
if [[ $lib_id -lt 1 ]] ; then 
    echo "invalid lib_id : $lib_id  exit ..."
    exit 1
fi
if [[ ! -f $input_file ]] ; then 
    echo "invalid input_file: $input_file exit ... "
    exit 1
fi
if [[ ${input_file: -3} == ".gz" ]] ; then
    gzip -dc $input_file | awk -F '#|/' -v lib_id=$lib_id '{if(NR%4==1&&NF>1&&$2!="0_0_0"){printf("%s#lib%s_%s/%s\n",$1,lib_id,$2,$3);}else print $0; }' -
else
    awk -F '#|/' -v lib_id=$lib_id '{if(NR%4==1&&NF>1&&$2!="0_0_0"){printf("%s#Lib%s_%s/%s\n",$1,lib_id,$2,$3);}else print $0; }' $input_file
fi
