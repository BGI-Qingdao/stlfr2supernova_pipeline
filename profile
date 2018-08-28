#
# baisc input files
#   example :
#       PROJECT_NAME="Human"
#       r1="CL100026175_L01_read_1.fq.gz CL100026175_L02_read_1.fq.gz CL100026179_L01_read_1.fq.gz CL100026179_L02_read_1.fq.gz"
#       r2="CL100026175_L01_read_2.fq.gz CL100026175_L02_read_2.fq.gz CL100026179_L01_read_2.fq.gz CL100026179_L02_read_2.fq.gz"
#
#  MODIFY HERE FOR YOU PROJECT !!!
#
r1="../r1.fq.gz"
r2="../r2.fq.gz"
PROJECT_NAME="Human"

#
# supernova path
#   example :
#       SUPERNOVA="/home/guolidong/software/supernova-2.0.1"
#
#  MODIFY HERE FOR YOU ENVIROMENT !!!
#
SUPERNOVA="/ldfssz1/ST_OCEAN/USER/guolidong/supernova-2.0.0/"

#
# file that generate in middle steps.
#       DO NOT MODIFY 
# UNLESS YOU KNOW WHAT YOU ARE DOING.
#
R1="tmp_r1.fq.gz"
R2="tmp_r2.fq.gz"
SPLIT="split_reads"
BARCODE_FREQ="./barcode_freq.txt"
MERGE="merge.txt"
RA="read-RA_si-TTCACGCG_lane-001-chunk-001.fastq.gz"
I1="read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz"
