#
#   baisc settings below 
#  MODIFY HERE FOR YOU PROJECT !!!
#
r1="L1.1.fq.gz L2.1.fq.gz"
r2="L1.2.fq.gz L2.2.fq.gz"
PROJECT_NAME="Human"
THREADS=80
MEMORY=100 #GB
USE_FILTER="yes"
#
#   exec path below
#
#  MODIFY HERE FOR YOU ENVIROMENT !!!

#this is a directory
SUPERNOVA="/ldfssz1/ST_OCEAN/USER/guolidong/supernova-2.0.0/"  
#this is a exec file
SOAP_FILTER="/hwfssz1/ST_OCEAN/USER/guolidong/stLFR/data_pipeline/SOAPfilter_v2.2.1/SOAPfilter_v2.2"

#
#   files that will be generated/needed below .
#       DO NOT MODIFY BELOW
# UNLESS YOU KNOW WHAT YOU ARE DOING.
#
R1="tmp_r1.fq.gz"
R2="tmp_r2.fq.gz"
SPLIT="split_reads"
BARCODE_FREQ="./barcode_freq.txt"
MERGE="merge.txt"
RA="read-RA_si-TTCACGCG_lane-001-chunk-001.fastq.gz"
I1="read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz"
