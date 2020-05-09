#
#   basic settings below 
#  MODIFY HERE FOR YOU PROJECT !!!
#
r1="L1.1.fq.gz L2.1.fq.gz"  # stLFR raw read1. use " " to seperate differnt lanes.
r2="L1.2.fq.gz L2.2.fq.gz"  # stLFR raw read2. use " " to seperate differnt lanes.
USE_FILTER="yes"            # yes or no. # use SOAPFilter or not
BARCODE_FREQ_THRESHOLD=1    # if the number of read pairs sharing the same barcode
                            #    is smaller then BARCODE_FREQ_THRESHOLD, 
                            #    then discard the barcode.
                            # if BARCODE_FREQ_THRESHOLD=1 then use all valid barcode.
                            # if BARCODE_FREQ_THRESHOLD=2 then barcode with only 1
                            #    pair of reads will be discard.

# below are baisc parameters for supernova assembler
PROJECT_NAME="Human"        # supernova's --id
THREADS=80                  # supernova's --localcores
MEMORY=100 #GB              # supernova's --localmem
MAX_READS=1200000000        # supernova's --maxreads #    for supernova version <= 2.10
MINSIZE=200                 # supernova's --minsize
#MAX_READS=2140000000 #for supernova 2.11

#
#   exec path below
#
#  MODIFY HERE FOR YOU ENVIROMENT !!!

# "SCRIPT_PATH" is the YOUR-INSTALL-DIR directory .
SCRIPT_PATH="~/software/stlfr2supernova/"
#"SUPERNOVA" is the executable path of supernova. Various versions are acceptable.
SUPERNOVA="~/software/supernova-2.0.0/"

#
#   intermediate files that will be generated/needed below .
#       DO NOT MODIFY BELOW
# UNLESS YOU KNOW WHAT YOU ARE DOING.
#

#"SOAP_FILTER is the executable path of SOAPFilter
SOAP_FILTER=$SCRIPT_PATH"/bin/SOAPfilter_v2.2"
R1="tmp_r1.fq.gz"                   # the symbol-link concatenating different lanes.
R2="tmp_r2.fq.gz"
SPLIT="split_reads"                 # the prefix of splitted reads. split_reads.1.fq.gz & split_reads.2.fq.gz
BARCODE_FREQ="./barcode_freq.txt"   # the barcode frequence information
CLEAN_BARCODE_FREQ="./clean_barcode_freq.txt"   # the barcode frequence information after filter.
MERGE="merge.txt"                   # the stLFR->10X barcode mapping information 
SUPERNOVA_R1="read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
SUPERNOVA_I1="read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
SUPERNOVA_R2="read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz" # the output 10X reads
