#
#   basic settings below 
#  MODIFY HERE FOR YOU PROJECT !!!
#
r1="L1.1.fq.gz L2.1.fq.gz"  # the stLFR raw read1. differnt lane use " " to seperate.
r2="L1.2.fq.gz L2.2.fq.gz"  # the stLFR raw read2. differnt lane use " " to seperate.
USE_FILTER="yes"            # yes or no. # use SOAPFilter or not
BARCODE_FREQ_THRESHOLD=2    # if a barcode's read-pair num is less then BARCODE_FREQ_THRESHOLD, drop it.
MAP_RATIO=8                 # map MAP_RATIO stLFR barcode into 1 10X barcode
# below are baisc parameters for supernova assembler
PROJECT_NAME="Human"        # supernova's --id
THREADS=80                  # supernova's --localcores
MEMORY=100 #GB              # supernova's --localmem
MAX_READS=1200000000        # supernova's --maxreads #    for supernova version <= 2.10
#MAX_READS=2140000000 #for supernova 2.11

#
#   exec path below
#
#  MODIFY HERE FOR YOU ENVIROMENT !!!

# "SCRIPT_PATH" is the YOUR-INSTALL-DIR directory .
SCRIPT_PATH="~/software/stlfr2supernova/"
#"SUPERNOVA" is the executing directory of supernova. Different version number can be accepted.
SUPERNOVA="~/software/supernova-2.0.0/"  
#"SOAP_FILTER is the executing diretory of SOAPFilter
SOAP_FILTER="/hwfssz1/ST_OCEAN/USER/guolidong/stLFR/data_pipeline/SOAPfilter_v2.2.1/SOAPfilter_v2.2"

#
#   intermediate files that will be generated/needed below .
#       DO NOT MODIFY BELOW
# UNLESS YOU KNOW WHAT YOU ARE DOING.
#
R1="tmp_r1.fq.gz"                   # A symbol-link if raw reads only contain 1 lane, a concatenate of all lane otherwise.
R2="tmp_r2.fq.gz"
SPLIT="split_reads"                 # the prefix of splited reads. split_reads.1.fq.gz & split_reads.2.fq.gz
BARCODE_FREQ="./barcode_freq.txt"   # the barcode frequence information
CLEAN_BARCODE_FREQ="./clean_barcode_freq.txt"   # the barcode frequence information after filter.
MERGE="merge.txt"                   # the stLFR->10X barcode mapping information 
SUPERNOVA_R1="read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
SUPERNOVA_I1="read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
SUPERNOVA_R2="read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
