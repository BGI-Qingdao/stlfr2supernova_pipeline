# stLFR to Supernova

## <a name=intro>Introduction</a>

- The stLFR2Supernova is a pipeline to de novo assemble the stLFR raw reads using Supernova Assembler. 
    -  stLFR raw reads refer to the raw reads generated by single-tube Long Fragment Read (stLFR) platform from BGI [1].
    -  Supernova Assembler refers to the de-novo software from 10X Genomes [2].

## <a name=contents>Table of Contents</a>

- [Introduction](#intro)
- [Table of Contents](#contents)
- [User's Guide](#user-guide)
    - [Installation](#install)
    - [Structure of the files](#files)
    - [General usage](#usage)
    - [Profile file](#profile)
    - [Other scenarios](#scenarios)
         - [How to start from stLFR reads which already split barcode](#start-stlfr)
         - [How to start from stLFR clean reads which already split barcode & remove PCR dup and filter adaptor](#start-stlfr-clean)
         - [How to get 10XG reads from stLFR raw reads without run supernova](#fake-only)
- [Frequent Q & A](#use-cases)
- [Miscellaneous](#misc)
- [Reference](#ref)
- [Contact](#ref)
- [Appendix](#appendix)
    - [Appendix A : an example of stLFR raw reads](#stlfr_raw)
    - [Appendix B : an example of stLFR reads](#stlfr)
    - [Appendix C : an example of 10X reads](#10X)

## <a name=user-guide>User's Guide</a>

### <a name=install>Installation</a>


```
git clone --recursive https://github.com/BGI-Qingdao/stlfr2supernova_pipeline.git YOUR-INSTALL-DIR
```
or 
```
git clone https://github.com/BGI-Qingdao/stlfr2supernova_pipeline.git  YOUR-INSTALL-DIR
cd YOUR-INSTALL-DIR
git submodule init
git submodule update
```


*Written by Perl and Shell languages.*
*Unnecessary to do extra compilation or installation. No other dependencies.*

### <a name=files>Structure of the files</a>

```
├── README.md
├── bin
│   ├── SOAPfilter_v2.2         # filters duplication & adaptors.
│   ├── split_barcode.pl        # splits raw reads, get barcode sequences, and convert stLFR raw reads to stLFR reads.
│   ├── merge_barcodes.pl       # randomly merges each 8 stLFR barcodes to 1 10X-format barcode.
│   └── fake_10x.pl             # converts stLFR reads to 10X reads.
├── data
│   ├── barcode.list            # barcode list of stLFR.
│   └── lane.lst                # config for SOAPfilter.
├── profile                     # default profile.
├── run.sh                      # 1-step executable script, which calls all four substeps 0 ~ 3.
├── step_0_split_barode.sh      # calls split_barcode.pl and generate split_reads.*.fq.gz & barcode_freq.txt.
├── step_1_filter.sh            # calls SOAPfilter_v2.2 and generate split_reads.*.fq.gz.clean.gz.
├── step_2_fake_10X_data.sh     # calls merge_barcodes.pl & fake_10x.pl and generate merge.txt & read-R*_si-TTCACGCG_lane-001-chunk-001.fastq.gz.
└── step_3_run_supernova.sh     # calls Supernova Assmebler.
```

### <a name=usage>General usage</a>

- 1st, create a new work folder

```
> mkdir YourProjectRoot
```

- 2nd, copy the default profile into your work folder

```
> cd YourProjectRoot
> cp YOUR-INSTALL-DIR/profile ./your_own_profile
```
    **Do not change the filename. Always use "profile".**

- 3rd, edit your_own_profile

```
> vi ./your_own_profile 
```
- 4th, run the 1-step executable script with your profile or run it step by step

    - 4.1 run the 1-step executable script
```
> YOUR-INSTALL-DIR/run.sh  # make sure your run this command in YourProjectRoot
```
-   - 4.2 run the pipeline step by step or just run what you want

```
> YOUR-INSTALL-DIR/step_x_xxxx.sh # make sure your run this command in YourProjectRoot
```

### <a name=profile>The profile file</a>

**Do not change the filename. Always use "profile".**

**Make sure the profile file is in YourProjectRoot directory.**

**please double check your adaptor sequences by contact your raw data supplier.**

```
#
#   basic settings below 
#  MODIFY HERE FOR YOU PROJECT !!!
#
r1="L1.1.fq.gz L2.1.fq.gz"  # stLFR raw read1. use " " to seperate differnt lanes.
r2="L1.2.fq.gz L2.2.fq.gz"  # stLFR raw read2. use " " to seperate differnt lanes.
USE_FILTER="yes"            # yes or no. # use SOAPFilter or not
# 0. if USE_FILTER=no , then skip this.
# 1. please double check your adaptor sequences by contact your raw data supplier.
# 2. please assign the correct sequence to ADAPTOR_F & ADAPTOR_R if USE_FILTER=yes
# 
# an example of adaptor sequences.
#ADAPTOR_F='AAGTCGGAGGCCAAGCGGTCTTAGGAAGACAA'           # SOAPfilter -F
#ADAPTOR_R='AAGTCGGATCGTAGCCATGTCGTTCTGTGAGCCAAGGAGTT'  # SOAPfilter -R
# other optional adaptor :
#ADAPTOR_F='CTGTCTCTTATACACATCTTAGGAAGACAAGCACTGACGACATGA'
#ADAPTOR_R='TCTGCTGAGTCGAGAACGTCTCTGTGAGCCAAGGAGTTGCTCTGG'
# other optional adaptor :
#ADAPTOR_F='CTGTCTCTTATACACATCTTAGGAAGACAAGCACTGACGACATGATCACCAAGGATCGCCATAGTCCATGCTAAAGGACGTCAGGAAGGGCGATCTCAGG'
#ADAPTOR_R='TCTGCTGAGTCGAGAACGTCTCTGTGAGCCAAGGAGTTGCTCTGGCGACGGCCACGAAGCTAACAGCCAATCTGCGTAACAGCCAAACCTGAGATCGCCC'
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

```
### <a name=scenarios>Other scenarios</a>

*If you have already finished the data preprocess and begin the downstream analysis with stLFR reads with barcode IDs or cleaned stLFR reads, then please use this pipeline*

#### <a name=start-stlfr>From stLFR reads with barcode ID in read names instead of sequences</a>

*If barcode_freq.txt does not exist, use the command in Q & A section to generate it*

```
mkdir work
cd work
ln your-path-to-reads/barcode_freq.txt ./ 
ln your-path-to-reads/reads1.fq.gz split_reads.1.fq.gz
ln your-path-to-reads/reads2.fq.gz split_reads.2.fq.gz
cp your-path-to-stlfr2supernova/profile ./
#
# Edit profile , make sure SCRIPT_PATH & SUPERNOVA is valid
#
touch _step_0_end.txt # to avoid split reads step
your-path-to-stlfr2supernova/run.sh >log 2>err
#Done now
```


#### <a name=start-stlfr-clean>From stLFR clean reads with barcode ID in read names & PCR dup and adaptor removed</a>

##### A useful scrip in this scenario is here : https://github.com/BGI-Qingdao/stlfr2supernova_pipeline/tree/master/clean_stLFR_data2supernova

##### Otherwise, try commands below 
*If clean_barcode_freq.txt does not exist, use the command in Q & A section to generate it*
```
mkdir work
cd work
ln your-path-to-reads/clean_barcode_freq.txt ./ 
ln your-path-to-reads/reads1.fq.gz split_reads.1.fq.gz.clean.gz
ln your-path-to-reads/reads2.fq.gz split_reads.2.fq.gz.clean.gz
cp your-path-to-stlfr2supernova/profile ./
#
# Edit profile , make sure SCRIPT_PATH & SUPERNOVA is valid
#
touch _step_0_end.txt # to avoid split reads step
touch _step_1_end.txt # to avoid SOAPfilter step
your-path-to-stlfr2supernova/run.sh >log 2>err
#Done now
```

#### <a name=fake-only>How to get 10X Genomics format without run supernova</a>

```
touch _step_3_end.txt #stop run supernova

# other step follow full pipeline 
```
## <a name=use-cases>Frequent Q & A</a>

- If there is no file "barcode_freq.text" (or clean_barcode_freq.txt) in the directory "YourProjectRoot", then you can re-generate it with split_reads.1.fq.gz ( or split_reads.1.fq.gz.clean.gz) following the command below 

```
# to generate barcode_freq.txt
gzip -dc split_reads.1.fq.gz |  awk -F '#|/' '{if(NR%4==1&&NF>1)t[$2]+=1}END{for(x in t ) printf("%s\t%s\n",x,t[x]);}' > barcode_freq.txt 

#  to generate clean_barcode_freq.txt
gzip -dc split_reads.1.fq.gz.clean.gz |  awk -F '#|/' '{if(NR%4==1&&NF>1)t[$2]+=1}END{for(x in t ) printf("%s\t%s\n",x,t[x]);}'  >clean_barcode_freq.txt

```

- Why is the number of 10X reads smaller than that of the initial stLFR clean reads ?
    - 1st. Reads sharing the "0_0_0" barcode are discarded since it refers to the barcode-decode-failure.
    - 2nd. Very few reads sharing the same barcode are discarded since the barcode information is useless. Your can adjust it by changing BARCODE_FREQ_THRESHOLD.
    - 3rd. The number of stLFR barcodes is much larger than that of 10X barcodes.  Supernova can only accept reads up to # of 10 X barcodes * MAP_RATIO. Overflow part is discarded ! 
        - stLFR has ~1.8 billion unique barcodes
        - 10X has 4,792,320 unique barcodes

- How to get barcode.fastq.gz ( the 10XG format ) from stlfr reads ? 

```
perl ./tools/stlfr2barcode_fq_gz.pl  split_reads.1.fq.gz split_reads.2.fq.gz | gzip - >barcode.fastq.gz
```

## <a name=misc>Miscellaneous</a>

- Requirements
    - Linux system && Bash
    - Perl
    - Supernova Assembler
    - SOAPFilter ( optional )
- Limitations
    - We can only do what Supernova can do.
- Resources
    - There are two steps that might cause huge memory cost:
        - step_0_split_barode.sh . this cost depends on your raw reads.
        - step_3_run_supernova.sh. this cost can be limited by MEMORY ( in profile ).
    - Only step_3_run_supernova.sh suports multi-threads ( by Supernova ).

## <a name=ref>Reference</a>

[1] [Efficient and unique co-barcoding of second-generation sequencing reads from long DNA molecules enabling cost effective and accurate sequencing, haplotyping, and de novo assembly][11]
 
[2] [Direct determination of diploid genome sequences][22]

[11]: https://www.ncbi.nlm.nih.gov/pubmed/30940689 
[22]: https://www.ncbi.nlm.nih.gov/pubmed/28381613 

## <a name=contact>Contact</a>

- please contact guolidong@genomics.cn 
- or please creat an issue in github.

## <a name=appendix>Appendix</a>

### <a name=stlfr_raw>Appendix A : an example of stLFR raw reads</a>

- Read1 of stLFR raw reads

*There is no barcode information within read1*

```
@CL100117953L1C001R001_1/1
GGCCGGGGACTCAGGGAGAGATTCTAAGCTCTCTGTATGTGGAAGGCTCGCGAGACAGGAAACACACAAGACACGGGCGTTGTATACAGGTTCGGGCCGC
+
FGFFFFEF9FEFFFFFCF;FEA4EFE4FFFFGFGFCFFFEEFDDFE??@FCFCF<FGFEDFFF=F@)FFFF:D;9FCFF(:GEECG8F?F>E/FFCFFF0
@CL100117953L1C001R001_3/1
CCACCACGCCATTTGCTCCGAGAAGACAGCTACAACGCATGCGTATATAATAGAAACGCTCGTGCAAAACAAACTATATATAAAAAAATGATGACCAATG
+
<BE3BBAECB@CEBFBBD2F/EA>ABABDECFEEFCCAEB@BE%>8AAEAECE/;B=E6D<F6EC@FD93DB7E@;=??E/FFDDEB;EF;EF%C4E?EE
@CL100117953L1C001R001_4/1
CACCGATCCACAAGAGGCCTTACAGAATGGGAGCCAGCGAGTTGGCGGAAGTCAAGAAGCAAGTCGATGAACAGTTATAGAAGGGATACATCCGTCCGAG
+
FFFFFFFFFFFFFFEF>FFFFFFFFFFEFFFFFFFFFFFFFFEFFFFFCEF>FF>GCAFBFFFFFF;7FEFFCFE9FAFFEFFFF<=;'8EFFFAF=FFF
```

- Read2 of stLFR raw reads

*The last 42-bp sequence provides the stLFR barcode information within read2*

*There are 3 acceptable types of stLFR raw read2: 126bp or 142bp or 154bp. If your read2 does not belong to one of them, then it will stop. *

```
@CL100117953L1C001R001_1/2
GGGTATTACGCTTCTCAGCGGCCCGAACCTGTATACATCGCCCGTGTCTTGTGTGTTTCCTGTCTCGCGAGCCTTCCACATACAGAGAGCTTAGAATCTCATTACTAACGTCTTNTCTACAATACGAGGTTTTTGAGGAGAC
+
FFF*BF5FFFFGFFEFFFFEFFFFG@AFFFFFFFFFFFFFFFEFFFEFFFFEFDFBFDEFFGAFFFFFF(FEFFFFFEFD<AFFF<FB7FFFFF>;3EEEFFFFCFFFFFCE@6!0FFE;FFFFFF6.*D,CAFFFFFEFFF
@CL100117953L1C001R001_3/2
CAACAGCACTAGCTGGTGTCACGTGATCATCTCTGNAGATTTTCCTCTCTCTTCGCCTGGCGATGGGTTAGCACATTGNCAGAGGTAGTATCTATCANCGCAGGTATAAGCACTNCTCGAACGCCAATATTAAAGTTCGACC
+
.14,.<84,9B9(<?8>B,381B'?+841'9/69<!46;8'+?;3.,81693)48/1@/+)819&,6+344,69;(48!98%?6/+7/%))1.,(>.!))3<>91@@DBC%C&+!.;4C.44@4;E4'%'>9)1@AE3B:3?
@CL100117953L1C001R001_4/2
AGTCAACGCACATCCTCTTGGTTTTGTCTTTCTTCTCCACAAAGATAACCGGAGCACCCCAAGGCGACGTGCTCGGACGGATGTATCCCTTCTATAACGGCGACCACTGATCTGAGGCGTTAACGCGATGATTTGACATCTC
+
EFD8DBFFEFFFFEFFFFFFFFDCDFEFEFFFFFFFFFFFCEFFEEFFFFFFDFFFFFEFFEFFFFDFFDFFFFFF>EFFD>F<6FFFD'FF9FA;,D+9FFBFFFFFFD&>5(&>FFFFDFEFFFFE(F5FDFFEFFFFFF
```

### <a name=stlfr>Appendix B : an example of stLFR reads</a>

- Read1 of stLFR reads

*The barcode information is appended at the header line. #xxx_xxx_xxx part is the barcode.*

```
@CL100117953L1C001R001_1#844_1383_927/1 1       1
GGCCGGGGACTCAGGGAGAGATTCTAAGCTCTCTGTATGTGGAAGGCTCGCGAGACAGGAAACACACAAGACACGGGCGTTGTATACAGGTTCGGGCCGC
+
FGFFFFEF9FEFFFFFCF;FEA4EFE4FFFFGFGFCFFFEEFDDFE??@FCFCF<FGFEDFFF=F@)FFFF:D;9FCFF(:GEECG8F?F>E/FFCFFF0
@CL100117953L1C001R001_3#1469_851_342/1 2       1
CCACCACGCCATTTGCTCCGAGAAGACAGCTACAACGCATGCGTATATAATAGAAACGCTCGTGCAAAACAAACTATATATAAAAAAATGATGACCAATG
+
<BE3BBAECB@CEBFBBD2F/EA>ABABDECFEEFCCAEB@BE%>8AAEAECE/;B=E6D<F6EC@FD93DB7E@;=??E/FFDDEB;EF;EF%C4E?EE
@CL100117953L1C001R001_4#643_1473_309/1 3       1
CACCGATCCACAAGAGGCCTTACAGAATGGGAGCCAGCGAGTTGGCGGAAGTCAAGAAGCAAGTCGATGAACAGTTATAGAAGGGATACATCCGTCCGAG
+
FFFFFFFFFFFFFFEF>FFFFFFFFFFEFFFFFFFFFFFFFFEFFFFFCEF>FF>GCAFBFFFFFF;7FEFFCFE9FAFFEFFFF<=;'8EFFFAF=FFF
```

- Read2 of stLFR reads

*The barcode information is appended at the header line. #xxx_xxx_xxx part is the barcode.*

```
@CL100117953L1C001R001_1#844_1383_927/2 1       1
GGGTATTACGCTTCTCAGCGGCCCGAACCTGTATACATCGCCCGTGTCTTGTGTGTTTCCTGTCTCGCGAGCCTTCCACATACAGAGAGCTTAGAATCTC
+
FFF*BF5FFFFGFFEFFFFEFFFFG@AFFFFFFFFFFFFFFFEFFFEFFFFEFDFBFDEFFGAFFFFFF(FEFFFFFEFD<AFFF<FB7FFFFF>;3EEE
@CL100117953L1C001R001_3#1469_851_342/2 2       1
CAACAGCACTAGCTGGTGTCACGTGATCATCTCTGNAGATTTTCCTCTCTCTTCGCCTGGCGATGGGTTAGCACATTGNCAGAGGTAGTATCTATCANCG
+
.14,.<84,9B9(<?8>B,381B'?+841'9/69<!46;8'+?;3.,81693)48/1@/+)819&,6+344,69;(48!98%?6/+7/%))1.,(>.!))
@CL100117953L1C001R001_4#643_1473_309/2 3       1
AGTCAACGCACATCCTCTTGGTTTTGTCTTTCTTCTCCACAAAGATAACCGGAGCACCCCAAGGCGACGTGCTCGGACGGATGTATCCCTTCTATAACGG
+
EFD8DBFFEFFFFEFFFFFFFFDCDFEFEFFFFFFFFFFFCEFFEEFFFFFFDFFFFFEFFEFFFFDFFDFFFFFF>EFFD>F<6FFFD'FF9FA;,D+9
```

### <a name=10x>Appendix C : an example of 10X reads</a>

- Read1 of 10X reads

*The first 23-bp sequence is the 16-bp-10X-barcode + 7-bp-adaptor within read1*

```
@ST-E0:0:SIMULATE:8:0:0:1 1:N:0:NAAGTGCT
CGGGTGTCACGCACCAATCGAGNGGCCGGGGACTCAGGGAGAGATTCTAAGCTCTCTGTATGTGGAAGGCTCGCGAGACAGGAAACACACAAGACACGGGCGTTGTATACAGGTTCGGGCCGC
+
FFFFFFFFFFFFFFFFFFFFFF#FGFFFFEF9FEFFFFFCF;FEA4EFE4FFFFGFGFCFFFEEFDDFE??@FCFCF<FGFEDFFF=F@)FFFF:D;9FCFF(:GEECG8F?F>E/FFCFFF0
@ST-E0:0:SIMULATE:8:0:0:2 1:N:0:NAAGTGCT
TCAACGACACACATACATCGAGNCACCGATCCACAAGAGGCCTTACAGAATGGGAGCCAGCGAGTTGGCGGAAGTCAAGAAGCAAGTCGATGAACAGTTATAGAAGGGATACATCCGTCCGAG
+
FFFFFFFFFFFFFFFFFFFFFF#FFFFFFFFFFFFFFEF>FFFFFFFFFFEFFFFFFFFFFFFFFEFFFFFCEF>FF>GCAFBFFFFFF;7FEFFCFE9FAFFEFFFF<=;'8EFFFAF=FFF
@ST-E0:0:SIMULATE:8:0:0:3 1:N:0:NAAGTGCT
TAGCTCCAGTTCGCGCATCGAGNGCCGTTCTTAGTTGGTGGAGCGATTTGTCTGGTTAATTCCGTTAACGAACGAGACCTCAGCCTGCTAACTAGCTATGCGGAGCCATCCCCCCGCGGCAAG
+
FFFFFFFFFFFFFFFFFFFFFF#E>EEFFAGEFBGAEG7EDFEEGFFFFDCEEFGFBE3DEFDF3FEF>GDF;EFEF?AFG>GFFFDDGAFEEF3FE@D?-EF64EF8CEFA*FD<E+GG'D,
@ST-E0:0:SIMULATE:8:0:0:4 1:N:0:NAAGTGCT
GGAACTTAGCCCAGCTATCGAGNCGACGCGAGGCGATCCTAGGGAAAGCTCCGAAGGTAGGACCGCCTCGGCGCCATACACCAGGAAAAAGGGCGTTTCCCCCGTGGCGCGGCTTGGGGTGGT
+
FFFFFFFFFFFFFFFFFFFFFF#FFCFGFGEFFFFFFFFF>FFFCEFGFEFFGCFFFFFFC@FDDFFFFF>FGFFFFFAFFEFFEFFEEFFF9FFFCFFFFFFGFE*FFEFF<FAEF3C'FF*
```

- Read2 of 10X reads

*There is no barcode information within read2*
```
@ST-E0:0:SIMULATE:8:0:0:1 2:N:0:NAAGTGCT
GGGTATTACGCTTCTCAGCGGCCCGAACCTGTATACATCGCCCGTGTCTTGTGTGTTTCCTGTCTCGCGAGCCTTCCACATACAGAGAGCTTAGAATCTC
+
FFF*BF5FFFFGFFEFFFFEFFFFG@AFFFFFFFFFFFFFFFEFFFEFFFFEFDFBFDEFFGAFFFFFF(FEFFFFFEFD<AFFF<FB7FFFFF>;3EEE
@ST-E0:0:SIMULATE:8:0:0:2 2:N:0:NAAGTGCT
AGTCAACGCACATCCTCTTGGTTTTGTCTTTCTTCTCCACAAAGATAACCGGAGCACCCCAAGGCGACGTGCTCGGACGGATGTATCCCTTCTATAACGG
+
EFD8DBFFEFFFFEFFFFFFFFDCDFEFEFFFFFFFFFFFCEFFEEFFFFFFDFFFFFEFFEFFFFDFFDFFFFFF>EFFD>F<6FFFD'FF9FA;,D+9
@ST-E0:0:SIMULATE:8:0:0:3 2:N:0:NAAGTGCT
TCCGTGGCCTAAACGGCCATAGTCCCTCTAAGAAGCTAGCTGCGGAGGGATGGCTCCGCATAGCTAGTTAGCAGGCTGAGGTCTCGTTCGTTAACGGAAT
+
FFFG@FFFDFFFEFGFFFF@FGEFFFFFFF@F<FFF6FGFEFFFE;FFFAEFFFE;FFFEDFF:>FFF)DFFFFFFBB?CF@FFFF(FEF@5/D@EF91F
```
